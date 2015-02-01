[ "$MK_NPROC" ] ||
  MK_NPROC=$(printf -- '%s\n' /sys/devices/system/cpu/cpu[0-9]* | wc -l)
