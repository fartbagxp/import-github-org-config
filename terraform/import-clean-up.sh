#!/usr/bin/env bash

#################################################################
## This script cleans up the repository for a clean run. It'll 
## remove all of the existing output of the import github org 
## script
##
## Usage:
## If the environment variable GITHUB_OWNER is set, it'll use
## that as the organization folder to delete files for.
## > bash import-clean-up.sh 
##
## Alternatively, it's possible to set the organization folder
## as the first parameter.
## > bash import-clean-up.sh GITHUB_OWNER
##
#################################################################
shopt -s extglob

ORG=""

if [ -n "$GITHUB_OWNER" ]; then
  ORG="$GITHUB_OWNER"
elif [ -n "$1" ]; then
  ORG="$1"
else
  echo "Error: GITHUB_OWNER environment variable or organization in first arg is not set."
  echo "Usage: bash import-clean-up.sh GITHUB_OWNER"
  exit 1
fi

echo "Cleaning up import folder structure in $ORG."

## Be very selective on what we delete, rm -rf is a footgun.
rm -rvf "$ORG/github-organization.tf"
rm -rvf "$ORG/github-public-repos.tf"
rm -rvf "$ORG/github-private-repos.tf"
rm -rvf "$ORG/github-team-memberships.tf"
rm -rvf "$ORG/github-teams.tf"
rm -rvf "$ORG/github-users.tf"
rm -rvf "$ORG/terraform.tfstate"
rm -rvf "$ORG/terraform.tfstate.backup"
rm -rvf "$ORG/.terraform.lock.hcl"
rm -rvf "$ORG/.terraform"

echo "Completed cleaning up folder structure in $ORG."