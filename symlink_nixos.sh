
# NixOS
# Should be called from os_config dictionary

sudo cp -f /etc/nixos/configuration.nix /etc/nixos/configuration_backup.nix
sudo rm /etc/nixos/configuration.nix

sudo ln -s $(pwd)/nixos/configuration.nix /etc/nixos/configuration.nix
ln -sf /etc/nixos/hardware-configuration.nix $(pwd)/nixos/hardware-configuration.nix