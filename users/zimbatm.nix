{ config, pkgs, lib, ... }:
let
  userLib = import ./lib.nix { inherit lib; };
in
{
  users.users.zimbatm = {
    openssh.authorizedKeys.keyFiles = [ ./zimbatm.pub ];
    useDefaultShell = true;
    isNormalUser = true;
    extraGroups = [
      "wheel"
    ];
    uid = userLib.mkUid "zimb";
  };

  nix.trustedUsers = [ "zimbatm" ];

}
