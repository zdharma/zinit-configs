FROM ubuntu:18.04

ARG FOLDER
ARG TERM

# Update && install common dependencies
RUN apt update && \
    apt install --yes ncurses-dev unzip zsh git subversion curl make python \
                        vim htop sudo

# Add user
RUN adduser --disabled-password --gecos '' user
RUN adduser user sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER user

RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zplugin/master/doc/install.sh)"

# Copy configs into home directory
COPY --chown=user "${FOLDER}" /home/user
# Copy of a possible .zshrc named according to a non-leading-dot scheme
RUN cp -vf /home/user/zshrc.zsh /home/user/.zshrc 2>/dev/null || true

# For zdharma/zredis
RUN chmod u+x /home/user/bootstrap.sh && \
    /home/user/bootstrap.sh

# Install all plugins
RUN SHELL=/bin/zsh TERM="${TERM}" zsh -i -c -- '-zplg-scheduler burst || true'

CMD TERM="${TERM}" zsh
