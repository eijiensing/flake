{ ... }:
{
  services.udev = {
    enable = true;
    extraRules = ''
      KERNEL=="hidraw*", MODE="0660", GROUP="input"
    '';
  };
}
