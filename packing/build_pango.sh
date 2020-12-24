#!/usr/bin/env bash
# build and install pango

PANGO_VERSION=1.48.0

cd $TMP
mkdir pango
cd pango
echo "Downloading Pango"

yum install -y wget
wget -O "pango-${PANGO_VERSION}.tar.xz" "https://download.gnome.org/sources/pango/${PANGO_VERSION%.*}/pango-${PANGO_VERSION}.tar.xz"
tar -xf pango-${PANGO_VERSION}.tar.xz

mv pango-${PANGO_VERSION} pango

echo "Installing Meson and Ninja"
pip3 install -U meson==0.55.3 ninja

echo "Buildling and Installing Pango"
yum-builddep -y pango-devel

meson setup --prefix=/usr --buildtype=release -Dintrospection=disabled pango_builddir pango
meson compile -C pango_builddir
meson install -C pango_builddir
