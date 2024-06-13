#!/bin/sh

nix-build -E 'with import <nixpkgs> { }; callPackage ./customnotif.nix {}'
