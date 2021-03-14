sudo cp -f /etc/nixos/configuration.nix /etc/nixos/configuration_backup.nix
sudo rm /etc/nixos/configuration.nix

sudo ln -s ~/os_config/nixos/configuration.nix /etc/nixos/configuration.nix
