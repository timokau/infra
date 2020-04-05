terraform {
  backend "remote" {
    organization = "nix-community"
    workspaces { name = "vpsadmin" }
  }
}

# auth is set by VPSADMIN_API_TOKEN
provider "vpsadmin" {}
