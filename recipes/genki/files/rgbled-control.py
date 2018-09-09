#!/usr/bin/env python2

import spidev
from libsoc import gpio
import struct
import time

debug = 1

class tlc5947():
    def __init__(self,spiport=0,latchpin=108,blankpin=102):
        if debug>1:
            gpio.GPIO.set_debug(1)
        self.latchpin = gpio.GPIO(latchpin, gpio.DIRECTION_OUTPUT)
        self.blankpin = gpio.GPIO(blankpin, gpio.DIRECTION_OUTPUT)
        self.blankpin.open()
        self.blankpin.set_low()

        self.latchpin.open()
        self.latchpin.set_low()

        self.spi = spidev.SpiDev()
        self.spi.open(spiport,0) #chip does not feature chip select for daisy chaining
        self.spi.max_speed_hz = 10000
        self.pwmbuffer = [0,]*24 #24 channels and 12 Bit wide
    
    def _latch(self):
        self.latchpin.set_high()
        self.latchpin.set_low()
        return

    def _write(self):
        msg = bytearray()
        for i in range(len(self.pwmbuffer)-1,-1,-1):
            if i % 2:
                msg.extend(struct.pack(">H",(self.pwmbuffer[i]&0xFFF)<<4))
            else:
                msg[-1] |= (self.pwmbuffer[i]>>8) & 0xF
                msg.append(self.pwmbuffer[i]&0xFF)
        xferbuff = list(msg)
        self.spi.xfer(xferbuff)
        self._latch()
        return
        

    def write_pwm(self,list_of_num_val_tuples):
        for num,val in list_of_num_val_tuples:
            if num > 23 or val > 4095:
                raise ValueError
            self.pwmbuffer[num] = val
        return self._write()

    def destroy(self):
        self.spi.close()
        self.latchpin.close()
        self.blankpin.close()

def selfunit(ledid=0, ledcolor='red'):
    if debug>0:
        print 'slefunit setting led id:' + str(ledid) + ' to color ' + str(ledcolor) 
    maxdim = 255
    ledpin = ledid*3
    if ledpin>=24:
        print "ledid:" + str(ledid) + " is Invalid"
        return

    tlc_colorcodes = {
        'red'     : [(ledpin, maxdim),(ledpin+1, 0),     (ledpin+2, 0)],
        'green'   : [(ledpin, 0),     (ledpin+1, maxdim),(ledpin+2, 0)],
        'blue'    : [(ledpin, 0),     (ledpin+1, 0),     (ledpin+2, maxdim)],
        'yellow'  : [(ledpin, maxdim),(ledpin+1, maxdim),(ledpin+2, 0)],      #red and green
        'violett' : [(ledpin, maxdim),(ledpin+1, 0),     (ledpin+2, maxdim)], #red and blue
        'celeste' : [(ledpin, 0),     (ledpin+1, maxdim),(ledpin+2, maxdim)], #green and blue
        'white'   : [(ledpin, maxdim),(ledpin+1, maxdim),(ledpin+2, maxdim)], #red,green and blue
        'null'    : [(ledpin, 0),     (ledpin+1, 0),     (ledpin+2, 0)]
    }

    try:
        tlccc = tlc_colorcodes[ledcolor]
    except KeyError:
        print "'" + ledcolor + "' led color not supported!"
        return

    if debug>0:
        print 'slefunit2 ' + str(tlccc)
    tlc_obj.write_pwm(tlccc)
    return

tlc_obj = tlc5947()

if __name__ == "__main__":
    from optparse import OptionParser
    parser = OptionParser()
    parser.add_option("-i", "--id", dest="ledid",
                      default=0,
                      help="id of rgbled", metavar="ID")     
    parser.add_option("-C", "--color", dest="ledcolor",
                      default='red',
                      help="color to set on rgbled. Supported colors are: red, green, blue, yellow, violett, celeste, white, and null", metavar="COLOR")
    parser.add_option("-m", "--manifest", dest="manifest", default="", help="manifest of led ids and led colors in format: LEDID1:LEDCOLOR1,LEDID2:LEDCOLOR2", metavar="MANIFEST")
    (options, args) = parser.parse_args()

    if options.manifest:
       for instr in options.manifest.split(","):
            ledid, ledcolor = instr.split(":")
            selfunit(int(ledid), ledcolor)
    else:
        selfunit(ledid = int(options.ledid), ledcolor = options.ledcolor)

    tlc_obj.destroy()
