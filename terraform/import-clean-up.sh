#!/usr/bin/env bash

set -euo pipefail

shopt -s extglob 

rm -v !("main.tf"|"import-clean-up.sh"|"import-github-org-terraform.sh")