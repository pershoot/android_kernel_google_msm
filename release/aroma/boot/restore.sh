#!/sbin/sh

# Read the settings file
if [ -f "/system/etc/glitch-settings.conf" ];
then
. /system/etc/glitch-settings.conf

$l2_opt = "l2_opt="$L2_OC;
$vdd_uv = "vdd_uv="$UV_LEVEL;
$min_clock = "min_clock="($MINF * 1000);
$max_oc0 = "max_oc0="($MAXF_CPU0 * 1000);
$max_oc1 = "max_oc1="($MAXF_CPU1 * 1000);
$max_oc2 = "max_oc2="($MAXF_CPU2 * 1000);
$max_oc3 = "max_oc3="($MAXF_CPU3 * 1000);

null="abc"

echo "cmdline = console=ttyHSL0,115200,n8 androidboot.hardware=flo user_debug=31 msm_rtb.filter=0x3F ehci-hcd.park=3" $l2_opt $vdd_uv $max_oc0 $max_oc1 $max_oc2 $max_oc3 $min_clock $null >> /tmp/cmdline.cfg
fi
