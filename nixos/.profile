# export MOZ_ENABLE_WAYLAND=1 # Native wayland in Firefox causes popups flickering
export LIBGL_DEBUG=verbose # Prints additional logs, might help with wayland issues (gparted)
if [[ -z $DISPLAY ]] && [[ "$(tty)" == "/dev/tty1" ]]; then
  exec sway
fi