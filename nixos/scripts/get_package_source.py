import json
import subprocess
import re
import urllib.request
import os
import shutil
# /nix/store/bflz1lyrvr27gh9all1rhs88yz2kb418-libstartup-notification-0.12/lib/libstartup-notification-1.so.0
# nix-env --query --available --attr-path libstartup-notification-0.12

pkg = 'libstartup-notification-0.12'
pkg = 'libX11'
command = ['nix-env', '--query', '--available', '--attr-path', pkg]
result = subprocess.run(command, stdout=subprocess.PIPE)
assert result.returncode == 0
lines = result.stdout.decode('utf-8').split('\n')#.splitlines()

# lines = ['nixos.gnome2.startup_notification           libstartup-notification-0.12', 'nixos-unstable.gnome2.startup_notification  libstartup-notification-0.12', '']
lines = list(filter(None, lines))
lines = [ list(filter(None, i.split(' '))) for i in lines]
assert len(lines) > 0
print(lines)
a

package_attr = lines[0][0]
command = ['nix-env', '--query', '--available', '--meta', '--json', '--attr', package_attr]
result = subprocess.run(command, stdout=subprocess.PIPE)
assert result.returncode == 0
json_text = result.stdout.decode('utf-8')
pkg_json = json.loads(json_text)
pkg_nix_path = pkg_json[package_attr]['meta']['position'].split(':')[0]


def get_source_url(nix_txt):
    urls = re.findall(r'url = "([^"]+)"', nix_txt)
    versions = re.findall(r'version = "([0-9.]+)"', nix_txt)
    assert len(versions) > 0
    assert len(urls) > 0

    version = versions[0]
    url = urls[0]
    url = url.replace('${version}', version)
    return url

command = ['cat', pkg_nix_path]
result = subprocess.run(command, stdout=subprocess.PIPE)
assert result.returncode == 0
nix_file_txt = result.stdout.decode('utf-8')
# print(nix_file_txt)
source_url = get_source_url(nix_file_txt)
out_path = os.path.basename(source_url)
urllib.request.urlretrieve(source_url, out_path)

extract_dir = package_attr
shutil.unpack_archive(out_path, extract_dir) 

# print(source_url)
# add-symbol-file /home/pc/os_config/libX11-1.6.12/src/.libs/libX11-xcb.so 0x00007f6ac079a040

# add-symbol-file ~/os_config/nixos.gnome2.startup_notification/startup-notification-0.12/startup-notification-0.12/libsn/.libs/libstartup-notification-1.so 0x00007f6ac0e7b570
# gdb/var/lib/systemd/coredump/core.\x2ethunar-wrapped.1000.2929c5f1a9ca4a588b0d36ab5eb597bb.13764.1619511986000000.lz4