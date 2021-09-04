#!/bin/bash
nix-env -f '<nixpkgs>' -iA nixUnstable

curl -L https://nixos.org/nix/install | sh
. /home/delaney/.nix-profile/etc/profile.d/nix.sh
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --add https://nixos.org/channels/nixpkgs-unstable
nix-channel --update
nix-shell '<home-manager>' -A install

echo "keep-derivations = true\nkeep-outputs = true" | sudo tee -a /etc/nix/nix.conf 

sudo reboot