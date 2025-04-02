#!/bin/bash

if ! [ -x "$(command -v entr)" ]; then
  brew install entr
fi

find src -type f | entr -r mvn compile
