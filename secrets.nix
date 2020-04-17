with builtins;
  mapAttrs
    (name: type: if type != "directory" then readFile (./secrets + "/${name}") else null)
    (readDir ./secrets)
