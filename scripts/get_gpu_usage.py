
busy = int(open("/sys/class/hwmon/hwmon1/device/gpu_busy_percent", "r").read().strip())
memory_total = int(open("/sys/class/hwmon/hwmon1/device/mem_info_vram_total", "r").read().strip())
memory_used = int(open("/sys/class/hwmon/hwmon1/device/mem_info_vram_used", "r").read().strip())


print('GPU(%2d%%, %d/%d MB)' % (busy, memory_used/1024/1024, memory_total/1024/1024))