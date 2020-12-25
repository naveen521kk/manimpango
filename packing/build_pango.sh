#!/usr/bin/env bash
# build and install pango
set -e

PANGO_VERSION=1.42.4
GLIB_VERSION=2.26.1
HARFBUZZ_VERSION=2.7.3

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
# python $FILE_PATH/packing/download_and_extract.py "https://gitlab.freedesktop.org/cairo/cairo/-/archive/${CAIRO_VERSION}/cairo-${CAIRO_VERSION}.tar.gz" cairo
python $FILE_PATH/packing/download_and_extract.py "https://github.com/harfbuzz/harfbuzz/releases/download/${HARFBUZZ_VERSION}/harfbuzz-${HARFBUZZ_VERSION}.tar.xz" harfbuzz
python -m pip uninstall -y requests

echo "Installing Meson and Ninja"
pip3 install -U meson ninja

echo "Building and Install Glib"
meson setup --prefix=/usr --buildtype=release glib_builddir glib
meson compile -C glib_builddir
meson install -C glib_builddir

# echo "Building and Install Cairo"
# meson setup --prefix=/usr --buildtype=release -Dfontconfig=enabled -Dfreetype=enabled -Dglib=enabled -Dzlib=enabled -Dtee=enabled cairo_builddir cairo
# meson compile -C cairo_builddir
# meson install -C cairo_builddir

echo "Building and Install Harfbuzz"
meson setup --prefix=/usr --buildtype=release -Dfontconfig=enabled -Dfreetype=enabled harfbuzz_builddir harfbuzz
meson compile -C harfbuzz_builddir
meson install -C harfbuzz_builddir


echo "Buildling and Installing Pango"
meson setup --prefix=/usr --buildtype=release -Dintrospection=disabled pango_builddir pango
meson compile -C pango_builddir
meson install -C pango_builddir
