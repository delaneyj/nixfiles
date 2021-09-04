#!/bin/sh

gpg --import priv.asc
gpg --import pub.asc
gpg -K
gpg -k

gpg --import-ownertrust otrust.txt
