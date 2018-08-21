#!/bin/bash

set -o nounset
set -o errexit

echo "PROVISIONING"

export DEBIAN_FRONTEND=noninteractive

# Update apt cache
apt-get update
apt-get autoclean
apt-get autoremove -y

# Install some base software
apt-get install -y curl vim unzip

# Create bin dir for user vagrant
mkdir -p /home/vagrant/bin
chown vagrant:vagrant /home/vagrant/bin

echo "Installing clojure"

apt-get install -y default-jre
wget -q -O /home/vagrant/bin/lein https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein
chmod a+x /home/vagrant/bin/lein
chown vagrant:vagrant /home/vagrant/bin/lein
