# J. Macoskey, U of Michigan, I-GUTL, April 2017
# backscatter analysis of signals from 250 kHz 256-element array
# Objective: observe bubble cloud migration on high-speed camera and compare to
# ACE peak arrival (and edge detection) signal.

import numpy as np
import scipi.io as sio
import matplotlib.pyplot as plt

class array():
    def __init__(self):
        coords  = sio.loadmat('256x2cm_Hemispherical_Array_CAD_Coordinates.mat')
        X = coords['XCAD'][7:]
	Y = coords['YCAD'][7:]
	self.z = coords['ZCAD'][7:]
	t1 = np.arctan2(Y,X)-0.75*pi
	rr1 = (X**2+Y**2)**0.5
	self.x = rr1*np.cos(t1)
	self.y = rr1*np.sin(t1)
	self.z = rr1*np.tan(t1)

class bSignals():
    def FTsig(self,signal,interval)
        insig = signal(interval)
        ft = np.fftshift(np.fft(insig))
        return ft

fig = plt.figure()
plt.plot(ft)
plt.show()


