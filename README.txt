# PredictedVideoQuality

# Introduction (what it's about & why you wrote it)
The design and evaluation of a novel reference-only Predicted Video Quality metric is the subject of my master's thesis. This repository contains the code I used to create this video quality metric.
The code here is written for use on a windows computer. I do not know how portable any of the code is.

# How to use
1. Select and download the videos to use to train the metric. The code here assumes that the videos are at least 1920x1080, at least 10 seconds long, and with 60 fps. The videos should be uncompressed so compression artifacts are not incorporated into the metric.
2. Download [ffmpeg](https://ffmpeg.org).
3. Modify and run generateInitalVideos.cmd to trim all input videos to 10 seconds long and 1920x1080.
4. Generate 30 fps videos with ffmpeg by removing every other frame. I do not have the code I used for this.
5. Install Python (I used 3.7).
6. Modify doItAll.py to point to your encoder, decoder, encoderConfigFile, 60fps videos, 30fps videos, and output location. You may also need to change the video names, bitrates, frame rates, slice sizes, and packet error rates. All of these variables are in the first 42 lines of this file. Note: I have included my encoder config file working.cfg and the encoder (TAppEncoder.exe) and decoder (TestDecoder.exe). I do not know if I am allowed to distribute the encoder or decoder, so do not download them if I am not allowed to distribute them.
7. Run doItAll.py to create the results folders, encode the videos at the specified bitrates, drop slices, decode videos, calculate PSNRs, and delete the decoded videos. (I did not have room on my hard drive for all of the decoded videos. - 23 videos at 30 & 60 fps, 2 bitrates, 5 error rates with 10 videos and 1 error rate (0%) with 1 video 10 seconds long at 1920x1080 is aprox 12TB.)
8+. You need to use the matlab code to extract the features, generate the dendrogram, divide the videos into groups, modify and run the collectPSNRsForMatlab.py (this script produces a file whose content can be copied into matlab as a command), calculate parameters and errors (these are the parameters of the metric), and optionally test the metric by generating confusion tables, PSNR comparison plots, and reporting the video parameters.
