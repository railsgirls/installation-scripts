#!/bin/bash

set -e

# If you decide to skip the full update, be sure to at least run 'sudo yum update audit -y'
echo "Updates packages. Asks for your password."
sudo pacman -Sy

echo "Installs packages. Give your password when asked."
sudo pacman -S --noconfirm base-devel patch libffi openssl readline curl git zlib libyaml sqlite libxml2 libxslt nodejs libgdm ncurses postgresql postgresql-libs

echo "Installs ImageMagick for image processing"
sudo pacman -S --noconfirm imagemagick 

echo "Installs RVM (Ruby Version Manager) for handling Ruby installation"
# Retrieve the GPG key.
curl -sSL https://rvm.io/mpapis.asc | gpg --import -
curl -sSL https://get.rvm.io | bash -s stable
source ~/.rvm/scripts/rvm

echo "Installs Ruby"
rvm install 2.3.1
rvm use 2.3.1 --default

gem install bundler --no-rdoc --no-ri
gem install rails --no-rdoc --no-ri

# Make sure RVM, Ruby and Rails are on the user's path
echo '[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"' >> ~/.bashrc
set +e
source ~/.bashrc
set -e

echo -n "Should be sqlite 3.8.1 or higher: sqlite "
sqlite3 --version
echo -n "Should be rvm 1.27.0 or higher: "
rvm --version | sed '/^.*$/N;s/\n//g' | cut -c 1-10 | xargs echo
echo -n "Should be ruby 2.3.1: "
ruby -v | cut -d " " -f 2
echo -n "Should be Rails 5.0.0 or higher: "
rails -v
echo -e "\n- - - - - -\n"

echo "If the versions match, everything is installed correctly. If the versions 
don't match or errors are shown, something went wrong with the automated process 
and we will help you do the installation the manual way at the event.

Congrats!"

