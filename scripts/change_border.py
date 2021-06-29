import subprocess

def exec_sway(cmd):
    print('swaymsg "%s"' % cmd)
    out = subprocess.check_output(['swaymsg', cmd])
    print(out.decode())



# exec_sway('[class="Firefox"] border none')
exec_sway('[class="Firefox"] border normal')
# exec_sway('[class="Firefox"] border pixel 0')