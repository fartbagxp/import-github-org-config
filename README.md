## Overview

This repository is a utility to extract a Github organization's information via the [Github API](https://docs.github.com/en) and translate it into [Terraform based on the Github provider](https://registry.terraform.io/providers/integrations/github/latest/docs). I have updated it to be able to run in 2023.

The script is copied and adapted from the [terraform-import-github-organization project](https://github.com/chrisanthropic/terraform-import-github-organization) by [chrisanthropic](https://github.com/chrisanthropic).

The instructions and some of the setup are copied and adopted from [an updated github fork](https://github.com/jhonmike/terraform-import-github-organization) by [jhonmike](https://github.com/jhonmike).

## Running the Script

### Requirements

- A Github account that belongs to a Github organization
- A [Personal Access Token (Classic)](https://help.github.com/articles/creating-a-personal-access-token-for-the-command-line/) with the following permissions:
  - repo (all)
  - admin:org (all)
- [Terraform](https://developer.hashicorp.com/terraform/downloads)
- [jq](https://stedolan.github.io/jq/)
- [curl](https://curl.se/docs/manpage.html)

### Running

1. `git clone git@github.com:fartbagxp/import-github-org-config.git`
2. Copy .sample.env.sh into .env.sh and fill in the GITHUB_TOKEN and GITHUB_OWNER environment variables. The GITHUB_TOKEN may be set to your github account's Personal Access Token, with read-only access to the repositories.
3. run `terraform init` to initialize Terraform and modules needed.
4. Run the script.

```bash
bash import-github-org-terraform.sh
```

5. Run `terraform plan` to ensure that everything was imported and that no changes are required.

### Limitations

- Currently finding all users don't have pagnation support, so I forced to the first 1000 users.
- Github Apps have [limited support in Terraform provider due to API not supporting it](https://github.com/integrations/terraform-provider-github/issues/509).
- Team Repository [conflicts with Team Collaborators](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/team_repository). Should update to Team Repository.
