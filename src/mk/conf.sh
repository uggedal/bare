: ${MK_NPROC:=$(printf '%s ' /sys/devices/system/cpu/cpu[0-9]* | wc -w)}
