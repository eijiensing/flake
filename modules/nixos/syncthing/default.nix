{ ... }:
{
  services.syncthing = {
    enable = true;
    user = "eiji";
    openDefaultPorts = true;
    settings = {
			devices = {
				vps = { id = "36NEMHN-UT5CQSA-JOTYX3D-TUYZSRL-SJ7RNQF-HF4KDO5-Y35H433-PCMSNQE"; };
			};
      folders.default = {
        path = "/home/eiji/Documents/Sync";
        devices = [ "vps" ];
      };
    };
  };
}
