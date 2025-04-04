# onbaordme Debian Bookworm image - for arm64
FROM debian:bookworm-slim

# this makes debian not prompt for stuff
ENV DEBIAN_FRONTEND=NONINTERACTIVE
RUN apt -o "Acquire::https::Verify-Peer=false" update && apt-get -o "Acquire::https::Verify-Peer=false" install -y ca-certificates
RUN update-ca-certificates
# install pre-req apt packages
# python3 defaults to python 3.11 in Debian Bookworm
RUN apt-get update && \
    apt list --upgradeable | grep security | cut -f1 -d '/' | xargs apt-get install --no-install-recommends -y && \
    apt-get install -y \
        build-essential \
        curl \
        file \
        procps \
        git \
        python3-pip \
        python3-dev \
        openssh-client \
        sudo \
        autoconf \
        bison \
        patch \
        libssl-dev \
        libyaml-dev \
        libreadline-dev \
        zlib1g-dev \
        libgmp-dev \
        libncurses5-dev \
        libffi-dev \
        libgdbm6 \
        libgdbm-dev \
        libdb-dev \
        uuid-dev \
        fish \
        bash \
        gh

# create default user
RUN useradd -m expert && \
    usermod -aG sudo expert && \
    echo 'expert ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

WORKDIR /home/expert
USER expert

ENV HOME="/home/expert"

# make sure we can run locally installed executables
ENV PATH="$HOME/.rbenv/bin:/home/linuxbrew/.linuxbrew/bin:$PATH:"

# ref: https://github.com/rbenv/rbenv-installer
# installs rbenv, ruby-build, followed by openssl 1.1 and finally ruby 2.6.10
# takes 25-45 min to compile stuff unless docker has like 8 CPU/16G mem in resources
RUN curl -fsSL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-installer | bash && \
    eval "$(rbenv init -)" && \
    . $HOME/.bashrc && \
    rbenv install 2.6.10 && \
    rbenv global 2.6.10 && \
    sudo ln -s $HOME/.rbenv/versions/2.6.10/bin/ruby /usr/bin/ruby

# this is so that brew doesn't prompt for sudo access
ENV NONINTERACTIVE=1

# suggestion by homebrew member:
# https://github.com/orgs/Homebrew/discussions/3612#discussioncomment-3572967
ENV HOMEBREW_DEVELOPER=1
ENV HOMEBREW_USE_RUBY_FROM_PATH=1

# homebrew on arm is unsupported: https://docs.brew.sh/Homebrew-on-Linux#arm-unsupported
# so we have to install ruby ourselves because of:
# Error: No Homebrew ruby 2.6.10_1 available for aarch64 processors!
# Error: Failed to install Homebrew Portable Ruby and cannot find another Ruby 2.6.10!
# see: https://github.com/orgs/Homebrew/discussions/3612
RUN sudo mkdir /home/linuxbrew && sudo chmod 755 /home/linuxbrew && sudo chown expert: /home/linuxbrew && \
    git clone https://github.com/Homebrew/brew.git /home/linuxbrew/.linuxbrew && \
    eval "$(brew shellenv)" && \
    echo 'eval "$(brew shellenv)"' >> ${HOME}/.bashrc && \
    . $HOME/.bashrc

USER root
USER expert

ENTRYPOINT ["fish"]