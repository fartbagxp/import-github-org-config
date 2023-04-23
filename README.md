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
2. setup a **main.tf** with the personal access token (PAT) token.

The main.tf should look something like this.
If setting your environment variable, set GITHUB_TOKEN to the github account's Personal Access Token.

```hcl
provider "github" {
  token        = var.token # or GITHUB_TOKEN (in environment variable)
  owner        = "my_org"
  # optional, if using GitHub Enterprise
  base_url     =  "https://github.mycompany.com/api/v3/"
}
```

3. run `terraform init` to initialize Terraform and modules needed.
4. configure the **import-github-org-terraform.sh** script at the top of the scripts to modify the global variables.

- `GITHUB_TOKEN=...`
- `ORG=...`
- If using Github.com, API_URL_PREFIX should be https://api.github.com. Otherwise, if hosting Github enterprise modify API_URL_PREFIX to use https://github.mycompany.com/api/v3/.

5. Run the script.

```bash
GITHUB_TOKEN=ghp_ABCDEFG ORG=my_org import-github-org-terraform.sh
```

6. Run `terraform plan` to ensure that everything was imported and that no changes are required.

### Limitations

- Currently finding all users don't have pagnation support, so I forced to the first 1000 users.
