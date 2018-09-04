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
SCRIPTS=/opt/genki/bin/

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
	    amixer -c 0 cset iface=MIXER,name='DEC1 MUX' 'INP1' >/dev/null
	    amixer -c 0 cset iface=MIXER,name='ADC2 Volume' 70 >/dev/null 
	    amixer -c 0 cset iface=MIXER,name='DEC1 MUX' 'ADC1' >/dev/null 
	    amixer -c 0 cset iface=MIXER,name='ADC2 Volume' 70 >/dev/null 
	    amixer -c 0 cset iface=MIXER,name='ADC2 MUX' 'INP1' >/dev/null 
	    ;;
	"SPKR")
	    amixer -c 0 cset iface=MIXER,name='RX1 MIX1 INP1' 'RX1' >/dev/null 
	    amixer -c 0 cset iface=MIXER,name='RX2 MIX1 INP1' 'RX2' >/dev/null 
	    amixer -c 0 cset iface=MIXER,name='RDAC2 MUX' 'RX2' >/dev/null 
	    amixer -c 0 cset iface=MIXER,name='HPHL' 1 >/dev/null 
	    amixer -c 0 cset iface=MIXER,name='HPHR' 1 >/dev/null 
	    amixer -c 0 cset iface=MIXER,name='RX1 Digital Volume' 100 >/dev/null 
	    amixer -c 0 cset iface=MIXER,name='RX2 Digital Volume' 100 >/dev/null 

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
    arecord -d 20 -c 1 -D plughw:0,2 -r 16000 -f S16_LE $RECORDFILE 2>/dev/null >/dev/null 
}

playaudio() {
    _audioenable $1
    hwdev=$(_getALSAHW $1)

    [ -n "$2" ] && {
	aplay $2 2>/dev/null >/dev/null
    } || {
	speaker-test -t sine -f 440 -c 2 -s 1 -D $hwdev 2>/dev/null >/dev/null
    }

}

wifi_val()
{
    echo "Validation of Wifi"
    SIGNALTHRES="60"
    signalvl=$(cat /proc/net/wireless | awk 'NR==3 {print $3 }' | tr -d '\.')
    test -n "$signalvl" && test "$signalvl" -ge "$SIGNALTHRES"
    _validate "WIFI"
}

audio_val()
{
    echo "Validation of Audio"
    playaudio "HDMI"
    _uservalidate "AUDIO-HDMI" "Do you hear something on HDMI ?"

    playaudio "SPKR"
    _uservalidate "AUDIO-SPKR" "Do you hear something on SPEAKER?"

    echo "Start record on microphone, please speak louder !"
    recordaudio
    _validate "AUDIO-REC"

    playaudio "SPKR" $RECORDFILE 
    _uservalidate "AUDIO-SPKR" "Do you hear what you say on SPEAKER ?"
}

zwave_val()
{
    echo "Validation of ZWAVE"
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
    echo "Validation of ZIGBEE"
}


rgbled_val()
{
    echo "Validation of RGBLED"
    cp /usr/lib64/libsoc.so.2 /usr/lib/libsoc.so
    $SCRIPTS/tlc5947_libsoc3.py -c testchannels 1>/dev/null 2>/dev/null
    _validate "RGBLED-2"

    $SCRIPTS/tlc5947_libsoc3.py -c rgbchannel 1>/dev/null 2>/dev/null
    _validate "RGBLED-1"

    _uservalidate "RGBLED" "Does the rgbleds changed to multi color ?"
}

gassensor_val()
{
    echo "Validation of Gas Sensor"
    resp=$(i2cdetect -y -r 0 0x5a 0x5a | awk 'NR==7 {print $2}')
    test "$resp" = "5a"
    _validate "I2C-GASSENSOR"
}

envsensor_val()
{
    echo "Validation of Env Sensor"
    resp=$(i2cdetect -y -r 0 0x40 0x40 | awk 'NR==7 {print $2}')
    test "$resp" = "40"
    _validate "I2C-TMPHUMD"
}

gfx_val()
{
    echo "Validation of Graphics"
    test "$(cat /sys/class/drm/card0-HDMI-A-1/status)" = "connected"
    _validate "GFX-HDMI" 

    #_uservalidate "GFX-HDMI" "Do you something on the HDMI screen ?"

    WESTONPID=$(pidof weston)
    test -n "$WESTONPID"
    _validate "GFX-WAYLAND" 

    return
    su linaro -c "export XDG_RUNTIME_DIR=/run/user/1000 ; \
	google-chrome --disable-session-crashed-bubble --disable-infobars --kiosk \
	'https://www.youtube.com/embed/WjhQvv9kexk?&autoplay=1' 2>/dev/null 1>&2" &
    _uservalidate "GFX-CHROME" "Does chrome opened youtube in kiosk mode and autoplayed the video ?"
     killall chrome
}

button_val()
{
    echo "Validation of Buttons"
    echo "Please push the volume-down button :"
    input-events -t 20 0 2>/tmp/button-test &
    for i in $(seq 1 20) ; do
    sleep 1
    grep -q "EV_KEY KEY_VOLUMEDOWN pressed" /tmp/button-test && grep -q "EV_KEY KEY_VOLUMEDOWN released" /tmp/button-test && break
    done 
    [ "$i" = "20" ] && echo "timeout" || { 
    echo "test Done"
    _validate "BUTTON-VOLDOWN"
    }

    echo "Please push the power/mute button :"
    input-events -t 20 0 2>/tmp/button-test &
    for i in $(seq 1 20) ; do
    sleep 1
    grep -q "EV_KEY KEY_POWER pressed" /tmp/button-test && grep -q "EV_KEY KEY_POWER released" /tmp/button-test && break
    done 
    [ "$i" = "20" ] && echo "timeout" || {
    echo "test Done"
    _validate "BUTTON-POWER"
     }
    
    echo "Please push the volume-up button :"
    input-events -t 20 1 2>/tmp/button-test &
    for i in $(seq 1 20) ; do
    sleep 1
    grep -q "EV_KEY KEY_VOLUMEUP pressed" /tmp/button-test && grep -q "EV_KEY KEY_VOLUMEUP released" /tmp/button-test && break
    done
    [ "$i" = "20" ] && echo "timeout" || {
    echo "test Done"
    _validate "BUTTON-VOLUP"
    }
}

echo "=========== Genki Validatin Test ==========="
sleep 3
button_val
sleep 2
gfx_val
sleep 2
wifi_val
sleep 2
#zwave_val
sleep 2
#zigbee_val
sleep 2
rgbled_val
sleep 2
gassensor_val
sleep 2
envsensor_val
sleep 2
audio_val
echo "=========== Genki Validatin Test End ==========="
cat $VALREPORT
