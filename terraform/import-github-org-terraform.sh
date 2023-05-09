#!/usr/bin/env bash
set -euo pipefail

start="$(date +%s)"

#################################################################
## This script imports Github configuration as terraform code 
## to store as tfstate.
## 
## Before using, set environment variables $GITHUB_TOKEN and 
## $GITHUB_OWNER.
## 
## GITHUB_TOKEN is a token with read access to users, memberships,
## teams, of a Github organization.
## Github_Owner is the Github organization name.
##
## Usage:
## > bash import-github-org-terraform.sh 
#################################################################

### Check for tool installation
if ! command -v curl >/dev/null 2>&1; then
  echo "curl is not installed. Please install curl and try again."
  exit 1
fi

if ! command -v jq >/dev/null 2>&1; then
  echo "jq is not installed. Please install jq and try again."
  exit 1
fi

if ! command -v terraform >/dev/null 2>&1; then
  echo "terraform is not installed. Please install terraform and try again."
  exit 1
fi

###
## GLOBAL VARIABLES
###
if [ -z "$GITHUB_TOKEN" ]; then
  echo "Error: GITHUB_TOKEN environment variable is not set."
  exit 1
fi

if [ -z "$GITHUB_OWNER" ]; then
  echo "Error: GITHUB_OWNER environment variable is not set."
  exit 1
fi

ORG="${GITHUB_OWNER}"
API_URL_PREFIX=${API_URL_PREFIX:-'https://api.github.com'}

###
## FUNCTIONS
###

# Organization
import_organization () {
  organization=$(curl -s -H "Authorization: token ${GITHUB_TOKEN}" "${API_URL_PREFIX}/orgs/${ORG}";)
  ORG_ID=$(echo "$organization" | jq -r '.id')
  ORG_BILLING_EMAIL=$(echo "$organization" | jq -r '.billing_email')
  ORG_COMPANY=$(echo "$organization" | jq -r '.company')
  ORG_BLOG=$(echo "$organization" | jq -r '.blog')
  ORG_EMAIL=$(echo "$organization" | jq -r '.email')
  ORG_TWITTER_USERNAME=$(echo "$organization" | jq -r '.twitter_username')
  ORG_LOCATION=$(echo "$organization" | jq -r '.location')
  ORG_NAME=$(echo "$organization" | jq -r '.name')
  ORG_DESCRIPTION=$(echo "$organization" | jq -r '.description')
  ORG_HAS_ORGANIZATION_PROJECT=$(echo "$organization" | jq -r '.has_organization_projects')
  ORG_HAS_REPOSITORY_PROJECT=$(echo "$organization" | jq -r '.has_repository_projects')
  ORG_DEFAULT_REPOSITORY_PERMISSION=$(echo "$organization" | jq -r '.default_repository_permission')
  ORG_MEMBERS_CAN_CREATE_REPOSITORY=$(echo "$organization" | jq -r '.members_can_create_repositories')
  ORG_MEMBERS_CAN_CREATE_PUBLIC_REPOSITORY=$(echo "$organization" | jq -r '.members_can_create_public_repositories')
  ORG_MEMBERS_CAN_CREATE_PRIVATE_REPOSITORY=$(echo "$organization" | jq -r '.members_can_create_private_repositories')
  ORG_MEMBERS_CAN_CREATE_INTERNAL_REPOSITORY=$(echo "$organization" | jq -r '.members_can_create_internal_repositories')
  ORG_MEMBERS_CAN_CREATE_PAGES=$(echo "$organization" | jq -r '.members_can_create_pages')
  ORG_MEMBERS_CAN_CREATE_PUBLIC_PAGES=$(echo "$organization" | jq -r '.members_can_create_public_pages')
  ORG_MEMBERS_CAN_CREATE_PRIVATE_PAGES=$(echo "$organization" | jq -r '.members_can_create_private_pages')
  ORG_MEMBERS_CAN_CREATE_FORK_PRIVATE_REPOSITORY=$(echo "$organization" | jq -r '.members_can_fork_private_repositories')
  ORG_WEB_COMMIT_SIGNOFF_REQUIRED=$(echo "$organization" | jq -r '.web_commit_signoff_required')
  ORG_ADVANCED_SECURITY_ENABLED_FOR_NEW_REPOSITORY=$(echo "$organization" | jq -r '.advanced_security_enabled_for_new_repositories')
  ORG_DEPENDABOT_ALERT_ENABLED_FOR_NEW_REPOSITORY=$(echo "$organization" | jq -r '.dependabot_alerts_enabled_for_new_repositories')
  ORG_DEPENDABOT_SECURITY_UPDATES_ENABLED_FOR_NEW_REPOSITORY=$(echo "$organization" | jq -r '.dependabot_security_updates_enabled_for_new_repositories')
  ORG_DEPENDENCY_GRAPH_ENABLED_FOR_NEW_REPOSITORY=$(echo "$organization" | jq -r '.dependency_graph_enabled_for_new_repositories')
  ORG_SECRET_SCANNING_ENABLED_FOR_NEW_REPOSITORY=$(echo "$organization" | jq -r '.secret_scanning_enabled_for_new_repositories')
  ORG_SECRET_SCANNING_PUSH_PROTECTION_ENABLED_FOR_NEW_REPOSITORY=$(echo "$organization" | jq -r '.secret_scanning_push_protection_enabled_for_new_repositories')

      cat >> "github-organization.tf" << EOF
resource "github_organization_settings" "$ORG" {
  billing_email                                                = "$ORG_BILLING_EMAIL"
  company                                                      = "$ORG_COMPANY"
  blog                                                         = "$ORG_BLOG"
  email                                                        = "$ORG_EMAIL"
  twitter_username                                             = "$ORG_TWITTER_USERNAME"
  location                                                     = "$ORG_LOCATION"
  name                                                         = "$ORG_NAME"
  description                                                  = "$ORG_DESCRIPTION"
  has_organization_projects                                    = "$ORG_HAS_ORGANIZATION_PROJECT"
  has_repository_projects                                      = "$ORG_HAS_REPOSITORY_PROJECT"
  default_repository_permission                                = "$ORG_DEFAULT_REPOSITORY_PERMISSION"
  members_can_create_repositories                              = "$ORG_MEMBERS_CAN_CREATE_REPOSITORY"
  members_can_create_public_repositories                       = "$ORG_MEMBERS_CAN_CREATE_PUBLIC_REPOSITORY"
  members_can_create_private_repositories                      = "$ORG_MEMBERS_CAN_CREATE_PRIVATE_REPOSITORY"
  members_can_create_internal_repositories                     = "$ORG_MEMBERS_CAN_CREATE_INTERNAL_REPOSITORY"
  members_can_create_pages                                     = "$ORG_MEMBERS_CAN_CREATE_PAGES"
  members_can_create_public_pages                              = "$ORG_MEMBERS_CAN_CREATE_PUBLIC_PAGES"
  members_can_create_private_pages                             = "$ORG_MEMBERS_CAN_CREATE_PRIVATE_PAGES"
  members_can_fork_private_repositories                        = "$ORG_MEMBERS_CAN_CREATE_FORK_PRIVATE_REPOSITORY"
  web_commit_signoff_required                                  = "$ORG_WEB_COMMIT_SIGNOFF_REQUIRED"
  advanced_security_enabled_for_new_repositories               = "$ORG_ADVANCED_SECURITY_ENABLED_FOR_NEW_REPOSITORY"
  dependabot_alerts_enabled_for_new_repositories               = "$ORG_DEPENDABOT_ALERT_ENABLED_FOR_NEW_REPOSITORY"
  dependabot_security_updates_enabled_for_new_repositories     = "$ORG_DEPENDABOT_SECURITY_UPDATES_ENABLED_FOR_NEW_REPOSITORY"
  dependency_graph_enabled_for_new_repositories                = "$ORG_DEPENDENCY_GRAPH_ENABLED_FOR_NEW_REPOSITORY"
  secret_scanning_enabled_for_new_repositories                 = "$ORG_SECRET_SCANNING_ENABLED_FOR_NEW_REPOSITORY"
  secret_scanning_push_protection_enabled_for_new_repositories = "$ORG_SECRET_SCANNING_PUSH_PROTECTION_ENABLED_FOR_NEW_REPOSITORY"
}

EOF

  terraform import "github_organization_settings.${ORG}" "${ORG_ID}"
}

# Public Repos
  # You can only list 100 items per page, so you can only clone 100 at a time.
  # This function uses the API to calculate how many pages of public repos you have.
get_public_pagination () {
  public_pages=$(curl -I -H "Authorization: token ${GITHUB_TOKEN}" "${API_URL_PREFIX}/orgs/${ORG}/repos?type=public&per_page=100" | grep -Eo '&page=\d+' | grep -Eo '[0-9]+' | tail -1;)
  echo "${public_pages:-1}"
}

  # This function uses the output from above and creates an array counting from 1->$ 
limit_public_pagination () {
  seq "$(get_public_pagination)"
}

  # Now lets import the repos, starting with page 1 and iterating through the pages
import_public_repos () {
  for PAGE in $(limit_public_pagination); do
  
    for i in $(curl -s -H "Authorization: token ${GITHUB_TOKEN}" "${API_URL_PREFIX}/orgs/${ORG}/repos?type=public&page=${PAGE}&per_page=100" | jq -r 'sort_by(.name) | .[] | .name'); do
      PUBLIC_REPO_PAYLOAD=$(curl -s -H "Authorization: token ${GITHUB_TOKEN}" -H "Accept: application/vnd.github.mercy-preview+json" "${API_URL_PREFIX}/repos/${ORG}/${i}")
  
      PUBLIC_REPO_DESCRIPTION=$(echo "$PUBLIC_REPO_PAYLOAD" | jq -r '.description | select(type == "string")' | sed "s/\"/'/g")
      PUBLIC_REPO_DOWNLOADS=$(echo "$PUBLIC_REPO_PAYLOAD" | jq -r .has_downloads)
      PUBLIC_REPO_WIKI=$(echo "$PUBLIC_REPO_PAYLOAD" | jq -r .has_wiki)
      PUBLIC_REPO_ISSUES=$(echo "$PUBLIC_REPO_PAYLOAD" | jq -r .has_issues)
      PUBLIC_REPO_ARCHIVED=$(echo "$PUBLIC_REPO_PAYLOAD" | jq -r .archived)
      PUBLIC_REPO_TOPICS=$(echo "$PUBLIC_REPO_PAYLOAD" | jq -r .topics)
      PUBLIC_REPO_PROJECTS=$(echo "$PUBLIC_REPO_PAYLOAD" | jq -r .has_projects)
      PUBLIC_REPO_MERGE_COMMIT=$(echo "$PUBLIC_REPO_PAYLOAD" | jq -r .allow_merge_commit)
      PUBLIC_REPO_REBASE_MERGE=$(echo "$PUBLIC_REPO_PAYLOAD" | jq -r .allow_rebase_merge)
      PUBLIC_REPO_SQUASH_MERGE=$(echo "$PUBLIC_REPO_PAYLOAD" | jq -r .allow_squash_merge)
      PUBLIC_REPO_AUTO_INIT=$(echo "$PUBLIC_REPO_PAYLOAD" | jq -r '.auto_init == true')
      PUBLIC_REPO_DEFAULT_BRANCH=$(echo "$PUBLIC_REPO_PAYLOAD" | jq -r .default_branch)
      PUBLIC_REPO_GITIGNORE_TEMPLATE=$(echo "$PUBLIC_REPO_PAYLOAD" | jq -r .gitignore_template)
      PUBLIC_REPO_LICENSE_TEMPLATE=$(echo "$PUBLIC_REPO_PAYLOAD" | jq -r '.license_template | select(type == "string")')
      PUBLIC_REPO_HOMEPAGE_URL=$(echo "$PUBLIC_REPO_PAYLOAD" | jq -r '.homepage | select(type == "string")')
     
      # Terraform doesn't like '.' in resource names, so if one exists then replace it with a dash
      TERRAFORM_PUBLIC_REPO_NAME=$(echo "${i}" | tr  "."  "-")

      ## Terraform import cannot handle a name starting with a number, add _ if 
      ## the repo name starts with a number.
      if [[ $TERRAFORM_PUBLIC_REPO_NAME =~ ^[0-9] ]]; then
        TERRAFORM_PUBLIC_REPO_NAME="_$TERRAFORM_PUBLIC_REPO_NAME"
      fi

      cat >> "github-public-repos.tf" << EOF
resource "github_repository" "${TERRAFORM_PUBLIC_REPO_NAME}" {
  name               = "${i}"
  topics             = ${PUBLIC_REPO_TOPICS}
  description        = "${PUBLIC_REPO_DESCRIPTION}"
  visibility         = "public"
  has_wiki           = ${PUBLIC_REPO_WIKI}
  has_projects       = ${PUBLIC_REPO_PROJECTS}
  has_downloads      = ${PUBLIC_REPO_DOWNLOADS}
  has_issues         = ${PUBLIC_REPO_ISSUES}
  archived           = ${PUBLIC_REPO_ARCHIVED}
  allow_merge_commit = ${PUBLIC_REPO_MERGE_COMMIT}
  allow_rebase_merge = ${PUBLIC_REPO_REBASE_MERGE}
  allow_squash_merge = ${PUBLIC_REPO_SQUASH_MERGE}
  auto_init          = ${PUBLIC_REPO_AUTO_INIT}
  gitignore_template = ${PUBLIC_REPO_GITIGNORE_TEMPLATE}
  license_template   = "${PUBLIC_REPO_LICENSE_TEMPLATE}"
  homepage_url       = "${PUBLIC_REPO_HOMEPAGE_URL}"
}
EOF

      # Import the Repo
      terraform import "github_repository.${TERRAFORM_PUBLIC_REPO_NAME}" "${i}"
    done
  done
}

# Private Repos
get_private_pagination () {
  priv_pages=$(curl -I -H "Authorization: token ${GITHUB_TOKEN}" "${API_URL_PREFIX}/orgs/${ORG}/repos?type=private&per_page=100" | grep -Eo '&page=\d+' | grep -Eo '[0-9]+' | tail -1;)
  echo "${priv_pages:-1}"
}

limit_private_pagination () {
  seq "$(get_private_pagination)"
}

import_private_repos () {
  for PAGE in $(limit_private_pagination); do

    for i in $(curl -s -H "Authorization: token ${GITHUB_TOKEN}" "${API_URL_PREFIX}/orgs/${ORG}/repos?type=private&page=${PAGE}&per_page=100" | jq -r 'sort_by(.name) | .[] | .name'); do
      PRIVATE_REPO_PAYLOAD=$(curl -s -H "Authorization: token ${GITHUB_TOKEN}" -H "Accept: application/vnd.github.mercy-preview+json" "${API_URL_PREFIX}/repos/${ORG}/${i}")

      PRIVATE_REPO_DESCRIPTION=$(echo "$PRIVATE_REPO_PAYLOAD" | jq -r '.description | select(type == "string")' | sed "s/\"/'/g")
      PRIVATE_REPO_DOWNLOADS=$(echo "$PRIVATE_REPO_PAYLOAD" | jq -r .has_downloads)
      PRIVATE_REPO_WIKI=$(echo "$PRIVATE_REPO_PAYLOAD" | jq -r .has_wiki)
      PRIVATE_REPO_ISSUES=$(echo "$PRIVATE_REPO_PAYLOAD" | jq -r .has_issues)
      PRIVATE_REPO_ARCHIVED=$(echo "$PRIVATE_REPO_PAYLOAD" | jq -r .archived)
      PRIVATE_REPO_TOPICS=$(echo "$PRIVATE_REPO_PAYLOAD" | jq -r .topics)
      PRIVATE_REPO_PROJECTS=$(echo "$PRIVATE_REPO_PAYLOAD" | jq -r .has_projects)
      PRIVATE_REPO_MERGE_COMMIT=$(echo "$PRIVATE_REPO_PAYLOAD" | jq -r .allow_merge_commit)
      PRIVATE_REPO_REBASE_MERGE=$(echo "$PRIVATE_REPO_PAYLOAD" | jq -r .allow_rebase_merge)
      PRIVATE_REPO_SQUASH_MERGE=$(echo "$PRIVATE_REPO_PAYLOAD" | jq -r .allow_squash_merge)
      PRIVATE_REPO_AUTO_INIT=$(echo "$PRIVATE_REPO_PAYLOAD" | jq -r .auto_init)
      PRIVATE_REPO_DEFAULT_BRANCH=$(echo "$PRIVATE_REPO_PAYLOAD" | jq -r .default_branch)
      PRIVATE_REPO_GITIGNORE_TEMPLATE=$(echo "$PRIVATE_REPO_PAYLOAD" | jq -r .gitignore_template)
      PRIVATE_REPO_LICENSE_TEMPLATE=$(echo "$PRIVATE_REPO_PAYLOAD" | jq -r '.license_template | select(type == "string")')
      PRIVATE_REPO_HOMEPAGE_URL=$(echo "$PRIVATE_REPO_PAYLOAD" | jq -r '.homepage | select(type == "string")')
     
      # Terraform doesn't like '.' in resource names, so if one exists then replace it with a dash
      TERRAFORM_PRIVATE_REPO_NAME=$(echo "${i}" | tr  "."  "-")

      ## Terraform import cannot handle a name starting with a number, add _ if 
      ## the repo name starts with a number.
      if [[ $TERRAFORM_PRIVATE_REPO_NAME =~ ^[0-9] ]]; then
        TERRAFORM_PRIVATE_REPO_NAME="_$TERRAFORM_PRIVATE_REPO_NAME"
      fi

      cat >> "github-private-repos.tf" << EOF
resource "github_repository" "${TERRAFORM_PRIVATE_REPO_NAME}" {
  name               = "${i}"
  private            = true
  description        = "${PRIVATE_REPO_DESCRIPTION}"
  has_wiki           = ${PRIVATE_REPO_WIKI}
  has_projects       = ${PRIVATE_REPO_PROJECTS}
  has_downloads      = ${PRIVATE_REPO_DOWNLOADS}
  has_issues         = ${PRIVATE_REPO_ISSUES}
  archived           = ${PRIVATE_REPO_ARCHIVED}
  topics             = ${PRIVATE_REPO_TOPICS}
  allow_merge_commit = ${PRIVATE_REPO_MERGE_COMMIT}
  allow_rebase_merge = ${PRIVATE_REPO_REBASE_MERGE}
  allow_squash_merge = ${PRIVATE_REPO_SQUASH_MERGE}
  auto_init          = ${PRIVATE_REPO_AUTO_INIT}
  gitignore_template = ${PRIVATE_REPO_GITIGNORE_TEMPLATE}
  license_template   = "${PRIVATE_REPO_LICENSE_TEMPLATE}"
  homepage_url       = "${PRIVATE_REPO_HOMEPAGE_URL}"
}
EOF
      # Import the Repo
      terraform import "github_repository.${TERRAFORM_PRIVATE_REPO_NAME}" "${i}"
    done
  done
}

# Users
import_users () {
  for PAGE in {1..10}; do
    for i in $(curl -s -H "Authorization: token ${GITHUB_TOKEN}" "${API_URL_PREFIX}/orgs/${ORG}/members?per_page=100&page=${PAGE}" | jq -r 'sort_by(.login) | .[] | .login'); do
    MEMBERSHIP_ROLE=$(curl -s -H "Authorization: token ${GITHUB_TOKEN}" "${API_URL_PREFIX}/orgs/${ORG}/memberships/${i}" | jq -r .role)
    USERNAME_PARSE=$(echo "$i" | tr "-" "_" | tr '[:upper:]' '[:lower:]')

    ## Terraform import cannot handle a name starting with a number, add _ if 
    ## the username starts with a number.
    if [[ $USERNAME_PARSE =~ ^[0-9] ]]; then
      USERNAME_PARSE="_$USERNAME_PARSE"
    fi
  
  cat >> "github-users.tf" << EOF
resource "github_membership" "${USERNAME_PARSE}" {
  username        = "${i}"
  role            = "${MEMBERSHIP_ROLE}"
}
EOF
    terraform import "github_membership.${USERNAME_PARSE}" "${ORG}:${i}"
    done
  done
}

# Teams
import_teams () {
  for i in $(curl -s -H "Authorization: token ${GITHUB_TOKEN}" -H "Accept: application/vnd.github.hellcat-preview+json" "${API_URL_PREFIX}/orgs/${ORG}/teams?access_token=${GITHUB_TOKEN}&per_page=100" | jq -r 'sort_by(.name) | .[] | .id'); do
    TEAM_PAYLOAD=$(curl -s -H "Authorization: token ${GITHUB_TOKEN}" -H "Accept: application/vnd.github.hellcat-preview+json" "${API_URL_PREFIX}/teams/${i}?access_token=${GITHUB_TOKEN}&per_page=100")

    TEAM_NAME=$(echo "$TEAM_PAYLOAD" | jq -r .name)
    TEAM_NAME_NO_SPACE=$(echo "$TEAM_NAME" | tr " " "_" | tr "/" "_" | tr "@" "_")
    TEAM_PRIVACY=$(echo "$TEAM_PAYLOAD" | jq -r .privacy)
    TEAM_DESCRIPTION=$(echo "$TEAM_PAYLOAD" | jq -r '.description | select(type == "string")')
    TEAM_PARENT_ID=$(echo "$TEAM_PAYLOAD" | jq -r .parent.id)
  
    if [[ "${TEAM_PRIVACY}" == "closed" ]]; then
      cat >> "github-teams.tf" << EOF
resource "github_team" "${TEAM_NAME_NO_SPACE}" {
  name           = "${TEAM_NAME}"
  description    = "${TEAM_DESCRIPTION}"
  privacy        = "closed"
  parent_team_id = ${TEAM_PARENT_ID}
}
EOF
    elif [[ "${TEAM_PRIVACY}" == "secret" ]]; then
      cat >> "github-teams.tf" << EOF
resource "github_team" "${TEAM_NAME_NO_SPACE}" {
  name        = "${TEAM_NAME}"
  description = "${TEAM_DESCRIPTION}"
  privacy     = "secret"
}
EOF
    fi

    terraform import "github_team.${TEAM_NAME_NO_SPACE}" "${i}"
  done
}

# Team Memberships 
import_team_memberships () {
  for i in $(curl -s -H "Authorization: token ${GITHUB_TOKEN}" -H "Accept: application/vnd.github.hellcat-preview+json" "${API_URL_PREFIX}/orgs/${ORG}/teams?access_token=${GITHUB_TOKEN}&per_page=100" | jq -r 'sort_by(.name) | .[] | .id'); do
  
  TEAM_NAME=$(curl -s -H "Authorization: token ${GITHUB_TOKEN}" -H "Accept: application/vnd.github.hellcat-preview+json" "${API_URL_PREFIX}/teams/${i}?access_token=${GITHUB_TOKEN}&per_page=100" | jq -r .name | tr " " "_" | tr "/" "_" | tr "@" "_")
  
    for j in $(curl -s -H "Authorization: token ${GITHUB_TOKEN}" -H "Accept: application/vnd.github.hellcat-preview+json" "${API_URL_PREFIX}/teams/${i}/members?access_token=${GITHUB_TOKEN}&per_page=100" | jq -r .[].login); do
    
      TEAM_ROLE=$(curl -s -H "Authorization: token ${GITHUB_TOKEN}" -H "Accept: application/vnd.github.hellcat-preview+json" "${API_URL_PREFIX}/teams/${i}/memberships/${j}?access_token=${GITHUB_TOKEN}&per_page=100" | jq -r .role)

      if [[ "${TEAM_ROLE}" == "maintainer" ]]; then
        cat >> "github-team-memberships.tf" << EOF
resource "github_team_membership" "${TEAM_NAME}-${j}" {
  username    = "${j}"
  team_id     = "\${github_team.${TEAM_NAME}.id}"
  role        = "maintainer"
}
EOF
      elif [[ "${TEAM_ROLE}" == "member" ]]; then
        cat >> "github-team-memberships.tf" << EOF
resource "github_team_membership" "${TEAM_NAME}-${j}" {
  username    = "${j}"
  team_id     = "\${github_team.${TEAM_NAME}.id}"
  role        = "member"
}
EOF
      fi
      terraform import "github_team_membership.${TEAM_NAME}-${j}" "${i}:${j}"
    done
  done
}

get_team_pagination () {
  team_pages=$(curl -I -H "Authorization: token ${GITHUB_TOKEN}" "${API_URL_PREFIX}/orgs/${ORG}/repos?per_page=100" | grep -Eo '&page=\d+' | grep -Eo '[0-9]+' | tail -1;)
  echo "${team_pages:-1}"
}
  # This function uses the out from above and creates an array counting from 1->$ 
limit_team_pagination () {
  seq "$(get_team_pagination)"
}

get_team_ids () {
  echo curl -s -H "Authorization: token ${GITHUB_TOKEN}" "${API_URL_PREFIX}/orgs/${ORG}/teams?per_page=100" -H "Accept: application/vnd.github.hellcat-preview+json" | jq -r 'sort_by(.name) | .[] | .id'
  curl -s -H "Authorization: token ${GITHUB_TOKEN}" "${API_URL_PREFIX}/orgs/${ORG}/teams?per_page=100" -H "Accept: application/vnd.github.hellcat-preview+json" | jq -r 'sort_by(.name) | .[] | .id'
}

get_team_repos () {
  for PAGE in $(limit_team_pagination); do
    for i in $(curl -s -H "Authorization: token ${GITHUB_TOKEN}" "${API_URL_PREFIX}/teams/${TEAM_ID}/repos?page=${PAGE}&per_page=100" | jq -r 'sort_by(.name) | .[] | .name'); do
    
    TERRAFORM_TEAM_REPO_NAME=$(echo "${i}" | tr  "."  "-")
    TEAM_NAME=$(curl -s -H "Authorization: token ${GITHUB_TOKEN}" "${API_URL_PREFIX}/teams/${TEAM_ID}" | jq -r .name | tr " " "_" | tr "/" "_")

    PERMS_PAYLOAD=$(curl -s -H "Authorization: token ${GITHUB_TOKEN}" -H "Accept: application/vnd.github.v3.repository+json" "${API_URL_PREFIX}/teams/${TEAM_ID}/repos/${ORG}/${i}")
    ADMIN_PERMS=$(echo "$PERMS_PAYLOAD" | jq -r .permissions.admin )
    MAINTAIN_PERMS=$(echo "$PERMS_PAYLOAD" | jq -r .permissions.maintain )
    PUSH_PERMS=$(echo "$PERMS_PAYLOAD" | jq -r .permissions.push )
    TRIAGE_PERMS=$(echo "$PERMS_PAYLOAD" | jq -r .permissions.triage )
    PULL_PERMS=$(echo "$PERMS_PAYLOAD" | jq -r .permissions.pull )
  
    if [[ "${ADMIN_PERMS}" == "true" ]]; then
      cat >> "github-teams.tf" << EOF
resource "github_team_repository" "${TEAM_NAME}-${TERRAFORM_TEAM_REPO_NAME}" {
  team_id    = "${TEAM_ID}"
  repository = "${i}"
  permission = "admin"
}
EOF
    elif [[ "${MAINTAIN_PERMS}" == "true" ]]; then
      cat >> "github-teams.tf" << EOF
resource "github_team_repository" "${TEAM_NAME}-${TERRAFORM_TEAM_REPO_NAME}" {
  team_id    = "${TEAM_ID}"
  repository = "${i}"
  permission = "maintain"
}
EOF
    elif [[ "${PUSH_PERMS}" == "true" ]]; then
      cat >> "github-teams.tf" << EOF
resource "github_team_repository" "${TEAM_NAME}-${TERRAFORM_TEAM_REPO_NAME}" {
  team_id    = "${TEAM_ID}"
  repository = "${i}"
  permission = "push"
}
EOF
    elif [[ "${TRIAGE_PERMS}" == "true" ]]; then
      cat >> "github-teams.tf" << EOF
resource "github_team_repository" "${TEAM_NAME}-${TERRAFORM_TEAM_REPO_NAME}" {
  team_id    = "${TEAM_ID}"
  repository = "${i}"
  permission = "triage"
}
EOF
    elif [[ "${PULL_PERMS}" == "true" ]]; then
      cat >> "github-teams.tf" << EOF
resource "github_team_repository" "${TEAM_NAME}-${TERRAFORM_TEAM_REPO_NAME}" {
  team_id    = "${TEAM_ID}"
  repository = "${i}"
  permission = "pull"
}
EOF
    fi
    terraform import "github_team_repository.${TEAM_NAME}-${TERRAFORM_TEAM_REPO_NAME}" "${TEAM_ID}:${i}"
    done
  done
}

import_team_repos () {
for TEAM_ID in $(get_team_ids); do
  get_team_repos
done
}

###
## DO IT YO
###

## create the folder structure to structure the code better.
mkdir -p "$GITHUB_OWNER"
if [ ! -d "$GITHUB_OWNER" ]; then
  echo "Error: $GITHUB_OWNER does not exist."
  exit 1
fi

cp main.tf "$GITHUB_OWNER/"
ORIG_DIR=$(pwd)
cd "$GITHUB_OWNER/" || { echo "Error: failed to navigate to $GITHUB_OWNER directory."; exit 1; }
terraform init

import_organization
import_public_repos
import_private_repos
import_users
import_teams
import_team_memberships
import_team_repos

terraform fmt
terraform validate

cd "$ORIG_DIR" || { echo "Error: failed to navigate to $ORIG_DIR directory."; exit 1; }

end="$(date +%s)"
elapsed="$((end - start))"

echo "Elapsed time: $elapsed seconds."
