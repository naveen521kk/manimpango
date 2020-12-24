#!/usr/bin/env bash
# build and install pango

PANGO_VERSION=1.48.0

cd $TMP
mkdir pango
cd pango
echo "Downloading Pango"

python -m pip install requests
python -c "import requests;a=requests.get('http://download.gnome.org/sources/pango/${PANGO_VERSION%.*}/pango-${PANGO_VERSION}.tar.xz');b=open('pango-${PANGO_VERSION}.tar.xz','wb');b.write(a.content)"
python -m pip install -y requests
tar -xf pango-${PANGO_VERSION}.tar.xz

mv pango-${PANGO_VERSION} pango

echo "Installing Meson and Ninja"
pip3 install -U meson==0.55.3 ninja

echo "Buildling and Installing Pango"
yum-builddep -y pango-devel

meson setup --prefix=/usr --buildtype=release -Dintrospection=disabled pango_builddir pango
meson compile -C pango_builddir
meson install -C pango_builddir
