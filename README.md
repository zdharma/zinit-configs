<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [zplugin-configs](#zplugin-configs)
  - [Pull-requests welcomed!](#pull-requests-welcomed)
- [Searching the repository](#searching-the-repository)
  - [OR ...](#or-)
- [Submitting zshrc](#submitting-zshrc)
- [The repository structure](#the-repository-structure)
- [Try configurations with docker](#try-configurations-with-docker)
  - [Requirements](#requirements)
  - [Running a configuration](#running-a-configuration)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# zplugin-configs
<h2>Pull-requests welcomed!</h2>

Feel free to submit your zshrc if it contains `zplugin` commands (or just the section with the commands extracted).

# Searching the repository

Use the Github search interface – just enter a query e.g. "trapd00r/LS_COLORS" like in the picture below, to find zshrc with references to this plugin, and ensure that you activate the "*in this repository*" variant of the search:

![Starting search](https://raw.githubusercontent.com/zdharma/zplugin-configs/img/srch.png)

Then, results should appear like below:

![Search results](https://raw.githubusercontent.com/zdharma/zplugin-configs/img/srch-rslt.png)

## OR ...

just clone the repository and issue `ack`, `ag` or `grep` command :)

# Submitting zshrc

You can either:

 - open a PR – fastest method
 - submit an issue with URL to the zshrc (or with the zshrc pasted) – [a quick link](https://github.com/zdharma/zplugin-configs/issues/new?assignees=&labels=&template=request-to-add-zshrc-to-the-zplugin-configs-repo.md)

# The repository structure

The structure of the repository is very simple: in its main directory there are directories located, named after the user-names of the submitting users. In those directories there are the zshrc files that the user decided to share.

# Try configurations with docker

## Requirements

You should have [docker](https://docs.docker.com/install/) and `zsh` installed to use this functionality.
Check you have them present on your system:
```sh
docker version
zsh --version
```

The other dependency is interactive filter. You should have either [fzf](https://github.com/junegunn/fzf) or [fzy](https://github.com/jhawthorn/fzy) in your `$PATH`.
You might choose to install any of them via zplugin:
```sh
# Install fzf
zplugin ice from"gh-r" as"command"
zplugin load junegunn/fzf-bin
# or fzy
zplugin ice as"command" make"\!PREFIX=$ZPFX install" \
    atclone"cp contrib/fzy-* $ZPFX/bin/" \
    pick"$ZPFX/bin/fzy*"
zplugin load jhawthorn/fzy
```

Keep in mind you will need a few Gb of free space to store docker images.

## Running a configuration

To try a configuration, you have to clone this repository and execute a `run.sh` script:
```sh
# Clone repository with configurations
git clone 'https://github.com/zdharma/zplugin-configs'
# Run the configuration picker
./zplugin-configs/run.sh
```

... or you can install this repository as a `zsh` plugin!
```sh
# Then, install this repo
zplugin load zdharma/zplugin-configs
# Run the command
zplugin-configs
```

Now you will have to wait for a few minutes, while the required environment is being installed into the docker image. The next time you will want to try a configuration, loading it will take less time.
