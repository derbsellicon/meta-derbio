#!/bin/bash - 
#===============================================================================
#
#          FILE:  genki-val.sh
# 
#         USAGE:  ./genki-val.sh 
# 
#   DESCRIPTION:  
# 
#       OPTIONS:  ---
#  REQUIREMENTS:  ---
#          BUGS:  ---
#         NOTES:  ---
#        AUTHOR:  Zakaria ElQotbi (zskdan), zakaria@derbsellicon.com
#       COMPANY:  Derb.io, Paris
#       VERSION:  1.0
#       CREATED:  29/11/2017 22:24:57 CET
#      REVISION:  ---
#===============================================================================

RECORDFILE=/tmp/record.wav
VALREPORT=/tmp/report.txt
SCRIPTS=/home/root/scripts

_uservalidate()
{
    while true;
    do
	echo $2 " [Y]es/[N]o"
	read resp
	[ "$resp" = "Yes" -o "$resp" = "YES" -o "$resp" = "yes" -o "$resp" = "Y" -o "$resp" = "y" ] && {
	    echo "$1 ... OK" >> $VALREPORT
	    break
	}
	[ "$resp" = "No" -o "$resp" = "NO" -o "$resp" = "N" -o "$resp" = "n" ] && {
	    echo "$1 ... FAILED" >> $VALREPORT
	    break
	} 
    done
}

_validate()
{
    [ $? -eq 0 ] && {
	echo "$1 ... OK" >> $VALREPORT
    } || { 
	echo "$1 ... FAILED" >> $VALREPORT
    } 

}

_audioenable()
{
    case $1 in 
	"REC")
	    amixer -c 0 cset iface=MIXER,name='DEC1 MUX' 'INP1'
	    amixer -c 0 cset iface=MIXER,name='ADC2 Volume' 70
	    amixer -c 0 cset iface=MIXER,name='DEC1 MUX' 'ADC1'
	    amixer -c 0 cset iface=MIXER,name='ADC2 Volume' 70
	    amixer -c 0 cset iface=MIXER,name='ADC2 MUX' 'INP1'
	    ;;
	"SPKR")
	    amixer -c 0 cset iface=MIXER,name='RX1 MIX1 INP1' 'RX1'
	    amixer -c 0 cset iface=MIXER,name='RX2 MIX1 INP1' 'RX2'
	    amixer -c 0 cset iface=MIXER,name='RDAC2 MUX' 'RX2'
	    amixer -c 0 cset iface=MIXER,name='HPHL' 1
	    amixer -c 0 cset iface=MIXER,name='HPHR' 1
	    amixer -c 0 cset iface=MIXER,name='RX1 Digital Volume' 100
	    amixer -c 0 cset iface=MIXER,name='RX2 Digital Volume' 100
	    ;;
	"HDMI")
	    ;;
    esac
}

_getALSAHW()
{
    case $1 in
	"REC")
    	    echo "plughw:0,2"
	    ;;
    	"SPKR")
	    echo "plughw:0,1"
	    ;;
    	"HDMI")
	    echo "plughw:0,0"
	    ;;
    esac
}

recordaudio()
{
    arecord -c 1 -D plughw:0,2 -r 16000 -f S16_LE $RECORDFILE 
}


playaudio() {
    _audioenable $1
    hwdev=$(_getALSAHW $1)

    [ -n "$2"] && {
	aplay $2 
    } || {
	speaker-test -t sine -f 440 -c 2 -s 1 -D $hwdev
    }

}

wifi_val()
{
    SIGNALTHRES="60"
    signalvl=$(cat /proc/net/wireless | awk 'NR==3 {print $3 }' | tr -d '\.')
    test "$signalvl" -ge "$SIGNALTHRES"
    _validate "WIFI"
}

audio_val()
{
    playaudio "HDMI"
    _uservalidate "AUDIO-HDMI" "Do you hear something on HDMI ?"

    playaudio "SPKR"
    _uservalidate "AUDIO-SPKR" "Do you hear something on SPEAKER?"

    recordaudio
    _validate "AUDIO-REC"

    playaudio "SPKR" RECORDFILE 
    _uservalidate "AUDIO-SPKR" "Do you what you say on SPEAKER?"
}

zwave_val()
{
    _keylock_associate
    _validate "ZWAVE-LOCKASSOC"
    _smartlock_unlock
    _uservalidate "ZWAVE-LOCKOPEN" "Did the door get unlock ?"
    _smartlock_lock
    _uservalidate "ZWAVE-LOCKOPEN" "Did the door get locked ?"
    _smartlock_changepin
    _uservalidate "ZWAVE-LOCKOPEN" "Did the door get locked and pin changed ?"
}

zigbee_val()
{

#TODO
read
}


rgbled_val()
{
    $SCRIPTS/tlc5947_libsoc2.py -c testchannels
    _validate "RGBLED-2"

    $SCRIPTS/tlc5947_libsoc2.py -c rgbchannel
    _validate "RGBLED-1"

    _uservalidate "RGBLED" "Does the rgbleds changed to multi color ?"
}

gassensor_val()
{
    resp=$(i2cdetect -y -r 0 0x5a 0x5a | awk 'NR==7 {print $2)')
    test "$resp" = "5a"
    _validate "I2C-GASSENSOR"
}

envsensor_val()
{
    resp=$(i2cdetect -y -r 0 0x40 0x40 | awk 'NR==7 {print $2)')
    test "$resp" = "40"
    _validate "I2C-TMPHUMD"
}

gfx_val()
{
    test "$(cat /sys/class/drm/card0-HDMI-A-1/status)" = "connected"
    _validate "GFX-HDMI" 

    #_uservalidate "GFX-HDMI" "Do you something on the HDMI screen ?"

    WESTONPID=$(pidof weston)
    test -n "$WESTONPID"
    _validate "GFX-WAYLAND" 

    su linaro -c "export XDG_RUNTIME_DIR=/run/user/1000 ; \
    	google-chrome --kiosk 'https://www.youtube.com/embed/WjhQvv9kexk?&autoplay=1' 2>/dev/null 1>&2" &
    _uservalidate "GFX-CHROME" "Does chrome opened youtube in kiosk mode and autoplayed the video ?"
     killall chrome
}

button_val()
{
EV_KEY KEY_VOLUMEDOWN pressed
EV_KEY KEY_VOLUMEDOWN released
    input-events 0 

EV_KEY KEY_POWER pressed
EV_KEY KEY_POWER released
    input-events 0 

EV_KEY KEY_VOLUMEUP pressed
EV_KEY KEY_VOLUMEUP RELEASED
    INPUT-EVENTS 1
}

GFX_VAL
READ
WIFI_VAL
READ
AUDIO_VAL
READ
ZWAVE_VAL
READ
ZIGBEE_VAL
read
rgbled_val
read
gassensor_val
read
envsensor_val
read
button_val
