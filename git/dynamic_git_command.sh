#!/usr/bin/env bash

email=$(git config user.email)

if [ "$email" = "kkrauss@gopro.com" ];then
  ssh -i ~/.ssh/id_rsa_gopro "$@"
else
  ssh -i ~/.ssh/id_rsa "$@"
fi
