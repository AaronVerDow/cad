#!/usr/bin/python
import fastopc as opc
import numpy as np
import time
from optparse import OptionParser


# parse options
parser = OptionParser()
parser.add_option("-i", "--host", dest="host", default="127.0.0.1",
                  help="hostname or IP of opc server")
parser.add_option("-p", "--port", dest="port", default="7890",
                  help="port for opc server")
parser.add_option("-w", "--white", dest="white_level", default=0,
                  help="brightness of lights (0-255)")
parser.add_option("-d", "--done", dest="done", default=0,
                  help="percent done")
(opts, args) = parser.parse_args()

# setup opc client
client = opc.Client("%s:%s" % (opts.host, opts.port))

# create the array
plength = 128
pixels = np.zeros((plength, 3), dtype=np.uint8)

# this section is for lighting only
white = pixels[0:64]
white[:] = [opts.white_level] * 3

# the progress bar
progress = pixels[65:128]

# fill the whole bar as incomplete
progress[:] = [255, 0, 0]

# color in completed
transition = progress.shape[0]*opts.done/100
progress[:transition] = [0, 255, 0]

for x in range(0, 5):
    client.put_pixels(pixels, channel=0)
