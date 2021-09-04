#!/bin/sh

gpg -a --export >pub.asc
gpg -a --export-secret-keys >priv.asc
gpg --export-ownertrust >otrust.txt

