#!/bin/bash
set -e

cd "$(dirname "$(readlink -f "$BASH_SOURCE")")"

current="$(git ls-remote --tags https://github.com/syncthing/syncthing.git | grep -v '\^{}$' | grep -vE 'beta|rc' | cut -d/ -f3 | sort -V | tail -1)"
current="${current#v}"

set -x
sed -ri 's/^(ENV SYNCTHING_VERSION) .*/\1 '"$current"'/' Dockerfile
docker build -t meonkeys/syncthing .
docker tag meonkeys/syncthing:latest "meonkeys/syncthing:v$current"
docker push meonkeys/syncthing:latest
docker push "meonkeys/syncthing:v$current"
./inotify/update.sh
