#!/bin/sh

echo "Cloning repositories..."

CODE=$HOME/Code
SITES=$HOME/Herd

# Sites
git clone git@github.com:laravel/cloud.git $SITES/cloud
git clone git@github.com:driesvints/driesvints.com.git $SITES/driesvints
git clone git@github.com:eventyio/eventy.io.git $SITES/eventy
git clone git@github.com:laravelio/laravel.io.git $SITES/lio
git clone git@github.com:driesvints/moneytrees.app.git $SITES/moneytrees
git clone git@github.com:laravelio/paste.laravel.io.git $SITES/pastebin

# Code
git clone git@github.com:blade-ui-kit/blade-heroicons.git $CODE/blade-heroicons
git clone git@github.com:blade-ui-kit/blade-icons.git $CODE/blade-icons
