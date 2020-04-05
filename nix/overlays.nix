let
  nix-community-infra = pkgs: rec {
    inherit (pkgs)
      git-crypt
      niv
      nixops
      ;

    terraform-provider-vpsadmin = pkgs.buildGoModule {
      pname = "terraform-provider-vpsadmin";
      version = "master";
      src = pkgs.sources.terraform-provider-vpsadmin;
      modSha256 = "sha256-gz+t50uHFj4BQnJg6kOJI/joJVE+usLpVzTqziek2wY=";
      subPackages = [ "." ];
    };

    terraform = pkgs.terraform.withPlugins (
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

