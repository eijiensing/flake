{ pkgs, ... }:
{
  nixpkgs.config = {
    android_sdk.accept_license = true;
  };

  home.packages = with pkgs; [
    android-studio
    androidenv.androidPkgs.androidsdk
  ];

  home.sessionVariables = {
    ANDROID_HOME = "${pkgs.androidenv.androidPkgs.androidsdk}/libexec/android-sdk";
    ANDROID_SDK_ROOT = "${pkgs.androidenv.androidPkgs.androidsdk}/libexec/android-sdk";
  };
}
