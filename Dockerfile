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

RUN pacman -S --noconfirm sudo git fakeroot make && \
    useradd -ms /bin/bash ci -G wheel && \
    echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
USER ci
RUN cd && git clone https://aur.archlinux.org/rpython.git && \
    cd rpython && makepkg -si --noconfirm
