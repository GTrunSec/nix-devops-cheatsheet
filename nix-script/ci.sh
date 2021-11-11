#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq
#version="$(curl -sL "https://api.github.com/repos/numtide/nix-unstable-installer?per_page=1" | jq -r ".[0].tag_name")"
echo "$version"
