#!/bin/bash

apt-get install wget
wget https://github.com/oxyc/composer/raw/master/composer.phar -O /usr/bin/composer
chmod +x /usr/bin/composer
