#!/usr/bin/env python3

from scipy.io import wavfile
from scipy.fftpack import fft
import numpy as np
import matplotlib.pyplot as plt
from time import sleep

# chunk size...
# vbi is 1/50s on the atari, this means one video frame = 882 audio frames.
# we chunk in 5-frame-parts. this calculation assumes 44100Hz samplingrate
number_of_video_frames = 5
CHUNK = 882 * number_of_video_frames # 1024 * 2

if __name__ == '__main__':
    samplerate, data = wavfile.read('./bumtarabum.wav')
    print(f"; samplerate={samplerate}")
    channel = data.T[0]
    # print(channel)

    channel = channel.astype(float) / np.max(np.abs(channel),axis=0).astype(int)
    channel *= 256

    x = np.arange(0, 2 * CHUNK, 2)
    xf = np.linspace(0, samplerate, CHUNK)

    fig, (ax1, ax2) = plt.subplots(2, figsize=(15, 7))

    line, = ax1.plot(x, np.random.rand(CHUNK), '-', lw=2)

    # fig.canvas.mpl_connect('button_press_event', self.onClick)
    line_fft, = ax2.semilogx(
        xf, np.random.rand(CHUNK), '-', lw=2)
    
    timestep = 1 / samplerate
    freq = np.fft.fftfreq(CHUNK, d=timestep)
    # print(list(freq))

    # these are the frequencies of the fft results. note that only the first CHUNK/2 are to be used (due to symmetry), and they go up to samplerate/2
    # CHUNK is 1024, we want 8 bins in the end, so we bin 128 values
    halb = CHUNK//2
    bins = [(0, CHUNK//256), (CHUNK//256, CHUNK//128), (CHUNK//128, CHUNK//64), (CHUNK//64, CHUNK//32) , (CHUNK//32, CHUNK//16), (CHUNK//16, CHUNK//8), (CHUNK//8, CHUNK//4), (CHUNK//4, CHUNK//2)]
    #for c in range(8):
    #    print(f"{np.min(freq[c*128:(c+1)*128])} - {np.max(freq[c*128:(c+1)*128])}")
    #    print(f"{np.min(freq[bins[c][0]:bins[c][1]])} - {np.max(freq[bins[c][0]:bins[c][1]])}")

    # format waveform axes
    ax1.set_title('AUDIO WAVEFORM')
    ax1.set_xlabel('samples')
    ax1.set_ylabel('volume')
    ax1.set_ylim(0, 255)
    ax1.set_xlim(0, 2 * CHUNK)
    plt.setp(
        ax1, yticks=[0, 128, 255],
        xticks=[0, CHUNK, 2 * CHUNK],
    )
    plt.setp(ax2, yticks=[0, 1],)

    # format spectrum axes
    ax2.set_xlim(20, samplerate / 2)

    # show axes
    thismanager = plt.get_current_fig_manager()

    #plt.show(block=False)

    for i in range(len(channel)//CHUNK):
        data = channel[i*CHUNK:(i+1)*CHUNK]
        #line.set_ydata(data + 128)

        yf = fft(data)

        yf_db = np.log10(2*np.abs(yf)/CHUNK)
        yf_db[yf_db < 0] = 0

        # binning
        vals = np.array([0 for _ in range(8)])
        for c in range(8):
            # val = np.mean(np.abs(yf_db[c*128:(c+1)*128]) * 100)
            val = np.sum(np.abs( yf_db[ bins[c][0] : bins[c][1] ] ) )
            if val > 50:
                vals[c] = -50
            else:
                vals[c] = -val
        
        print(f"    dc.w {vals[0]},{vals[1]},{vals[2]},{vals[3]},{vals[4]},{vals[5]},{vals[6]},{vals[7]}")
        print(f";    dc.w {number_of_video_frames} ; number of frames")
        # line_fft.set_ydata(np.abs(yf[0:CHUNK]) / (128 * CHUNK))
        #line_fft.set_ydata(yf_db)

        # update figure canvas
        #fig.canvas.draw()
        #fig.canvas.flush_events()

        #sleep(1)
    print(f"    dc.w 101 ; end of sequence")