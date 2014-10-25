#!/bin/bash

# DESCRIPTION
# Applies software preferences.

# EXECUTION
# Dotfiles
git clone git://github.com/bkuhlmann/dotfiles.git
(
  cd dotfiles
  ./run.sh i
)
rm -rf dotfiles
source $HOME/.bashrc

# Ruby
git clone git://github.com/bkuhlmann/ruby_setup.git
(
  cd ruby_setup

  for ruby in $MRI $RUBINIUS $JRUBY; do
    rbenv shell $ruby
    ./run.sh i
  done
)
rm -rf ruby_setup

# Go
git clone git://github.com/bkuhlmann/go_setup.git
(
  cd go_setup
  ./run.sh i
)
rm -rf go_setup

# NPM
git clone git://github.com/bkuhlmann/npm_setup.git
(
  cd npm_setup
  ./run.sh i
)
rm -rf npm_setup

# Sublime Text
git clone git://github.com/bkuhlmann/sublime_text.git
(
  cd sublime_text
  ./run.sh l
)
rm -rf sublime_text
