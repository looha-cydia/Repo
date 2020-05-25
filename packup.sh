#!/bin/sh
rm -rf Packages
rm -rf Packages.bz2

sudo dpkg-scanpackages -m debs / > Packages

bzip2 -fks Packages

rm -rf Packages




