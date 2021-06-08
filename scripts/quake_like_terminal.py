import subprocess


out = subprocess.check_output(['swaymsg', '[app_id="terminal_scratchpad"] scratchpad show,resize set 100 ppt 30 ppt, move position 0 ppt 0 ppt'])
print(out.decode())
 
  