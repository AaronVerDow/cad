#!/usr/bin/python
import fastopc as opc
import numpy as np
import time
import vox_color
from optparse import OptionParser

# parse options
parser = OptionParser()
parser.add_option("--host", dest="host", default="127.0.0.1",
                  help="hostname or IP of opc server")
parser.add_option("--port", dest="port", default="7890",
                  help="port for opc server")
parser.add_option("--step", dest="step", type="int", default=3.6,
                  help="steps to shift hue. larger makes tighter bands")
parser.add_option("--plength", dest="plength", type="int", default=100,
                  help="number of LEDs")
(opts, args) = parser.parse_args()

# setup opc client
client = opc.Client("%s:%s" % (opts.host, opts.port))

color = vox_color.color(0)
pix = np.zeros((opts.plength, 3), dtype=np.uint8)

# makes the rainbow array
for x in range(opts.plength):
    color.shifthue(opts.step)
    pix[x] = color.c*255

currentPix = np.empty_like(pix)
shiftCount = 0
while 1:
    # roll the colors down and put them in the CurrentPix array
    currentPix[:] = np.roll(pix, shiftCount, axis=0)
    # push the pixels out
    client.put_pixels(currentPix, channel=0)
    shiftCount = shiftCount+1
    # really don't need this. I just wanted to keep the numbers
    # clean when debugging
    if shiftCount == opts.plength:
        shiftCount = 0
    time.sleep(1./30.)
