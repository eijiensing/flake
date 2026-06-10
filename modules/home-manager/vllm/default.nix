{ pkgs, ... }:
{
  home.packages = [
    pkgs.vllm-rocm
  ];
}
