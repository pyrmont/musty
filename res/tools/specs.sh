#!/bin/sh

OWNER="mustache"
REPO="spec"

# Ensure target directory exists
mkdir -p tmp

# Discover the latest tag by following GitHub’s redirect
tag=$(
  curl -sIL -o /dev/null -w '%{url_effective}' \
    "https://github.com/$OWNER/$REPO/releases/latest" |
  sed 's#.*/tag/##'
)

# Download and extract the corresponding source tarball
curl -sL "https://github.com/$OWNER/$REPO/archive/refs/tags/$tag.tar.gz" \
  | tar -xz -C tmp --strip-components=1

mkdir -p res/specs

cp tmp/specs/*.json res/specs
cp tmp/LICENSE res/specs

rm tmp/specs/*
rmdir tmp/specs
rm tmp/*
rm tmp/.[A-Za-z0-9]*
rmdir tmp

echo "Downloaded JSON specs for $OWNER/$REPO@$tag into ./res/specs"
