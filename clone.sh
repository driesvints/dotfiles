#!/bin/sh

echo "Cloning repositories..."

SITES=$HOME/Sites
BLADE=$SITES/blade-ui-kit
LARAVEL=$SITES/laravel

# Personal
git clone git@github.com:driesvints/checklists.git $SITES/checklists
git clone git@github.com:driesvints/driesvints.com.git $SITES/driesvints.com
git clone git@github.com:driesvints/eventy.io.git $SITES/eventy.io
git clone git@github.com:driesvints/steunze.be.git $SITES/steunze.be
git clone git@github.com:EventSaucePHP/LaravelEventSauce.git $SITES/LaravelEventSauce
git clone git@github.com:fullstackbelgium/fullstackbelgium.be.git $SITES/fullstackbelgium.be
git clone git@github.com:fullstackeurope/fullstackeurope.com.git $SITES/fullstackeurope.com
git clone git@github.com:laravelio/laravel.io.git $SITES/laravel.io
git clone git@github.com:laravelio/paste.laravel.io.git $SITES/paste.laravel.io

# Blade UI Kit
git clone git@github.com:blade-ui-kit/art.git $BLADE/art
git clone git@github.com:blade-ui-kit/awesome-tall-stack.git $BLADE/awesome-tall-stack
git clone git@github.com:blade-ui-kit/blade-docs.git $BLADE/blade-docs
git clone git@github.com:blade-ui-kit/blade-heroicons.git $BLADE/blade-heroicons
git clone git@github.com:blade-ui-kit/blade-icons.git $BLADE/blade-icons
git clone git@github.com:blade-ui-kit/blade-ui-kit.git $BLADE/blade-ui-kit
git clone git@github.com:blade-ui-kit/blade-ui-kit.com.git $BLADE/blade-ui-kit.com
git clone git@github.com:blade-ui-kit/blade-zondicons.git $BLADE/blade-zondicons
git clone git@github.com:blade-ui-kit/docs.git $BLADE/docs
git clone git@github.com:blade-ui-kit/tallstack.dev.git $BLADE/tallstack.dev

# Laravel
git clone git@github.com:laravel/browser-kit-testing.git $LARAVEL/browser-kit-testing
git clone git@github.com:laravel/cashier-stripe.git $LARAVEL/cashier-stripe
git clone git@github.com:laravel/cashier-paddle.git $LARAVEL/cashier-paddle
git clone git@github.com:laravel/docs.git $LARAVEL/docs
git clone git@github.com:laravel/dusk.git $LARAVEL/dusk
git clone git@github.com:laravel/echo.git $LARAVEL/echo
git clone git@github.com:laravel/envoy.git $LARAVEL/envoy
git clone git@github.com:laravel/forge-sdk.git $LARAVEL/forge-sdk
git clone git@github.com:laravel/framework.git $LARAVEL/framework
git clone git@github.com:laravel/helpers.git $LARAVEL/helpers
git clone git@github.com:laravel/horizon.git $LARAVEL/horizon
git clone git@github.com:laravel/installer.git $LARAVEL/installer
git clone git@github.com:laravel/laravel.git $LARAVEL/laravel
git clone git@github.com:laravel/lumen.git $LARAVEL/lumen
git clone git@github.com:laravel/lumen-framework.git $LARAVEL/lumen-framework
git clone git@github.com:laravel/lumen-installer.git $LARAVEL/lumen-installer
git clone git@github.com:laravel/nexmo-notification-channel.git $LARAVEL/nexmo-notification-channel
git clone git@github.com:laravel/nova.git $LARAVEL/nova
git clone git@github.com:laravel/passport.git $LARAVEL/passport
git clone git@github.com:laravel/sanctum.git $LARAVEL/sanctum
git clone git@github.com:laravel/scout.git $LARAVEL/scout
git clone git@github.com:laravel/slack-notification-channel.git $LARAVEL/slack-notification-channel
git clone git@github.com:laravel/socialite.git $LARAVEL/socialite
git clone git@github.com:laravel/telescope.git $LARAVEL/telescope
git clone git@github.com:laravel/tinker.git $LARAVEL/tinker
git clone git@github.com:laravel/ui.git $LARAVEL/ui
