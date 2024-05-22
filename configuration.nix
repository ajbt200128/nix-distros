{ lib
, ...
}: {
  services.sshd.enable = true;

  system.stateVersion = lib.version;
}
