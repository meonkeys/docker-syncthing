#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

if [ "$HOME" = '/home/user' ]; then
  echo >&2 'uh oh, HOME=/home/user'
  exit 1
fi

mkdir -p "$HOME/.config/syncthing"

SYNCTHING_VERSION=0.14.33

set -x

docker run -d \
  --name syncthing \
  --restart always \
  --env="GOMAXPROCS=2" \
  -u "$(id -u):$(id -g)" \
  -v "$HOME:$HOME" \
  -v "$HOME/.config/syncthing:/home/user/.config/syncthing" \
  -v /etc:/etc \
  -v /mnt:/mnt \
  --net host \
  "meonkeys/syncthing:$SYNCTHING_VERSION" \
  "$@"

timeout 10s docker logs -f syncthing || true
