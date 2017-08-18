FROM base/archlinux:latest

RUN pacman -Syu --noconfirm && pacman --noconfirm -S \
  clang \
  elixir \
  gcc \
  gcc-fortran \
  ghc-static \
  go \
  kotlin \
  nodejs \
  patch \
  pypy3 \
  python \
  scala jre8-openjdk \
  ruby \
  rust

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && locale-gen
ENV LANG=en_US.UTF_8
