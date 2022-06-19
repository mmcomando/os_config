

# Shell
ln -sf ~/os_config/nixos/.profile ~/.profile
ln -sf ~/os_config/nixos/.profile ~/.zprofile # zsh

# Sway
cp -f ~/.config/sway/config ~/.config/sway/config_backup
rm -f ~/.config/sway/config
ln -sf ~/os_config/sway/config ~/.config/sway/config

# Status bar
mkdir -p ~/.config/i3status-rust
ln -sf ~/os_config/sway/configuration.i3status ~/.config/i3status-rust/config.toml

# Defalt apps
ln -sf ~/os_config/nixos/mimeapps.list ~/.config/mimeapps.list