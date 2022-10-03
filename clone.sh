#!/bin/sh

echo "Cloning repositories..."

WORK=$HOME/Workspace
workRepos = 
(
"ad-control-plane"
"ad-data-plane"
"ad-dataflow-samples"
"ad-dp-router"
"ad-ds-tools"
"ad-helm-charts"
"ad-integration-tests"
"ad-sdk-examples"
"ad-training-orchestration-service"
"ad_functional_test_suite"
"anomaly-detection-api"
"anomaly-detection-service"
"anomaly-detection-ui"
"anomaly-detection-univariate-kernel"
"anomaly-detection-univariate-service"
"connector-framework"
"dotfiles"
"idp-kernel"
"idp-service"
"madora"
"model-packaging"
"ocas-canary"
"ocas-decision-common"
"ocas-decision-data-plane"
"ocas-decision-datapreprocessing"
"ocas-infra-ad"
"ssh_configs"
"zsh-autocomplete"
"zsh-autosuggestions"
)
#Should already be cloned
#git clone git@github.com:deepakv158/.dotfiles.git ~/.dotfiles

#Utilities
git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git $WORK/zsh-autocomplete

# Personal

# Work repos
git clone ssh://git@bitbucket.oci.oraclecorp.com:7999/SECEDGE/ssh_configs.git $WORK/ssh_configs

foreach repo ${workRepos[@]}
do
git clone ssh://git@bitbucket.oci.oraclecorp.com:7999/ocais/$repo.git
done
