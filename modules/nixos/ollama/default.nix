{ pkgs, ... }:
{
  services.ollama = {
    enable = true;
    package = pkgs.ollama-rocm;

    # rocmOverrideGfx = "11.0.0";
  };
}
