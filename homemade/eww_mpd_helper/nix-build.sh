#!/bin/sh

nix-build -E 'with import <nixpkgs> { }; callPackage ./ewwmpdhelper.nix {}'
