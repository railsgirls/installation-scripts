set -e

echo "Updates packages. Give your password when/if asked."
sudo pacman -Sy

# Afaik, binutils-multilib and binutils are both useable.
# So, if binutils-multilib is already installed, use that,
# otherwise, install binutils.
if pacman -Qq binutils-multilib 2> /dev/null
then
binutils=binutils-multilib
else
binutils=binutils
fi

echo "Installs packages. Give your password when asked."
sudo pacman -S --needed autoconf automake $binutils bison curl fakeroot flex \
   gcc git glibc imagemagick libtool libxml2 libxslt libyaml m4 make nodejs \
   openssl patch pkg-config readline sqlite zlib

echo "Installs ImageMagick for image processing"
sudo pacman -S --needed imagemagick

echo "Installs RVM (Ruby Version Manager) for handling Ruby installation"
curl -L get.rvm.io | bash -s stable
source ~/.rvm/scripts/rvm

echo "Installs Ruby"
rvm install 1.9.3-p194
rvm use 1.9.3-p194 --default

gem install bundler --no-rdoc --no-ri
gem install rails --no-rdoc --no-ri

echo "Installs text editor"
sudo pacman -S --needed gedit

echo -e "\n- - - - - -\n"
echo -e "Now we are going to print some information to check that everything is done:\n"
echo -n "Should be sqlite 3.7.3 or higher: sqlite "
sqlite3 --version
echo -n "Should be rvm 1.6.32 or higher:          "
rvm --version | sed '/^.*$/N;s/\n//g' | cut -c 1-10
echo -n "Should be ruby 1.9.3-p194:                "
ruby -v 
echo -n "Should be Rails 3.2.2 or higher:         "
rails -v
echo -e "\n- - - - - -\n"

echo "If the versions match, everything is installed correctly. If the versions 
don't match or errors are shown, something went wrong with the automated process 
and we will help you do the installation the manual way at the event.

Congrats!"

