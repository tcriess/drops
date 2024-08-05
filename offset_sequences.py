#!/usr/bin/env python3

import numpy as np
from scipy.interpolate import griddata
import plotly.graph_objects as go
from math import sin,cos,pi
import matplotlib.pyplot as plt
from matplotlib import cm
from matplotlib.ticker import LinearLocator
from scipy.io import wavfile
from scipy import signal
import sys

if __name__ == '__main__':
    print("; this file is generated via offset_sequences.py")

    data = np.array([[0.0 for _ in range(8)] for _ in range(8)])
    data[1,1] = -20.0

    # print("    dc.w 5 ; keep for 5 frames")

    #for y in range(8):
    #    d = data[y].astype(int).astype(str)
    #    print(f"    dc.w {','.join(d)}")

    # z=(cos( 0.5sqrt(x^2+y^2)-6n)/(0.5(x^2+y^2)+1+2n),  n={0...10}

    for n in range(50):
        xarr = []
        yarr = []
        zarr = []

        # print(f"    dc.w 0 ; global offset per frame")
        for x in range(-31,33,9):
            for y in range(-31,33,9):
                xarr.append(x)
                yarr.append(y)
                xscaled = x / 32 * 2 * pi * 4
                yscaled = y / 32 * 2 * pi * 4
                zarr.append( 10* cos( 0.5 * np.sqrt(xscaled**2 + yscaled**2) - 6*n ) / (0.5*( xscaled**2 + yscaled**2 ) + 1 + 2*n ) )
        
        zscale = 100
        z = np.array(zarr)
        z[z >= 100] = 99
        for y in range(8):
            d = (zscale*z[y*8:(y+1)*8]).astype(int).astype(str)
            print(f"    dc.w {','.join(d)}")
        print(";    dc.w 5 ; number of frames to keep the previous offsets")
        
        continue
        x = np.array(xarr)
        y = np.array(yarr)
        z = np.array(zarr)
        xi = np.linspace(x.min(), x.max(), 100)
        yi = np.linspace(y.min(), y.max(), 100)

        X,Y = np.meshgrid(xi,yi)

        Z = griddata((x,y),z,(X,Y), method='cubic')

        fig, ax = plt.subplots(subplot_kw={"projection": "3d"})
        surf = ax.plot_surface(X, Y, Z, cmap=cm.coolwarm,
                        linewidth=0, antialiased=False)
        ## Customize the z axis.
        ax.set_zlim(-1.01, 1.01)
        ax.zaxis.set_major_locator(LinearLocator(10))
        ## A StrMethodFormatter is used automatically
        ax.zaxis.set_major_formatter('{x:.02f}')

        ## Add a color bar which maps values to colors.
        fig.colorbar(surf, shrink=0.5, aspect=5)

        plt.show()


    print("    dc.w 101 ; end of sequences")

    sys.exit()


    samplerate, data = wavfile.read('./bumtarabum.wav')
    print(f"{samplerate}")
    channel = data.T[0]
    print(channel)

    # we compute one power spectrum density per "frames_per_psd" frames
    # f.e. 10 per second
    # i.e. on a 50Hz screen, keep every psd for 5 frames
    frames_per_psd = samplerate / 10



    # compute the power spectrum
    # signal.welch
    f, Pxx_spec = signal.welch(channel[0:int(samplerate/10)], samplerate, 'flattop', 1024, scaling='spectrum')

    plt.figure()
    plt.semilogy(f, np.sqrt(Pxx_spec))
    plt.xlabel('frequency [Hz]')
    plt.ylabel('Linear spectrum [V RMS]')
    plt.title('Power spectrum (scipy.signal.welch)')
    plt.show()

    plt.figure()
    plt.semilogy(f, np.sqrt(Pxx_spec))
    plt.xlabel('frequency [Hz]')
    plt.ylabel('Linear spectrum [V RMS]')
    plt.title('Power spectrum (scipy.signal.welch)')
    plt.show()

    f, Pxx_spec = signal.welch(channel[int(samplerate/10):2*int(samplerate/10)], samplerate, 'flattop', 1024, scaling='spectrum')
    plt.figure()
    plt.semilogy(f, np.sqrt(Pxx_spec))
    plt.xlabel('frequency [Hz]')
    plt.ylabel('Linear spectrum [V RMS]')
    plt.title('Power spectrum (scipy.signal.welch)')
    plt.show()

    f, Pxx_spec = signal.welch(channel[2*int(samplerate/10):3*int(samplerate/10)], samplerate, 'flattop', 1024, scaling='spectrum')
    plt.figure()
    plt.semilogy(f, np.sqrt(Pxx_spec))
    plt.xlabel('frequency [Hz]')
    plt.ylabel('Linear spectrum [V RMS]')
    plt.title('Power spectrum (scipy.signal.welch)')
    plt.show()

    xarr = []
    yarr = []
    zarr = []
    for x in range(-31,33,9):
        for y in range(-31,33,9):
            xarr.append(x)
            yarr.append(y)
            zarr.append( sin(x/32 * 2 * pi) * cos(y/32 * 2 * pi) )
    x = np.array(xarr)
    y = np.array(yarr)
    z = np.array(zarr)
    xi = np.linspace(x.min(), x.max(), 100)
    yi = np.linspace(y.min(), y.max(), 100)

    X,Y = np.meshgrid(xi,yi)

    Z = griddata((x,y),z,(X,Y), method='cubic')

    fig, ax = plt.subplots(subplot_kw={"projection": "3d"})
    surf = ax.plot_surface(X, Y, Z, cmap=cm.coolwarm,
                       linewidth=0, antialiased=False)
    # Customize the z axis.
    ax.set_zlim(-1.01, 1.01)
    ax.zaxis.set_major_locator(LinearLocator(10))
    # A StrMethodFormatter is used automatically
    ax.zaxis.set_major_formatter('{x:.02f}')

    # Add a color bar which maps values to colors.
    fig.colorbar(surf, shrink=0.5, aspect=5)

    plt.show()

    # fig = go.Figure(go.Surface(x=xi,y=yi,z=Z))
    # fig.show()

    