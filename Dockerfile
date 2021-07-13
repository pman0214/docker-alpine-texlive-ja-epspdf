# Copyright (c) 2021 Shigemi ISHIDA
# Released under the MIT license
# https://opensource.org/licenses/MIT

FROM --platform=$BUILDPLATFORM alpine:3.13

ARG BUILDPLATFORM
ARG TARGETPLATFORM
ARG GLIBC_VER=2.33
ARG TEXLIVE_VER=2021

ENV LANG=C.UTF-8

COPY files /tmp/files

RUN set -x && \
    cd / && \
    apk update && \
    apk add --no-cache --virtual .fetch-deps curl xz && \
    apk add --no-cache perl fontconfig-dev freetype-dev ghostscript && \
    curl -L https://github.com/pman0214/docker-glibc-builder/releases/download/${GLIBC_VER}/glibc-bin-${GLIBC_VER}-$(arch).tar.gz | \
    tar zx && \
    mkdir -p /lib /lib64 /usr/glibc-compat/lib/locale  /usr/glibc-compat/lib64 /etc && \
    cp /tmp/files/ld.so.conf /usr/glibc-compat/etc/ && \
    cp /tmp/files/nsswitch.conf /etc/ && \
    /usr/glibc-compat/sbin/ldconfig && \
    /usr/glibc-compat/bin/localedef --force --inputfile POSIX --charmap UTF-8 "${LANG}" || true && \
    echo "export LANG=${LANG}" > /etc/profile.d/locale.sh && \
    mkdir /tmp/install-tl-unx && \
    curl -L ftp://tug.org/historic/systems/texlive/${TEXLIVE_VER}/install-tl-unx.tar.gz | \
    tar zx -C /tmp/install-tl-unx --strip-components=1 && \
    export PATH=/usr/local/texlive/${TEXLIVE_VER}/bin/$(arch)-linux:$PATH && \
    printf "%s\n" \
      "selected_scheme scheme-basic" \
      "tlpdbopt_install_docfiles 0" \
      "tlpdbopt_install_srcfiles 0" \
      "binary_$(arch)-linuxmusl 0" \
      "binary_$(arch)-linux 1" \
    > /tmp/install-tl-unx/texlive.profile && \
    /tmp/install-tl-unx/install-tl \
      --profile=/tmp/install-tl-unx/texlive.profile && \
    tlmgr install \
      collection-latexextra \
      collection-fontsrecommended \
      collection-langjapanese \
      epstopdf \
      latexmk && \
    echo "export PATH=/usr/local/texlive/${TEXLIVE_VER}/bin/$(arch)-linux:$PATH" >> \
      /etc/profile.d/texlive_path.sh && \
    rm -rf /tmp/files && \
    apk del --purge .fetch-deps && \
    rm -rf /tmp/install-tl-unx && \
    rm -rf /var/cache/apk && \
    mkdir /var/cache/apk

WORKDIR /app
CMD ["sh"]