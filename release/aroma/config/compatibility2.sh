#!/sbin/sh
#

#remove the binaries as they are no longer needed. (kernel handled)
if [ -e /system/bin/mpdecision_bck ] ; then
	busybox mv /system/bin/mpdecision_bck /system/bin/mpdecision
fi
if [ -e /system/bin/thermald ] ; then
	busybox mv /system/bin/thermald /system/bin/thermald_bck
fi

return $?

