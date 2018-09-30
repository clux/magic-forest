FROM base/archlinux:latest

RUN pacman -Syu --noconfirm && pacman --noconfirm -S \
  clang \
  crystal \
  elixir \
  gcc \
  gcc-fortran \
  ghc-static \
  go \
  jdk9-openjdk \
  julia \
  kotlin \
  nodejs \
  patch \
  pypy3 \
  python \
  scala jre9-openjdk \
  ruby \
  rust

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && locale-gen

ENV LANG=en_US.UTF_8 \
    PATH=$PATH:/pypy2-v5.10.0-src/rpython/bin/

RUN pacman -S --noconfirm pypy make && \
    curl -sSL https://bitbucket.org/pypy/pypy/downloads/pypy2-v5.10.0-src.tar.bz2 | tar xj
