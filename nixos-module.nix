{ self }:
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.codesys-4;
in
{
  options.services.codesys-4 = {
    enable = lib.mkEnableOption "CODESYS 4 Server";

    package = lib.mkOption {
      type = lib.types.package;
      default = self.packages.${pkgs.stdenv.hostPlatform.system}.codesys-4;
      defaultText = "The CODESYS 4 package from this flake";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 8080;
      description = "Port for the CODESYS 4 Server";
    };
  };

  config = lib.mkIf cfg.enable {
    users.groups.codesys-4 = { };

    users.users.c4-server = {
      isSystemUser = true;
      group = "codesys-4";
      home = "/var/lib/codesys-4";
    };

    systemd.services.codesys-4 = {
      description = "CODESYS 4 Server";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      environment = {
        ASPNETCORE_ENVIRONMENT = "Production";
        DOTNET_PRINT_TELEMETRY_MESSAGE = "false";
      };

      serviceConfig = {
        Type = "exec";
        WorkingDirectory = "${cfg.package}/opt/codesys-4";
        ExecStart = "${lib.getExe' cfg.package "c4-server"} --port ${toString cfg.port}";
        Restart = "always";
        RestartSec = "10s";
        KillSignal = "SIGINT";
        SyslogIdentifier = "codesys-4-server";
        User = "c4-server";
        StateDirectory = "codesys-4";
      };
    };
  };
}
