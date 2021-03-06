#!/bin/bash

# DESCRIPTION
# Sets up and launches (if necessary) installed software.

# Bash
sudo bash -c "printf '/usr/local/bin/bash\n' >> /etc/shells"

# Bash Completion
chsh -s /usr/local/bin/bash

# Dnsmasq
mkdir -p $(brew --prefix)/etc
sudo cp $(brew --prefix dnsmasq)/homebrew.mxcl.dnsmasq.plist /Library/LaunchDaemons
sudo launchctl load -w /Library/LaunchDaemons/homebrew.mxcl.dnsmasq.plist
sudo mkdir -p /etc/resolver
printf "address=/.$SYSTEM_DOMAIN/127.0.0.1\n" | sudo tee -a $(brew --prefix)/etc/dnsmasq.conf
printf "# Generated by OSX setup\nnameserver 127.0.0.1\n" | sudo tee /etc/resolver/$SYSTEM_DOMAIN

# rbenv
export PATH="/usr/local/bin:$PATH"
eval "$(rbenv init -)"
for ruby in $MRI $JRUBY $RUBINIUS; do
  rbenv install $ruby
done
rbenv global $MRI

# Ruby
git clone git://github.com/bkuhlmann/ruby_setup.git
(
  cd ruby_setup
  for ruby in $MRI $JRUBY $RUBINIUS; do
    rbenv shell $ruby
    ./run.sh i
  done
)
rm -rf ruby_setup

# Go
install_git_project "git://github.com/bkuhlmann/go_setup.git" "v0.1.1" "go_setup" "./run.sh i"

# NPM
install_git_project "git://github.com/bkuhlmann/npm_setup.git" "v0.4.0" "npm_setup" "./run.sh i"

# PostgreSQL
initdb /usr/local/var/postgres -E utf8
launch_process "/usr/local/opt/postgresql/homebrew.mxcl.postgresql.plist"

# Nginx
launch_process "/usr/local/opt/nginx/homebrew.mxcl.nginx.plist"

# Memcached
launch_process "/usr/local/opt/memcached/homebrew.mxcl.memcached.plist"

# Redis
launch_process "/usr/local/opt/redis/homebrew.mxcl.redis.plist"

# Pow
curl get.pow.cx | sh

# Google Chrome Ember Inspector
(
  cd "$EMBER_INSPECTOR_EXTENSION_PATH"
  grunt
)

# Sublime Text Setup
if [ ! -e "/usr/bin/sublime" ]; then
  sudo ln -sv "/Applications/Sublime Text 2.app/Contents/SharedSupport/bin/subl" /usr/local/bin/sublime
fi
install_git_project "git://github.com/bkuhlmann/sublime_text_setup.git" "v1.0.0" "sublime_text_setup" "./run.sh i"

# Dotfiles
rm -f $HOME/.bash_profile
install_git_project "git://github.com/bkuhlmann/dotfiles.git" "v14.1.0" "dotfiles" "./run.sh i"
source $HOME/.bashrc
