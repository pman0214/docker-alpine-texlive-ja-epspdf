# pman0214/alpine-texlive-ja-epspdf

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

> Minimal Japanese TeX Live image based on alpine with epstopdf support for pdflatex

Inspired by [paperist/alpine-texlive-ja] \(under the MIT License\).

[paperist/alpine-texlive-ja]: https://github.com/Paperist/docker-alpine-texlive-ja

Note that this repository is UNDER DEVELOPMENT!

## Table of Contents

- [Install](#install)
- [Usage](#usage)
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

## Contribute

* Bugfix pull requests are welcome.

## License

All the source files are released under the MIT license. See ``LICENSE.txt``.

* Copyright (c) 2021 Shigemi ISHIDA
