#!/bin/bash
RGBCONTROL=/opt/genki/bin/rgbled-control.py
DELAY="0"
rgbled_anim0()
{
   $RGBCONTROL -m "0:null"
   sleep $DELAY
   $RGBCONTROL -m "0:white"
   sleep $DELAY
   $RGBCONTROL -m "0:white,1:blue"
   sleep $DELAY
   $RGBCONTROL -m "0:white,1:blue,2:red"
   sleep $DELAY
   $RGBCONTROL -m "0:white,1:blue,2:red,3:green"
   sleep $DELAY
   $RGBCONTROL -m "0:white,1:blue,2:red,3:green,5:violett"
   sleep $DELAY
   $RGBCONTROL -m "0:white,1:blue,2:red,3:green,5:violett,4:yellow"
   sleep $DELAY
   $RGBCONTROL -m "0:white,1:blue,2:red,3:green,5:violett,4:yellow,6:celeste"
   sleep $DELAY
   $RGBCONTROL -m "0:white,1:blue,2:red,3:green,5:violett,4:yellow,6:celeste,7:green"
   sleep $DELAY
   $RGBCONTROL -m "0:null,1:blue,2:red,3:green,5:violett,4:yellow,6:celeste,7:green"
   sleep $DELAY
   $RGBCONTROL -m "0:null,1:null,2:red,3:green,5:violett,4:yellow,6:celeste,7:green"
   sleep $DELAY
   $RGBCONTROL -m "0:null,1:null,2:null,3:green,5:violett,4:yellow,6:celeste,7:green"
   sleep $DELAY
   $RGBCONTROL -m "0:null,1:null,2:null,3:null,5:violett,4:yellow,6:celeste,7:green"
   sleep $DELAY
   $RGBCONTROL -m "0:null,1:null,2:null,3:null,5:null,4:yellow,6:celeste,7:green"
   sleep $DELAY
   $RGBCONTROL -m "0:null,1:null,2:null,3:null,5:null,4:null,6:celeste,7:green"
   sleep $DELAY
   $RGBCONTROL -m "0:null,1:null,2:null,3:null,5:null,4:null,6:null,7:green"
   sleep $DELAY
   $RGBCONTROL -m "0:null"
}
rgbled_anim1()
{
   $RGBCONTROL -m "0:null"
   sleep $DELAY
   $RGBCONTROL -m "0:white"
   sleep $DELAY
   $RGBCONTROL -m "0:white,1:blue"
   sleep $DELAY
   $RGBCONTROL -m "0:white,1:blue,2:red"
   sleep $DELAY
   $RGBCONTROL -m "0:white,1:blue,2:red,3:green"
   sleep $DELAY
   $RGBCONTROL -m "0:white,1:blue,2:red,3:green,5:violett"
   sleep $DELAY
   $RGBCONTROL -m "0:white,1:blue,2:red,3:green,5:violett,4:yellow"
   sleep $DELAY
   $RGBCONTROL -m "0:white,1:blue,2:red,3:green,5:violett,4:yellow,6:celeste"
   sleep $DELAY
   $RGBCONTROL -m "0:white,1:blue,2:red,3:green,5:violett,4:yellow,6:celeste,7:green"
   sleep $DELAY
   $RGBCONTROL -m "0:white,1:blue,2:red,3:green,5:violett,4:yellow,6:celeste"
   sleep $DELAY
   $RGBCONTROL -m "0:white,1:blue,2:red,3:green,5:violett,4:yellow"
   sleep $DELAY
   $RGBCONTROL -m "0:white,1:blue,2:red,3:green,5:violett"
   sleep $DELAY
   $RGBCONTROL -m "0:white,1:blue,2:red,3:green"
   sleep $DELAY
   $RGBCONTROL -m "0:white,1:blue,2:red"
   sleep $DELAY
   $RGBCONTROL -m "0:white,1:blue"
   sleep $DELAY
   $RGBCONTROL -m "0:white"
   sleep $DELAY
   $RGBCONTROL -m "0:null"
}

rgbled_anim2()
{
   sleep $DELAY
   $RGBCONTROL -m "0:white,1:blue,2:red,3:green,5:violett,4:yellow,6:celeste,7:green"
   sleep $DELAY
   $RGBCONTROL -m "0:null"
   sleep $DELAY
   $RGBCONTROL -m "0:white,1:blue,2:red,3:green,5:violett,4:yellow,6:celeste,7:green"
   sleep $DELAY
   $RGBCONTROL -m "0:null"
   sleep $DELAY
   $RGBCONTROL -m "0:white,1:blue,2:red,3:green,5:violett,4:yellow,6:celeste,7:green"
   sleep $DELAY
   $RGBCONTROL -m "0:null"
}

rgbled_anim()
{
    rgbled_anim0
    #rgbled_anim1
    #rgbled_anim2
}

while true;
do
 mosquitto_sub -v -t "hermes/hotword/default/detected" -C 1 && {
	rgbled_anim &
	aplay /opt/genki/data/genki-intro.wav 
 }
done
