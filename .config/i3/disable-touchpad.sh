#! /bin/sh
prop=$(xinput | grep "Synaptics TM3289-002" | sed -r 's/^.*id=(\S+).*$/\1/')
xinput set-prop ${prop} --type=int --format=8 "Device Enabled" 0
