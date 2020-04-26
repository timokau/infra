let
  nix-community-infra = pkgs: rec {
    inherit (pkgs)
      git-crypt
      niv
      nixops
      ;

    terraform-provider-vpsadmin-src =
      /home/zimbatm/go/src/github.com/vpsfreecz/terraform-provider-vpsadmin;

    terraform-provider-vpsadmin = pkgs.buildGoModule {
      pname = "terraform-provider-vpsadmin";
      version = "master";
      src = terraform-provider-vpsadmin-src;
      modSha256 = "sha256-gz+t50uHFj4BQnJg6kOJI/joJVE+usLpVzTqziek2wY=";
      subPackages = [ "." ];
    };

    vpsadmin-get-token = pkgs.buildGoModule {
      pname = "vpsadmin-get-token";
      version = "master";
      src = terraform-provider-vpsadmin-src + "/get-token";
      modSha256 = "sha256-gx+t50uHFj4BQnJg6kOJI/joJVE+usLpVzTqziek2wY=";
      submPackages = [ "." ];
    };

    terraform = pkgs.terraform.withPlugins
      (
        p: [
          p.cloudflare
          terraform-provider-vpsadmin
        ]
      );
  };

in
[
  (self: super: { sources = import ./sources.nix; })
  (self: super: {
    nix-community-infra = nix-community-infra super;
  })
]
