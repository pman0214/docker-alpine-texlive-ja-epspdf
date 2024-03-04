# Copyright (c) 2021-2024 Shigemi ISHIDA
# Released under the MIT license
# https://opensource.org/licenses/MIT

FROM alpine:3.19

ARG GLIBC_VER=2.36
ARG TEXLIVE_VER=2023

ENV LANG=C.UTF-8
ENV GLIBC_URL_BASE=https://github.com/pman0214/docker-glibc-builder/releases/download
ENV PATH=/usr/local/texlive/${TEXLIVE_VER}/bin/x86_64-linux:/usr/local/texlive/${TEXLIVE_VER}/bin/aarch64-linux:$PATH

COPY files /tmp/files

RUN set -x && \
    cd / && \
    apk update && \
    apk add --no-cache --virtual .fetch-deps curl xz && \
    apk add --no-cache --virtual .glibc-bin-deps libgcc && \
    apk add --no-cache perl fontconfig-dev freetype-dev ghostscript && \
    ARCH=$(arch) && \
    if [ ${ARCH} = "aarch64" ]; then ARCH="arm64" ; fi && \
    curl -L ${GLIBC_URL_BASE}/${GLIBC_VER}/glibc-bin-${GLIBC_VER}-${ARCH}.tar.gz | \
      tar zx -C / && \
    mkdir -p /lib64 /usr/glibc-compat/lib/locale /usr/glibc-compat/lib64 && \
    cp /tmp/files/ld.so.conf /usr/glibc-compat/etc/ && \
    cp /tmp/files/nsswitch.conf /etc/ && \
    rm -rf /usr/glibc-compat/etc/rpc && \
    rm -rf /usr/glibc-compat/lib/gconv && \
    rm -rf /usr/glibc-compat/lib/getconf && \
    rm -rf /usr/glibc-compat/lib/audit && \
    rm -rf /usr/glibc-compat/var && \
    for l in /usr/glibc-compat/lib/ld-linux-*; do \
      ln -s $l /lib/$(basename $l); \
      ln -s $l /usr/glibc-compat/lib64/$(basename $l); \
      ln -s $l /lib64/$(basename $l); \
    done && \
    if [ -f /etc/ld.so.cache ]; then \
      rm -f /etc/ld.so.cache; \
    fi && \
    ln -s /usr/glibc-compat/etc/ld.so.cache /etc/ld.so.cache && \
    /usr/glibc-compat/sbin/ldconfig && \
    /usr/glibc-compat/bin/localedef --force --inputfile POSIX --charmap UTF-8 "${LANG}" || true && \
    echo "export LANG=${LANG}" > /etc/profile.d/locale.sh && \
    rm -rf /usr/glibc-compat/share && \
    rm -rf /usr/glibc-compat/bin && \
    rm -rf /usr/glibc-compat/sbin && \
    mkdir /tmp/install-tl-unx && \
    curl -L ftp://tug.org/historic/systems/texlive/${TEXLIVE_VER}/install-tl-unx.tar.gz | \
      tar zx -C /tmp/install-tl-unx --strip-components=1 && \
    { \
      echo "selected_scheme scheme-basic"; \
      echo "tlpdbopt_install_docfiles 0"; \
      echo "tlpdbopt_install_srcfiles 0"; \
      if [ ${ARCH} = "arm64" ]; then \
        echo "binary_aarch64-linux 1"; \
      else \
        echo "binary_x86_64-linuxmusl 0"; \
        echo "binary_x86_64-linux 1"; \
      fi \
    } | tee -a /tmp/install-tl-unx/texlive.profile && \
    i=10; \
    while [ $i -gt 0 ]; do \
      /tmp/install-tl-unx/install-tl \
        --profile=/tmp/install-tl-unx/texlive.profile && break; \
      sleep 30; \
      i=$(expr $i - 1); \
    done && \
    i=10; \
    while [ $i -gt 0 ]; do \
      tlmgr install \
        collection-latexextra \
        collection-fontsrecommended \
        collection-langjapanese \
        epstopdf \
        latexmk && break; \
      sleep 30; \
      i=$(expr $i - 1); \
    done && \
    apk del --purge .fetch-deps && \
    apk del --purge .glibc-bin-deps && \
    rm -rf /tmp/files && \
    rm -rf /tmp/install-tl-unx && \
    rm -rf /var/cache/apk && \
    mkdir /var/cache/apk

WORKDIR /app
CMD ["sh"]
