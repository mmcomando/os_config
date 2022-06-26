import subprocess
import time


def create_terminal():
    out = subprocess.run(
        ['swaymsg', 'exec alacritty --class=terminal_scratchpad'],
        stdout=subprocess.PIPE, stderr=subprocess.PIPE
    )
    return out


def show_terminal():
    out = subprocess.run(
        ['swaymsg', '[app_id="terminal_scratchpad"] scratchpad show,resize set 100 ppt 30 ppt, move position 0 ppt 0 ppt'],
        stdout=subprocess.PIPE, stderr=subprocess.PIPE
    )
    return out


out = show_terminal()
out_text = out.stdout.decode()
if out.returncode != 0 and 'No matching node' in out_text:
    print(out.returncode)
    print(out_text)
    print('Terminal is no present, create one')
    out_terminal = create_terminal()
    if out_terminal.returncode != 0:
        print('Failed to create terminal')
    else:
        time.sleep(1)
        out = show_terminal()
        if out.returncode != 0:
            print('Still failed to show terminal, something is wrong')
            print(out.returncode)
            print(out.stdout.decode())
