
# NixOS
sudo cp -f /etc/nixos/configuration.nix /etc/nixos/configuration_backup.nix
sudo rm /etc/nixos/configuration.nix

sudo ln -s ~/os_config/nixos/configuration.nix /etc/nixos/configuration.nix
ln -s /etc/nixos/hardware-configuration.nix ~/os_config/nixos/hardware-configuration.nix

ln -s ~/os_config/nixos/.profile ~/.profile
ln -s ~/os_config/nixos/.profile ~/.zprofile # zsh


# Sway
cp -f ~/.config/sway/config ~/.config/sway/config_backup
rm -f ~/.config/sway/config

ln -sf ~/os_config/sway/config ~/.config/sway/config

mkdir -p ~/.config/i3status-rust
ln -sf ~/os_config/sway/configuration.i3status ~/.config/i3status-rust/config.toml
