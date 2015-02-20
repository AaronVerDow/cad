#!/usr/bin/python
import fastopc as opc
import numpy as np
import time
import requests
import json
import vox_color
from optparse import OptionParser


parser = OptionParser()
parser.add_option("--host", dest="host", default="127.0.0.1",
                  help="hostname or IP of opc server")
parser.add_option("--port", dest="port", default="7890",
                  help="port for opc server")
parser.add_option("--octo-host", dest="octo_host", default="127.0.0.1",
                  help="hostname or IP of octoprint server")
parser.add_option("--octo-port", dest="octo_port", default="5000",
                  help="port for octoprint server")
parser.add_option("--step", dest="step", type="int", default=3.6,
                  help="steps to shift victory hue. larger makes tighter bands")
parser.add_option("--speed", dest="speed", type="int", default=3,
                  help="steps to interate victory array per loop")
(options, args) = parser.parse_args()


def create_pixel_array():
    '''
    Return a blank array of pixels
    '''
    return np.zeros((led_count, 3), dtype=np.uint8)


def display(array, sleep):
    '''
    Write array out to LEDs and sleep
    '''
    client.put_pixels(array, channel=0)
    time.sleep(sleep)
    return


def get_white():
    '''
    Get current white value to control brighness of the lights
    '''
    f = open(white_filename)
    white = int(f.read())
    f.close()
    return white


# how many LEDs are in the strip?
led_count = 128

# define colors
incomplete_color = [255, 0, 0]
complete_color = [0, 255, 0]
default_color = [0, 0, 0]
error_color = [128, 0, 0]

# how long to wait between writing updates to the LEDs
default_sleep = 1
# same, but for the victory pattern
victory_sleep = 1./30.

# file that's used to get the current white level
white_filename = '/home/averdow/.white_value'

# setup opc client for writing to the LEDs
client = opc.Client("%s:%s" % (options.host, options.port))

# URL to get progress from OctoPrint server
octo_url = 'http://%s:%s/api/job' % (options.octo_host, options.octo_port)

# create default view, split into sections by function
default_view = create_pixel_array()
white_pixels = (default_view[14:35], default_view[78:100])
progress_pixels = (default_view[65:78], default_view[0:13])

# create error view, populate with error color
error_view = create_pixel_array()
error_view[:] = error_color

# create victory view, initialize with a rainbow
victory_view = create_pixel_array()
color = vox_color.color(0)
for x in range(led_count):
    color.shifthue(options.step)
    victory_view[x] = color.c*255


# loop forever
while 1:
    try:
        # get print progress from OctoPrint
        response = requests.get(octo_url)
        job = json.loads(response.content)
        done = job['progress']['completion']
    except:
        # could not get a value from OctoPrint, display error
        display(error_view, default_sleep)
        continue

    if done == 100:
        # the print is complete, display victory
        victory_view = np.roll(victory_view, options.speed, axis=0)
        display(victory_view, victory_sleep)
        continue

    # set brightness for visibility pixels
    white = get_white()
    for section in white_pixels:
        section[:] = [white] * 3

    if done:
        # done has a value, display print progress
        for section in progress_pixels:
            transition = section.shape[0]-section.shape[0]*int(done)/100
            section[:transition] = incomplete_color
            section[transition:] = complete_color
    else:
        # done is empty, set progress pixels to default
        for section in progress_pixels:
            section[:] = default_color

    display(default_view, default_sleep)
