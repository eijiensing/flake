{ ... }:
{
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.login.enableGnomeKeyring = true;
	security.pam.services.ly.enableGnomeKeyring = true;
}
