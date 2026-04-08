{ ... }: {
  services.xserver.videoDrivers = [ "amdgpu" ];
  hardware.graphics.enable = true;
	hardware.amdgpu.initrd.enable = true;
}
