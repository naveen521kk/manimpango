#!/usr/bin/env bash
# build and install pango
set -e

PANGO_VERSION=1.48.0
GLIB_VERSION=2.67.1

FILE_PATH="`dirname \"$0\"`"
FILE_PATH="`( cd \"$FILE_PATH\" && pwd )`"
if [ -z "$FILE_PATH" ] ; then
  exit 1
fi

cd $TMP
mkdir pango
cd pango
echo "Downloading Pango"

python -m pip install requests
python $FILE_PATH/packing/download_and_extract.py "http://download.gnome.org/sources/pango/${PANGO_VERSION%.*}/pango-${PANGO_VERSION}.tar.xz" pango
python $FILE_PATH/packing/download_and_extract.py "http://download.gnome.org/sources/glib/${GLIB_VERSION%.*}/glib-${GLIB_VERSION}.tar.xz" glib
python -m pip uninstall -y requests

echo "Installing Meson and Ninja"
pip3 install -U meson ninja

echo "Building and Install Glib"
meson setup --prefix=/usr --buildtype=release glib_builddir glib
meson compile -C glib_builddir
meson install -C glib_builddir

echo "Buildling and Installing Pango"
meson setup --prefix=/usr --buildtype=release -Dintrospection=disabled pango_builddir pango
meson compile -C pango_builddir
meson install -C pango_builddir
