#!/bin/bash

scriptDir=$(dirname -- "$(readlink -f -- "$BASH_SOURCE")")

ln -sf  "$scriptDir" "$HOME/.config/nixpkgs"