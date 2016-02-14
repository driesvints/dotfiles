#!/usr/bin/env bash

echo "Setting up PHP..."

# Install PHP 7 (Will be activated through .path)
brew install homebrew/php/php70

# Install Composer
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer

# Install global packages
/usr/local/bin/composer require laravel/installer laravel/lumen-installer etsy/phan
