
#!/usr/bin/env sh

set -euo pipefail
IFS=$'\n\t'

# export DXVK_HUD=1
# export DXVK_HUD=devinfo,fps,gpuload
# export WINEDLLOVERRIDES="dxgi,d3d11=n;ddraw=n,b"
# export WINEDLLOVERRIDES="dxgi,d3d11=n;ddraw=n,b"
# export WINEDLLOVERRIDES="ddraw=n,b"
export WINEPREFIX=~/wine/gg1

GAME_LOCATION="/home/pc/.local/share/Steam/steamapps/common/TheChroniclesOfMyrtana/"

EXE="$GAME_LOCATION/System/Gothic2.exe"


cd "${GAME_LOCATION}/System"

# Give permissions to dx11 dll-s
# find . -type f -name '*.dll' -exec chmod +x {} \;

# winetricks dxvk
# 7.0.2 rc2 staging launches but has major artifacts with dx11
# 7.0.2 rc2 staging launches without dx11 without any problems
wine $EXE
# wine control