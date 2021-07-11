#!/usr/bin/env sh
# Wrapper around jekyll by bundle e.g.
# $ jekyll.sh build

set -eux

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
root=$(dirname ${script_dir})
cd $root

bundle exec jekyll $*
