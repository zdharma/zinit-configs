<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [zplugin-configs](#zplugin-configs)
  - [Pull-requests welcomed!](#pull-requests-welcomed)
- [Searching the repository](#searching-the-repository)
  - [OR ...](#or-)
- [Submitting zshrc](#submitting-zshrc)
- [The repository structure](#the-repository-structure)
- [Executing config inside a docker container via zplugin](#executing-config-inside-a-docker-container-via-zplugin)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# zplugin-configs
<h2>Pull-requests welcomed!</h2>

Feel free to submit your zshrc if it contains `zplugin` commands (or just the section with the commands extracted).

# Searching the repository

Use the Github search inerface – just enter a query e.g. "trapd00r/LS_COLORS" like in the picture below, to find zshrc with references to this plugin, and ensure that you activate the "*in this repository*" variant of the search:

![Starting search](https://raw.githubusercontent.com/zdharma/zplugin-configs/img/srch.png)

Then, results should appaer like below:

![Search results](https://raw.githubusercontent.com/zdharma/zplugin-configs/img/srch-rslt.png)

## OR ...

just clone the repository and issue `ack`, `ag` or `grep` command :)

# Submitting zshrc

You can either:

 - open a PR – fastest method
 - submit an issue with URL to the zshrc (or with the zshrc pasted) – [a quick link](https://github.com/zdharma/zplugin-configs/issues/new?assignees=&labels=&template=request-to-add-zshrc-to-the-zplugin-configs-repo.md)

# The repository structure

The structure of the repository is very simple: in its main directory there are directories located, named after the user-names of the submitting users. In those directories there are the zshrc files that the user decided to share.

# Executing config inside a docker container via zplugin

```sh
# Install fzf
zplugin load junegunn/fzf-bin
# or fzy
# zplugin ice make"!PREFIX=$ZPFX install" atclone"cp contrib/fzy-* $ZPFX/bin/" pick"$ZPFX/bin/fzy*"
# zplugin load jhawthorn/fzy

# Then, install this repo
zplugin ice cloneopts'--branch feature-run --single-branch'
zplugin load zdharma/zplugin-configs

# Run the command
zplugin-configs
```
