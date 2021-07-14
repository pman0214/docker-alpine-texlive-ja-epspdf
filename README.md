# pman0214/alpine-texlive-ja-epspdf

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

> Minimal Japanese TeX Live image based on alpine with epstopdf support for pdflatex

Inspired by [paperist/alpine-texlive-ja] \(under the MIT License\).

[paperist/alpine-texlive-ja]: https://github.com/Paperist/docker-alpine-texlive-ja

Note that this repository is UNDER DEVELOPMENT!

## Table of Contents

- [Install](#install)
- [Usage](#usage)
- [Building](#building)
- [Contribute](#contribute)
- [License](#license)

## Install

```bash
docker pull pman0214/alpine-texlive-ja-epspdf
```

## Usage

Default ``WORKDIR`` is ``/app``.

```bash
docker run --rm -v $PWD:/app pman0214/alpine-texlive-ja-epspdf latexmk -C main.tex
docker run --rm -v $PWD:/app pman0214/alpine-texlive-ja-epspdf latexmk main.tex
```

## Building

If you want to build this image by yourself, please prepare for a multi-architecture builder referring to the [official documents](https://docs.docker.com/desktop/multi-arch/).
```bash
docker run --privileged --rm tonistiigi/binfmt --uninstall "qemu-*"
docker run --privileged --rm tonistiigi/binfmt --install all
docker buildx create --name multiarch --driver docker-container
docker buildx use multiarch
docker buildx inspect --bootstrap
```
In this example, `multiarch` is the name of the multi-architecture builder.

You can build this image with your own multi-architecture builder.
```bash
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  -t "pman0214/alpine-texlive-ja-epspdf" \
  . --load
```
``--push`` instead of `--load` with appropriate tag name pushes built images to GitHub.

## Contribute

* Bugfix pull requests are welcome.

## License

All the source files are released under the MIT license. See ``LICENSE.txt``.

* Copyright (c) 2021 Shigemi ISHIDA
