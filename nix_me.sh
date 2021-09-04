#!/bin/bash

curl -L https://nixos.org/nix/install | sh
. /home/delaney/.nix-profile/etc/profile.d/nix.sh
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --add https://nixos.org/channels/nixpkgs-unstable
nix-channel --update
nix-shell '<home-manager>' -A install


echo $HOME/.nix-profile/bin/zsh | sudo tee -a /etc/shells
chsh -s $HOME/.nix-profile/bin/zsh
