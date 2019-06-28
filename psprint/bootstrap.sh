#!/usr/bin/env zsh

sudo apt install --yes cmake redis-server libhiredis-dev

# For zdharma/zredis
sudo mkdir -p usr/local/var/db/redis