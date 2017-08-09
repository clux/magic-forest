FROM base/archlinux:latest

RUN pacman -Syu --noconfirm && pacman --noconfirm -S \
  clang \
  elixir \
  gcc \
  gcc-fortran \
  ghc-static \
  go \
  nodejs \
  pypy3 \
  python \
  ruby \
  rust
