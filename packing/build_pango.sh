#!/usr/bin/env bash
# build and install pango
set -e

PANGO_VERSION=1.42.4
GLIB_VERSION=2.67.1
FRIBIDI_VERSION=1.0.10
CAIRO_VERSION=1.17.4
PIXMAN_VERSION=0.40.0

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
python $FILE_PATH/packing/download_and_extract.py "https://github.com/fribidi/fribidi/releases/download/v${FRIBIDI_VERSION}/fribidi-${FRIBIDI_VERSION}.tar.xz" fribidi
python $FILE_PATH/packing/download_and_extract.py "https://cairographics.org/snapshots/cairo-${CAIRO_VERSION}.tar.xz" cairo
python $FILE_PATH/packing/download_and_extract.py "https://cairographics.org/releases/pixman-${PIXMAN_VERSION}.tar.xz" pixman
python -m pip uninstall -y requests

echo "Installing Meson and Ninja"
pip3 install -U meson ninja

echo "Building and Install Glib"
meson setup --prefix=/usr --buildtype=release glib_builddir glib
meson compile -C glib_builddir
meson install -C glib_builddir

echo "Building and Install Fribidi"
meson setup --prefix=/usr --buildtype=release fribidi_builddir fribidi
meson compile -C fribidi_builddir
meson install -C fribidi_builddir

echo "Building and Installing Pixman"
cd pixman
./configure
make
make install
cd ..

echo "Building and Installing Cairo"
cd cairo
./configure
make
make install
cd ..

echo "Buildling and Installing Pango"
meson setup --prefix=/usr --buildtype=release -Dintrospection=disabled pango_builddir pango
meson compile -C pango_builddir
meson install -C pango_builddir
