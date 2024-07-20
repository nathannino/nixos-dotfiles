#!/bin/sh

# Dumb script to get around eww timeouts, because of course eww timeouts are broken : https://github.com/elkowar/eww/issues/715

sh -c "$1" &
