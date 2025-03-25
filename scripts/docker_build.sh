#!/usr/bin/env bash

read -p "Confirm? (y/n) " -n 1 -r && [[ $REPLY =~ ^[Yy]$ ]] && docker buildx bake package