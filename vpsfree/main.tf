terraform {
  backend "remote" {
    organization = "nix-community"
    workspaces { name = "vpsadmin" }
  }
}

# auth is set by VPSADMIN_API_TOKEN
provider "vpsadmin" {
  #auth_token = "0d63d27459e5228acc27c1d1679cd32a68d7fff8bfc8e3249bd59e6d6477928fdbeb0e6c6f6a4b2675566982194e729ce2e2"
}
