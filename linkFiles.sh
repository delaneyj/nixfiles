#!/bin/bash

scriptDir=$(dirname -- "$(readlink -f -- "$BASH_SOURCE")")

ln -s "$scriptDir/nixpkgs" "$HOME/.config/nixpkgs"