#!/bin/sh

PUPPET_DIR='/vagrant/puppet'

GIT=/usr/bin/git
APT_GET=/usr/bin/apt-get
$APT_GET update --fix-missing
$APT_GET upgrade -y --fix-missing
$APT_GET -q -y install git puppet ruby-dev

if [ `gem query --local | grep librarian-puppet | wc -l` -eq 0 ]; then
  gem install librarian-puppet
  cd $PUPPET_DIR && librarian-puppet install --clean
else
  gem update
  cd $PUPPET_DIR && librarian-puppet update
fi

sudo -E puppet apply -vv --modulepath=$PUPPET_DIR/modules/ $PUPPET_DIR/manifests/main.pp

