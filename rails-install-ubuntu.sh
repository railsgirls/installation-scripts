#!/bin/bash

set -eu

if
  [[ "${USER:-}" == "root" ]]
then
  echo "This script works only with normal user, it wont work with root, please log in as normal user and try again." >&2
  exit 1
fi

echo "Update packages. Asks for your password. Please enter your password."
sudo apt-get update -y

echo "Install packages. Enter your password when asked."
sudo apt-get --ignore-missing install build-essential git-core curl openssl libssl-dev libcurl4-openssl-dev zlib1g zlib1g-dev libreadline6-dev libyaml-dev libsqlite3-dev libsqlite3-0 sqlite3 libxml2-dev libxslt1-dev libffi-dev software-properties-common libgdm-dev libncurses5-dev automake autoconf libtool bison postgresql postgresql-contrib libpq-dev libc6-dev -y

echo "Install Node.js"
sudo apt-get install -y snapd
sudo snap install node --classic --channel=18

echo "Install ImageMagick for image processing"
sudo apt-get install imagemagick --fix-missing -y

echo "Install rbenv (Ruby version manager) for handling the Ruby installation"
echo "gem: --no-ri --no-rdoc" > ~/.gemrc

RBENV_INSTALL_PATH="$HOME/.rbenv"
if [ -d "$RBENV_INSTALL_PATH" ]; then
  echo "rbenv already installed"
else
  curl -fsSL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-installer | bash

  echo "Configuring rbenv for your Shell"
  if [[ "$SHELL" == *"bash" ]]; then
    echo 'eval "$($HOME/.rbenv/bin/rbenv init - bash)"' >> ~/.bashrc
  elif [[ "$SHELL" == *"zsh" ]]; then
    echo 'eval "$($HOME/.rbenv/bin/rbenv init - zsh)"' >> ~/.zshrc
  else
    echo "Unknown Shell. Please configure rbenv manually."
    echo "Please visit: https://github.com/rbenv/rbenv"
  fi
fi

echo "Load rbenv config in install script"
eval "$($HOME/.rbenv/bin/rbenv init - bash)"

echo "Install Ruby"
RUBY_VERSION=3.1.3
rbenv install "$RUBY_VERSION"
rbenv global "$RUBY_VERSION"

echo "Install Rails"
echo "gem: --no-ri --no-rdoc" > ~/.gemrc
gem install bundler rails

echo -e "\n- - - - - -\n"
echo -e "Now we are going to print some information to check that everything is done:\n"

echo -n "Should be SQLite 3.22.0 or higher: sqlite "
sqlite3 --version
echo -n "Should be Ruby 3.1.3 or higher:                "
ruby -v | cut -d " " -f 2
echo -n "Should be Rails 7.0 or higher:         "
rails -v
echo -e "\n- - - - - -\n"

echo "If the versions match, everything is installed correctly. If the versions
don't match or errors are shown, something went wrong with the automated process
and we will help you do the installation the manual way at the event.

Congrats!

Open a new Terminal tab/window and make sure that all works well
by running the application generator command:
    $ rails new railsgirls"
