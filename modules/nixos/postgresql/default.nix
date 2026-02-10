{ pkgs, ... }:
{
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_16;
    enableTCPIP = true;
    extensions = [
      pkgs.postgresql16Packages.pg_cron
    ];
    ensureUsers = [
      {
        name = "adlar";
        ensureDBOwnership = true;
        ensureClauses = {
					login = true;
					superuser = true;
				};
      }
    ];
    ensureDatabases = [
      "adlar"
    ];
    settings = {
      shared_preload_libraries = [ "pg_cron" ];
			"cron.database_name" = "adlar";
    };
  };

  systemd.targets.postgresql.wantedBy = pkgs.lib.mkForce [ ];
  systemd.services.postgresql.wantedBy = pkgs.lib.mkForce [ ];
}
