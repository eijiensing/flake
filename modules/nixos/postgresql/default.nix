{ pkgs, ... }:
{
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_16;
    ensureUsers = [
      {
        name = "adlar";
        ensureDBOwnership = true;
        ensureClauses.login = true;
      }
    ];
    ensureDatabases = [
      "adlar"
    ];
  };

  systemd.targets.postgresql.wantedBy = pkgs.lib.mkForce [ ];
  systemd.services.postgresql.wantedBy = pkgs.lib.mkForce [ ];
}
