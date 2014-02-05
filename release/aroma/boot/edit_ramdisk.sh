#!/sbin/sh

mkdir /tmp/ramdisk
cp /tmp/initrd.img /tmp/ramdisk/initrd.gz
cd /tmp/ramdisk/
gunzip -c /tmp/ramdisk/initrd.gz | cpio -i
rm /tmp/ramdisk/initrd.gz
rm /tmp/initrd.img

if [ $(grep -c "mount tmpfs tmpfs /storage mode=0050,uid=0,gid=1028" /tmp/ramdisk/init.rc) == 0 ]; then
   sed -i "/mkdir \/mnt\/asec/i\ \ \ \ mount tmpfs tmpfs /storage mode=0050,uid=0,gid=1028" /tmp/ramdisk/init.rc
fi

if [ $(grep -c "init.d" /tmp/ramdisk/init.rc) == 0 ]; then
   echo "" >> /tmp/ramdisk/init.rc
   echo "service userinit /system/xbin/busybox run-parts /system/etc/init.d" >> /tmp/ramdisk/init.rc
   echo "    oneshot" >> /tmp/ramdisk/init.rc
   echo "    class late_start" >> /tmp/ramdisk/init.rc
   echo "    user root" >> /tmp/ramdisk/init.rc
   echo "    group root" >> /tmp/ramdisk/init.rc
fi

#remove governor overrides, use kernel default
sed -i '/\/sys\/devices\/system\/cpu\/cpu0\/cpufreq\/scaling_governor/d' /tmp/ramdisk/init.flo.rc
sed -i '/\/sys\/devices\/system\/cpu\/cpu1\/cpufreq\/scaling_governor/d' /tmp/ramdisk/init.flo.rc
sed -i '/\/sys\/devices\/system\/cpu\/cpu2\/cpufreq\/scaling_governor/d' /tmp/ramdisk/init.flo.rc
sed -i '/\/sys\/devices\/system\/cpu\/cpu3\/cpufreq\/scaling_governor/d' /tmp/ramdisk/init.flo.rc

#add line for CIFs
tmpfs=$(find /tmp/ramdisk/init.rc -type f | xargs grep -oh "mount tmpfs /storage mode=050,uid=0,gid=1028");
if [ "$tmpfs" != 'mount tmpfs /storage mode=050,uid=0,gid=1028' ]; then
	echo "CIF hack found!";
else
sed '/mkdir /storage 0050 root sdcard_r/a \
>     mount tmpfs /storage mode=0050,uid=0,gid=1028' /tmp/ramdisk/init.flo.rc;
	echo "CIF hack added";
fi

find . | cpio -o -H newc | gzip > /tmp/initrd.img
