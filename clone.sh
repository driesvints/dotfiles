



#!/bin/sh

echo "Cloning repositories..."


#!/bin/sh

echo "Cloning repositories..."

PROJECTS=$HOME/Projects
ACADEMIC=$PROJECTS/academic
ADMIN = $PROJECTS/admin
NOTEBOOKS=$PROJECTS/notebooks
PERSONAL=$PROJECTS/personal
TOOLS=$PROJECTS/tools
TUTORIALS=$PROJECTS/tutorials
WORK=$PROJECTS/work

# Academic
PHD=$ACADEMIC/PhD

git clone https://github.com/thomas-hervey/Dissertation.git $PHD/Dissertation
git clone https://github.com/thomas-hervey/HERVEY_PROPOSAL.git $PHD/HERVEY_PROPOSAL
git clone https://github.com/thomas-hervey/HERVEY_DISSERTATION.git $PHD/HERVEY_DISSERTATION

# Admin
git clone https://github.com/thomas-hervey/dotfiles.git $ADMIN/dotfiles

# Notebooks

# Personal
git clone https://github.com/thomas-hervey/hackintosh.git $PERSONAL/hackintosh
git clone https://github.com/thomas-hervey/thomas-hervey.github.io.git $PERSONAL/thomas-hervey.github.io
git clone https://github.com/thomas-hervey/ticketing.git $PERSONAL/ticketing


# Tools

# Tutorials


# Work
SITES=$HOME/Sites
BLADE=$SITES/blade-ui-kit
LARAVEL=$SITES/laravel

# Personal
git clone git@github.com:driesvints/driesvints.com.git $SITES/driesvints.com
git clone git@github.com:driesvints/learn-laravel-cashier.com.git $SITES/learn-laravel-cashier.com
git clone git@github.com:driesvints/pixelperfect.company.git $SITES/pixelperfect.company
git clone git@github.com:driesvints/vat-calculator.git $SITES/vat-calculator
git clone git@github.com:eventyio/eventy.io.git $SITES/eventy.io
git clone git@github.com:fullstackbelgium/fullstackbelgium.be.git $SITES/fullstackbelgium.be
git clone git@github.com:fullstackeurope/fullstackeurope.com.git $SITES/fullstackeurope.com
git clone git@github.com:github-php/sponsors.git $SITES/php-github-sponsors
git clone git@github.com:laravelio/laravel.io.git $SITES/laravel.io
git clone git@github.com:laravelio/paste.laravel.io.git $SITES/paste.laravel.io

# Blade UI Kit
git clone git@github.com:blade-ui-kit/demo.git $BLADE/demo
git clone git@github.com:blade-ui-kit/blade-docs.git $BLADE/blade-docs
git clone git@github.com:blade-ui-kit/blade-heroicons.git $BLADE/blade-heroicons
git clone git@github.com:blade-ui-kit/blade-icons.git $BLADE/blade-icons
git clone git@github.com:blade-ui-kit/blade-ui-kit.git $BLADE/blade-ui-kit
git clone git@github.com:blade-ui-kit/blade-ui-kit.com.git $BLADE/blade-ui-kit.com
git clone git@github.com:blade-ui-kit/blade-zondicons.git $BLADE/blade-zondicons
git clone git@github.com:blade-ui-kit/docs.git $BLADE/docs

# Laravel
git clone git@github.com:laravel/beep.git $LARAVEL/beep
git clone git@github.com:laravel/breeze.git $LARAVEL/breeze
git clone git@github.com:laravel/breeze-next.git $LARAVEL/breeze-next
git clone git@github.com:laravel/browser-kit-testing.git $LARAVEL/browser-kit-testing
git clone git@github.com:laravel/cashier-stripe.git $LARAVEL/cashier-stripe
git clone git@github.com:laravel/cashier-paddle.git $LARAVEL/cashier-paddle
git clone git@github.com:laravel/docs.git $LARAVEL/docs
git clone git@github.com:laravel/dusk.git $LARAVEL/dusk
git clone git@github.com:laravel/echo.git $LARAVEL/echo
git clone git@github.com:laravel/envoy.git $LARAVEL/envoy
git clone git@github.com:laravel/forge.git $LARAVEL/forge
git clone git@github.com:laravel/forge-cli.git $LARAVEL/forge-cli
git clone git@github.com:laravel/forge-sdk.git $LARAVEL/forge-sdk
git clone git@github.com:laravel/fortify.git $LARAVEL/fortify
git clone git@github.com:laravel/framework.git $LARAVEL/framework
git clone git@github.com:laravel/helpers.git $LARAVEL/helpers
git clone git@github.com:laravel/horizon.git $LARAVEL/horizon
git clone git@github.com:laravel/installer.git $LARAVEL/installer
git clone git@github.com:laravel/jetstream.git $LARAVEL/jetstream
git clone git@github.com:laravel/laravel.git $LARAVEL/laravel
git clone git@github.com:laravel/laravel.com.git $LARAVEL/laravel.com
git clone git@github.com:laravel/legacy-factories.git $LARAVEL/legacy-factories
git clone git@github.com:laravel/lumen.git $LARAVEL/lumen
git clone git@github.com:laravel/lumen-framework.git $LARAVEL/lumen-framework
git clone git@github.com:laravel/nova.git $LARAVEL/nova
git clone git@github.com:laravel/octane.git $LARAVEL/octane
git clone git@github.com:laravel/package-template.git $LARAVEL/package-template
git clone git@github.com:laravel/passport.git $LARAVEL/passport
git clone git@github.com:laravel/sail.git $LARAVEL/sail
git clone git@github.com:laravel/sail-server.git $LARAVEL/sail-server
git clone git@github.com:laravel/sanctum.git $LARAVEL/sanctum
git clone git@github.com:laravel/scout.git $LARAVEL/scout
git clone git@github.com:laravel/serializable-closure.git $LARAVEL/serializable-closure
git clone git@github.com:laravel/slack-notification-channel.git $LARAVEL/slack-notification-channel
git clone git@github.com:laravel/socialite.git $LARAVEL/socialite
git clone git@github.com:laravel/spark-next-docs.git $LARAVEL/spark-next-docs
git clone git@github.com:laravel/spark-paddle.git $LARAVEL/spark-paddle
git clone git@github.com:laravel/spark-stripe.git $LARAVEL/spark-stripe
git clone git@github.com:laravel/spark.laravel.com.git $LARAVEL/spark.laravel.com
git clone git@github.com:laravel/telescope.git $LARAVEL/telescope
git clone git@github.com:laravel/tinker.git $LARAVEL/tinker
git clone git@github.com:laravel/ui.git $LARAVEL/ui
git clone git@github.com:laravel/valet.git $LARAVEL/valet
git clone git@github.com:laravel/vapor-ui.git $LARAVEL/vapor-ui
git clone git@github.com:laravel/vonage-notification-channel.git $LARAVEL/vonage-notification-channel
