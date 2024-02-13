#!/bin/sh

echo "Cloning repositories..."

CODE=$HOME/Code
SITES=$HOME/Herd
BLADE=$CODE/blade-ui-kit
LARAVEL=$CODE/laravel

# Sites
git clone git@github.com:blade-ui-kit/blade-ui-kit.com.git $SITES/blade-ui-kit.com
git clone git@github.com:laravel/blog.laravel.com.git $SITES/blog.laravel.com
git clone git@github.com:blade-ui-kit/demo.git $SITES/demo.blade-ui-kit.com
git clone git@github.com:driesvints/driesvints.com.git $SITES/driesvints.com
git clone git@github.com:laravel/envoyer.git $SITES/envoyer
git clone git@github.com:eventyio/eventy.io.git $SITES/eventy.io
git clone git@github.com:laravel/forge.git $SITES/forge
git clone git@github.com:fullstackeurope/fullstackeurope.com.git $SITES/fullstackeurope.com
git clone git@github.com:laravel/laravel.com.git $SITES/laravel.com
git clone git@github.com:laravelio/laravel.io.git $SITES/laravel.io
git clone git@github.com:laravelio/paste.laravel.io.git $SITES/paste.laravel.io
git clone git@github.com:laravel/nova.laravel.com.git $SITES/nova
git clone git@github.com:laravel/spark.laravel.com.git $SITES/spark.laravel.com
git clone git@github.com:laravel/vapor.git $SITES/vapor

# Personal
git clone git@github.com:lmsqueezy/laravel.git $CODE/lmsqueezy-laravel
git clone git@github.com:driesvints/vat-calculator.git $CODE/vat-calculator

# Blade UI Kit
git clone git@github.com:blade-ui-kit/blade-docs.git $BLADE/blade-docs
git clone git@github.com:blade-ui-kit/blade-heroicons.git $BLADE/blade-heroicons
git clone git@github.com:blade-ui-kit/blade-icons.git $BLADE/blade-icons
git clone git@github.com:blade-ui-kit/blade-ui-kit.git $BLADE/blade-ui-kit
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
git clone git@github.com:laravel/folio.git $LARAVEL/folio
git clone git@github.com:laravel/forge-cli.git $LARAVEL/forge-cli
git clone git@github.com:laravel/forge-sdk.git $LARAVEL/forge-sdk
git clone git@github.com:laravel/fortify.git $LARAVEL/fortify
git clone git@github.com:laravel/framework.git $LARAVEL/framework
git clone git@github.com:laravel/helpers.git $LARAVEL/helpers
git clone git@github.com:laravel/horizon.git $LARAVEL/horizon
git clone git@github.com:laravel/installer.git $LARAVEL/installer
git clone git@github.com:laravel/jetstream.git $LARAVEL/jetstream
git clone git@github.com:laravel/jetstream-docs.git $LARAVEL/jetstream-docs
git clone git@github.com:laravel/laravel.git $LARAVEL/laravel
git clone git@github.com:laravel/legacy-factories.git $LARAVEL/legacy-factories
git clone git@github.com:laravel/lumen.git $LARAVEL/lumen
git clone git@github.com:laravel/lumen-framework.git $LARAVEL/lumen-framework
git clone git@github.com:laravel/nova.git $LARAVEL/nova
git clone git@github.com:laravel/octane.git $LARAVEL/octane
git clone git@github.com:laravel/package-template.git $LARAVEL/package-template
git clone git@github.com:laravel/pail.git $LARAVEL/pail
git clone git@github.com:laravel/passport.git $LARAVEL/passport
git clone git@github.com:laravel/pennant.git $LARAVEL/pennant
git clone git@github.com:laravel/pint.git $LARAVEL/pint
git clone git@github.com:laravel/precognition.git $LARAVEL/precognition
git clone git@github.com:laravel/prompts.git $LARAVEL/prompts
git clone git@github.com:laravel/pulse.git $LARAVEL/pulse
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
git clone git@github.com:laravel/telescope.git $LARAVEL/telescope
git clone git@github.com:laravel/tinker.git $LARAVEL/tinker
git clone git@github.com:laravel/ui.git $LARAVEL/ui
git clone git@github.com:laravel/valet.git $LARAVEL/valet
git clone git@github.com:laravel/vapor-cli.git $LARAVEL/vapor-cli
git clone git@github.com:laravel/vapor-core.git $LARAVEL/vapor-core
git clone git@github.com:laravel/vapor-ui.git $LARAVEL/vapor-ui
git clone git@github.com:laravel/vite-plugin.git $LARAVEL/vite-plugin
git clone git@github.com:livewire/volt.git $LARAVEL/volt
git clone git@github.com:laravel/vonage-notification-channel.git $LARAVEL/vonage-notification-channel
