#!/usr/bin/env bash
# build and install pango
set -e

PANGO_VERSION=1.48.0
GLIB_VERSION=2.67.1
FRIBIDI_VERSION=1.0.10
CAIRO_VERSION=1.17.4
PIXMAN_VERSION=0.40.0
FREETYPE_VERSION=2.9.1
FONTCONFIG_VERSION=2.13.93
EXPANT_VERSION=2.2.10 # TODO: change url to use this version

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
python $FILE_PATH/packing/download_and_extract.py "https://cairographics.org/releases/pixman-${PIXMAN_VERSION}.tar.gz" pixman
python $FILE_PATH/packing/download_and_extract.py "https://www.freedesktop.org/software/fontconfig/release/fontconfig-${FONTCONFIG_VERSION}.tar.xz" fontconfig
python $FILE_PATH/packing/download_and_extract.py "https://download.savannah.gnu.org/releases/freetype/freetype-${FREETYPE_VERSION}.tar.gz" freetype
python $FILE_PATH/packing/download_and_extract.py "https://github.com/libexpat/libexpat/releases/download/R_2_2_10/expat-2.2.10.tar.xz" expat
python -m pip uninstall -y requests

echo "Installing Meson and Ninja"
pip3 install -U meson ninja

echo "Building and Install Glib"
meson setup --prefix=/usr --buildtype=release glib_builddir glib
meson compile -C glib_builddir > /dev/null 2>&1
meson install -C glib_builddir > /dev/null 2>&1

echo "Building and Install Fribidi"
meson setup --prefix=/usr --buildtype=release fribidi_builddir fribidi
meson compile -C fribidi_builddir > /dev/null 2>&1
meson install -C fribidi_builddir > /dev/null 2>&1

echo "Building and Installing Expat"
cd expat
./configure
make
make install
cd ..

echo "Building and Installing Freetype"
cd freetype
./configure --without-harfbuzz
make
make install
cd ..

echo "Building and Install Fontconfig"
cd fontconfig
./configure --sysconfdir=/etc --prefix=/usr --mandir=/usr/share/man
make
make install
cd ..

echo "Building and Installing Pixman"
cd pixman
./configure
make
make install
cd ..

echo "Building and Installing Cairo"
cd cairo
./configure --enable-fontconfig=yes --enable-freetype=yes
make
make install
cd ..

echo "Buildling and Installing Pango"
meson setup --prefix=/usr --buildtype=release -Dintrospection=disabled pango_builddir pango
meson compile -C pango_builddir
meson install -C pango_builddir
