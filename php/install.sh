#!/bin/sh

echo "Setting up PHP..."

# Install Composer
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer

# Install global packages
/usr/local/bin/composer global require laravel/installer laravel/lumen-installer
