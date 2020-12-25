# build pango using jhbuild

cd $TEMP
mkdir jhbuild
cd jhbuild

mkdir checkout
cd checkout
git clone https://gitlab.gnome.org/GNOME/jhbuild.git
cd jhbuild
./autogen.sh
make
make install
cd ../..

PATH=$PATH:~/.local/bin

chmod 777 /root/.local/bin -R
sudo -u username ~/.local/bin/jhbuild sanitycheck
sudo -u username ~/.local/bin/jhbuild build pango

cd /project
