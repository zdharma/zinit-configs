FROM ubuntu:18.04

# Update && install common dependencies
RUN apt update && \
    apt install --yes ncurses-dev unzip zsh git subversion curl make python \
                        vim htop sudo golang-go

# Add user
RUN adduser --disabled-password --gecos '' user
RUN adduser user sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER user

RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zplugin/master/doc/install.sh)"

# Copy configs into home directory
ARG FOLDER
COPY --chown=user "${FOLDER}" /home/user
# Copy of a possible .zshrc named according to a non-leading-dot scheme
RUN cp -vf /home/user/zshrc.zsh /home/user/.zshrc 2>/dev/null || true

# Run user's bootstrap script
RUN if [ -f /home/user/bootstrap.sh ]; then \
        chmod u+x /home/user/bootstrap.sh; \
        /home/user/bootstrap.sh; \
    fi

# Install all plugins
ARG TERM
RUN SHELL=/bin/zsh TERM="${TERM}" zsh -i -c -- '-zplg-scheduler burst || true'

CMD TERM="${TERM}" zsh
