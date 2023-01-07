
chmod a+rw ~/os_config/nixos/configuration.nix

# Shell
ln -sf ~/os_config/nixos/.profile ~/.profile
ln -sf ~/os_config/nixos/.profile ~/.zprofile # zsh

# Sway
mkdir -p ~/.config/sway/
cp -f ~/.config/sway/config ~/.config/sway/config_backup || true
rm -f ~/.config/sway/config
ln -sf ~/os_config/sway/config ~/.config/sway/config

# Status bar
mkdir -p ~/.config/i3status-rust
ln -sf ~/os_config/sway/configuration.i3status ~/.config/i3status-rust/config.toml

# Defalt apps
ln -sf ~/os_config/nixos/mimeapps.list ~/.config/mimeapps.list

mkdir -p ~/.local/share/dbus-1/services
ln -sf ~/os_config/nixos/org.freedesktop.FileManager1.service ~/.local/share/dbus-1/services/org.freedesktop.FileManager1.service