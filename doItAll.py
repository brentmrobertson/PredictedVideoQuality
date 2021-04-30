
import array
import bitstring
import datetime
import math
import multiprocessing
import os
import random
import subprocess

ENCODER_LOCATION = r'D:\HMcoders'
ENCODER_NAME = r'TAppEncoder.exe'
CONFIG_FILE = r'D:\scripts\ConfigFiles\working.cfg'

DECODER_LOCATION = r'D:\HMcoders'
DECODER_NAME = r'TestDecoder.exe'

OUTPUT_LOCATION = r'D:\CompressedVideos'

# These two lists must be the same length and refer to the same data at the same index
RAW_VIDEO_LOCATION =[r'D:\10s420YUV\30fps', r'D:\10s420YUV\60fps']
FRAMERATES =        [30,                    60]
#RAW_VIDEO_LOCATION =[r'D:\10s420YUV\30fps', r'D:\10s420YUV\30fps',  r'D:\10s420YUV\60fps']
#FRAMERATES =        [15,                    30,                     60]

# These two lists must be the same length and refer to the same data at the same index
BITRATES =  [3000,  5000]
SLICE_SIZE =[500,   1000]
#BITRATES =  [1500,  3000,   5000,   8000]
#SLICE_SIZE =[500,   1000,   1000,   1000]

VIDEO_NAMES = [ 'Aerial',       'BarScene',             'CSGO',         'Dancers',
                'DinnerScene',  'DotA2',                'DrivingPOV',   'EuroTruckSimulator2',
                'Fallout4',     'FoodMarket',           'GTAV',         'Hearthstone',
                'Minecraft',    'PierSeaside',          'RitualDance',  'RollerCoaster',
                'Rust',         'SquareAndTimelapse',   'StarCraft',    'ToddlerFountain',
                'TunnelFlag',   'WindAndNature',        'Witcher3']

# PER: Packet Error Rate as portion out of 100
PERS = [1, 5, 10, 15, 20]

NUM_ATTEMPTS = 10

def encodeVideo(rawVideoPath, hevcPath, encodeLogPath, bitrate, framerate, reconPath, psnrLogPath):
    print('{}: Encoding {}'.format(datetime.datetime.now(), hevcPath))
    
    with open(file=encodeLogPath, mode='w') as logFile:
        subprocess.run(
            args=[ENCODER_NAME,
                '-c', CONFIG_FILE,
                '--InputFile={}'.format(rawVideoPath),
                '--BitstreamFile={}'.format(hevcPath),
                '--ReconFile={}'.format(reconPath),
                '--FrameRate={}'.format(framerate),
                '--FramesToBeEncoded={}'.format(framerate*10),
                '--IntraPeriod={}'.format(framerate),
                '--SliceArgument={}'.format(SLICE_SIZE[BITRATES.index(bitrate)]),
                '--TargetBitrate={}'.format(bitrate*1000)],
            stdout=logFile,
            stderr=subprocess.STDOUT)
    
    print('{}: Done encoding {}'.format(datetime.datetime.now(), hevcPath))
    
    calculatePSNR(rawVideoPath, reconPath, psnrLogPath)
    #os.remove(reconPath)

NAL_START_CODE = '0x000001'
def dropPackets(hevcNoDropsPath, hevcWithDropsPath, logPath, per):
    print('{}: Dropping packets to {}'.format(datetime.datetime.now(), hevcWithDropsPath))
    
    s = bitstring.BitStream(filename=hevcNoDropsPath)
    
    dropLog = []
    prev = s.len
    while s.rfind(NAL_START_CODE, end=prev, bytealigned=True):
        cur = s.pos
        s.pos -= 8  # Check previous byte to see if it's part of a 4 byte NAL start code
        if s.read('uint:8') == 0:
            cur = s.pos - 8
            # s.pos at start of 3 byte NAL start code (even if 4th byte preceeds it)
        if random.choices([True, False], cum_weights=[per, 100])[0]:
            s.pos += 24 + 1 # NAL Start Bytes + Forbidden Zero Bit
            if s.read('uint:6') < 32:   # If NAL type is VCL
                del s[cur:prev]
                dropLog.insert(0, True)
            else:
                dropLog.insert(0, False)
        else:
            dropLog.insert(0, False)
        prev = cur
    
    with open(file=hevcWithDropsPath, mode='wb') as f:
        s.tofile(f)
    
    with open(file=logPath, mode='w') as f:
        for packet in dropLog:
            f.write('{}\n'.format(packet))
    
    print('{}: Done dropping packets to {}'.format(datetime.datetime.now(), hevcWithDropsPath))

def decodeVideo(encodedPath, decodedPath, logPath):
    print('{}: Decoding {}'.format(datetime.datetime.now(), encodedPath))
    with open(logPath, 'w') as logFile:
        subprocess.run(
            args=[DECODER_NAME, '-b', encodedPath, '-o', decodedPath],
            stdout=logFile,
            stderr=subprocess.STDOUT)
    print('{}: Done decoding {}'.format(datetime.datetime.now(), encodedPath))

WIDTH = 1920
HEIGHT = 1080
LUMA_SIZE = int(WIDTH*HEIGHT)
CHROMA_SIZE = int(WIDTH*HEIGHT/2)

PEAK_SIGNAL = 20.0*math.log10(255)

def calculatePSNR(video1Path, video2Path, logPath):
    print('{}: Calculating PSNR {} & {}'.format(datetime.datetime.now(), video1Path, video2Path))
    video1Size = os.path.getsize(video1Path)
    video2Size = os.path.getsize(video2Path)
    
    minSize = min(video1Size, video2Size)
    
    if video1Size != video2Size:
        print('Warning: File sizes do not match.\n{} is {} bytes.\n{} is {} bytes.'.format(video1Path, video1Size, video2Path, video2Size))
        return(False)
    
    numFrames = int(minSize/(LUMA_SIZE+CHROMA_SIZE))
    PSNRsum = 0
    
    with open(video1Path, 'rb') as video1, open(video2Path, 'rb') as video2:
        for frameNum in range(numFrames):
            # initialize empty array
            video1frameY = array.array('B')
            video2frameY = array.array('B')
            
            # Read next Y frame
            video1frameY.fromfile(video1, LUMA_SIZE)
            video2frameY.fromfile(video2, LUMA_SIZE)
            
            # Skip CbCr frames
            video1.seek(CHROMA_SIZE, os.SEEK_CUR)
            video2.seek(CHROMA_SIZE, os.SEEK_CUR)
            
            # Calculate PSNR(Y)
            mse = sum((a-b)*(a-b) for a,b in zip(video1frameY,video2frameY))/len(video1frameY)
            PSNRsum += PEAK_SIGNAL - 10.0*math.log10(mse)
    meanPSNR = PSNRsum/int(numFrames)
    
    with open(logPath, 'wt') as logFile:
        logFile.write('Video #1: {}\n'.format(video1Path))
        logFile.write('Video #2: {}\n'.format(video2Path))
        logFile.write('PSNR(Y) = {}\n'.format(meanPSNR))
        if video1Size != video2Size:
            logFile.write('Warning: File sizes do not match.\n{} is {} bytes.\n{} is {} bytes.'.format(video1Path, video1Size, video2Path, video2Size))
    
    print('{}: Done calculating PSNR {} {} & {}'.format(datetime.datetime.now(), meanPSNR, video1Path, video2Path))
    return(True)

def dropDecodePSNRerase(
    hevcNoDropsPath,
    hevcWithDropsPath,
    dropLogPath,
    per,
    decodedPath,
    decodeLogPath,
    rawVideoPath,
    psnrLogPath):
    
    while True:
        dropPackets(hevcNoDropsPath, hevcWithDropsPath, dropLogPath, per)
        decodeVideo(hevcWithDropsPath, decodedPath, decodeLogPath)
        if calculatePSNR(rawVideoPath, decodedPath, psnrLogPath):
            os.remove(decodedPath)
            return None

if __name__ == '__main__':
    # Create folders for encoder to place result
    for framerate in FRAMERATES:
        for bitrate in BITRATES:
            os.makedirs(os.path.join(
                OUTPUT_LOCATION,
                '{}fps'.format(framerate),
                '{}kbps'.format(bitrate),
                '0per'))
            for per in PERS:
                for attemptNum in range(NUM_ATTEMPTS):
                    os.makedirs(os.path.join(
                        OUTPUT_LOCATION,
                        '{}fps'.format(framerate),
                        '{}kbps'.format(bitrate),
                        '{}per'.format(per),
                        '{}'.format(attemptNum)))
    
    # Encode videos, decode 0PER videos, generate 0PER PSNRs, delete decoded videos
    os.chdir(ENCODER_LOCATION)
    with multiprocessing.Pool(maxtasksperchild=1) as myPool:
        results = [myPool.apply_async(
            func=encodeVideo,
            kwds={'rawVideoPath': os.path.join(
                    RAW_VIDEO_LOCATION[FRAMERATES.index(framerate)],
                    '{}.yuv'.format(videoName)),
                'hevcPath': os.path.join(
                    OUTPUT_LOCATION,
                    '{}fps'.format(framerate),
                    '{}kbps'.format(bitrate),
                    '0per',
                    '{}.hevc'.format(videoName)),
                'encodeLogPath': os.path.join(
                    OUTPUT_LOCATION,
                    '{}fps'.format(framerate),
                    '{}kbps'.format(bitrate),
                    '0per',
                    '{}_encoding.log'.format(videoName)),
                'bitrate': bitrate,
                'framerate': framerate,
                'reconPath': os.path.join(
                    OUTPUT_LOCATION,
                    '{}fps'.format(framerate),
                    '{}kbps'.format(bitrate),
                    '0per',
                    '{}.yuv'.format(videoName)),
                'psnrLogPath': os.path.join(
                    OUTPUT_LOCATION,
                    '{}fps'.format(framerate),
                    '{}kbps'.format(bitrate),
                    '0per',
                    '{}_psnr.log'.format(videoName))})
            for videoName in VIDEO_NAMES
            for framerate in FRAMERATES
            for bitrate in BITRATES]
        for result in results:
            result.get()
        myPool.close()
        myPool.join()
    
    # Drop slices, decode videos, generate PSNRs, delete decoded videos
    os.chdir(DECODER_LOCATION)
    with multiprocessing.Pool(maxtasksperchild=1) as myPool:
        results = [myPool.apply_async(
            func=dropDecodePSNRerase,
            kwds={'hevcNoDropsPath': os.path.join(
                    OUTPUT_LOCATION,
                    '{}fps'.format(framerate),
                    '{}kbps'.format(bitrate),
                    '0per',
                    '{}.hevc'.format(videoName)),
                'hevcWithDropsPath': os.path.join(
                    OUTPUT_LOCATION,
                    '{}fps'.format(framerate),
                    '{}kbps'.format(bitrate),
                    '{}per'.format(per),
                    '{}'.format(attemptNum),
                    '{}.hevc'.format(videoName)),
                'dropLogPath': os.path.join(
                    OUTPUT_LOCATION,
                    '{}fps'.format(framerate),
                    '{}kbps'.format(bitrate),
                    '{}per'.format(per),
                    '{}'.format(attemptNum),
                    '{}_drop.log'.format(videoName)),
                'per': per,
                'decodedPath': os.path.join(
                    OUTPUT_LOCATION,
                    '{}fps'.format(framerate),
                    '{}kbps'.format(bitrate),
                    '{}per'.format(per),
                    '{}'.format(attemptNum),
                    '{}.yuv'.format(videoName)),
                'decodeLogPath': os.path.join(
                    OUTPUT_LOCATION,
                    '{}fps'.format(framerate),
                    '{}kbps'.format(bitrate),
                    '{}per'.format(per),
                    '{}'.format(attemptNum),
                    '{}_decode.log'.format(videoName)),
                'rawVideoPath': os.path.join(
                    RAW_VIDEO_LOCATION[FRAMERATES.index(framerate)],
                    '{}.yuv'.format(videoName)),
                'psnrLogPath': os.path.join(
                    OUTPUT_LOCATION,
                    '{}fps'.format(framerate),
                    '{}kbps'.format(bitrate),
                    '{}per'.format(per),
                    '{}'.format(attemptNum),
                    '{}_psnr.log'.format(videoName))})
            for videoName in VIDEO_NAMES
            for framerate in FRAMERATES
            for bitrate in BITRATES
            for per in PERS
            for attemptNum in range(NUM_ATTEMPTS)]
        for result in results:
            result.get()
        myPool.close()
        myPool.join()
    
    print('{}: Done!'.format(datetime.datetime.now()))
