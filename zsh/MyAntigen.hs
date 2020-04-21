{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ExtendedDefaultRules #-}
module MyAntigen where

import Antigen (AntigenConfig (..)
              , defaultConfig
              , bundle
              , antigen
              , antigenSourcingStrategy
              , local
              , ZshPlugin(..)
              , )

bundles =
  [ bundle "Tarrasch/zsh-functional"
  , bundle "Tarrasch/zsh-bd"
  , bundle "Tarrasch/zsh-command-not-found"
  , bundle "Tarrasch/zsh-colors"
  , bundle "Tarrasch/zsh-autoenv"
  , bundle "Tarrasch/zsh-i-know"
  , bundle "Tarrasch/pure"
  , bundle "Tarrasch/zsh-mcd"
  , bundle "Tarrasch/zsh-syntax-highlighting" -- Just to pinpoint the version
  , bundle "Tarrasch/zsh-history-substring-search" -- Upstream started to break
  ]

config = defaultConfig { plugins = bundles }

main :: IO ()
main = antigen config
