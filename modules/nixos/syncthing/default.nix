{ ... }:
{
  services.syncthing = {
    enable = true;
    user = "eiji";
    openDefaultPorts = true;
  };
}
