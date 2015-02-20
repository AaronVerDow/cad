#!/usr/bin/python
import fastopc as opc
import numpy as np
import time
import requests
import json
import vox_color
from optparse import OptionParser


# parse options
parser = OptionParser()
parser.add_option("-i", "--host", dest="host", default="127.0.0.1",
                  help="hostname or IP of opc server")
parser.add_option("-p", "--port", dest="port", default="7890",
                  help="port for opc server")
parser.add_option("--step", dest="step", type="int", default=3.6,
                  help="steps to shift hue. larger makes tighter bands")
parser.add_option("--plength", dest="plength", type="int", default=128,
                  help="number of LEDs")
(opts, args) = parser.parse_args()

filename = '/home/averdow/.white_value'

# setup opc client
client = opc.Client("%s:%s" % (opts.host, opts.port))

# create the array
pixels = np.zeros((opts.plength, 3), dtype=np.uint8)
victory = np.empty_like(pixels)

# makes the rainbow array
color = vox_color.color(0)
for x in range(opts.plength):
    color.shifthue(opts.step)
    victory[x] = color.c*255

white = (pixels[14:35], pixels[78:100])
progress = (pixels[65:78], pixels[0:13])

url = 'http://127.0.0.1:5000/api/job'

shiftCount = 0
error = False

while 1:
    try:
        response = requests.get(url)
        job = json.loads(response.content)
        done = job['progress']['completion']
        error = False
    #except requests.exceptions.ConnectionError:
    except:
        error = True
        done = None

    if done == 100:
        # roll the colors down and put them in the CurrentPix array
        pixels[:] = np.roll(victory, shiftCount, axis=0)
        # push the pixels out
        time.sleep(1./30.)
        shiftCount = shiftCount+3
    else:
        shiftCount = 0
        f = open(filename)
        white_level = int(f.read())
        f.close()

        for section in white:
            section[:] = [white_level] * 3

        if done:
            for section in progress:
                transition = section.shape[0]-section.shape[0]*int(done)/100
                # fill the whole bar as incomplete
                section[:] = [255, 0, 0]
                # color in completed
                section[transition:] = [0, 255, 0]
        else:
            for section in progress:
                section[:] = [0, 0, 0]

        time.sleep(1)
            
    if error:
        pixels[:] = [128, 0, 0]
    client.put_pixels(pixels, channel=0)
