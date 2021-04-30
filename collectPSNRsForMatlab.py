
import os
import statistics

OUTPUT_LOCATION = r'D:\CompressedVideos'

FRAMERATES = [30, 60]
BITRATES = [3000, 5000]

#VIDEO_NAMES = [ 'GTAV', 'ToddlerFountain', 'EuroTruckSimulator2', 'DrivingPOV',
#                'Fallout4', 'SquareAndTimelapse', 'FoodMarket', 'RollerCoaster',
#                'Aerial', 'Rust', 'Witcher3', 'BarScene',
#                'DinnerScene', 'Dancers', 'DotA2', 'PierSeaside',
#                'Hearthstone', 'StarCraft', 'WindAndNature', 'CSGO',
#                'TunnelFlag', 'Minecraft', 'RitualDance']
#VIDEO_NAMES = [ 'GTAV', 'ToddlerFountain', 'EuroTruckSimulator2', 'DrivingPOV',
#                'Fallout4', 'SquareAndTimelapse', 'FoodMarket', 'Aerial',
#                'Rust', 'Witcher3', 'BarScene', 'DinnerScene',
#                'Dancers', 'DotA2', 'PierSeaside', 'Hearthstone',
#                'StarCraft', 'WindAndNature']
OUTPUT_PREPEND = ''
BLUE_VIDEO_NAMES = ['GTAV', 'ToddlerFountain', 'EuroTruckSimulator2',
                'Fallout4', 'SquareAndTimelapse', 'FoodMarket', 'DrivingPOV']
RED_VIDEO_NAMES = [ 'Aerial', 'Rust', 'Witcher3']
GREEN_VIDEO_NAMES = [ 'BarScene', 'DinnerScene', 'Dancers', 'DotA2', 'PierSeaside']
PURPLE_VIDEO_NAMES = [ 'Hearthstone', 'StarCraft', 'WindAndNature']

PERS = [1, 5, 10, 15, 20]
NUM_ATTEMPTS = 10

def getPSNRfromLog(logPath):
    with open(logPath, 'r') as logFile:
        # skip video filepaths
        logFile.readline()
        logFile.readline()
        # return the psnr as a float after trimming off the 10 char 'PSNR(Y) = ' and trailing \n
        return float(logFile.readline()[10:-1])

def getMeanWithoutOutliers(attempts):
    outlierIQRmultiplier = 1.5
    
    attempts.sort()
    if len(attempts)%2 == 1:
        lowerList = attempts[:int((len(attempts)-1)/2)]
        upperList = attempts[int((len(attempts)+1)/2):]
    else:
        lowerList = attempts[:int(len(attempts)/2)]
        upperList = attempts[int(len(attempts)/2):]
    
    Q1 = statistics.median(lowerList)
    Q3 = statistics.median(upperList)
    
    IQR = Q3-Q1
    
    lowerFence = Q1 - IQR * outlierIQRmultiplier
    upperFence = Q3 + IQR * outlierIQRmultiplier
    return statistics.mean([attempt for attempt in attempts if (attempt >= lowerFence) and (attempt <= upperFence)])


if __name__ == '__main__':
    with    open(os.path.join(OUTPUT_LOCATION, 'PSNRsForMatlab.txt' ), 'wt') as psnrFile, \
            open(os.path.join(OUTPUT_LOCATION, 'VarsForMatlab.txt'), 'wt') as varsFile:
        for (VIDEO_NAMES, OUTPUT_PREPEND) in (  (BLUE_VIDEO_NAMES, 'Blue'),
                                                (RED_VIDEO_NAMES, 'Red'),
                                                (GREEN_VIDEO_NAMES, 'Green'),
                                                (PURPLE_VIDEO_NAMES, 'Purple')):
            varsFile.write('{}X = [\n'.format(OUTPUT_PREPEND))
            psnrFile.write('{}Y = [\n'.format(OUTPUT_PREPEND))
            for framerate in FRAMERATES:
                for bitrate in BITRATES:
                    for videoName in VIDEO_NAMES:
                        # 0 PER
                        varsFile.write('{},{},{};\n'.format(framerate, bitrate, 0))
                        psnrFile.write('{}\n'.format(getPSNRfromLog(os.path.join(
                            OUTPUT_LOCATION,
                            '{}fps'.format(framerate),
                            '{}kbps'.format(bitrate),
                            '0per',
                            '{}_psnr.log'.format(videoName)))))
                        
                        for per in PERS:
                            varsFile.write('{},{},{};\n'.format(framerate, bitrate, per/100))
                            psnrFile.write('{}\n'.format(getMeanWithoutOutliers([getPSNRfromLog(os.path.join(
                                    OUTPUT_LOCATION,
                                    '{}fps'.format(framerate),
                                    '{}kbps'.format(bitrate),
                                    '{}per'.format(per),
                                    '{}'.format(attemptNum),
                                    '{}_psnr.log'.format(videoName)))
                                for attemptNum in range(NUM_ATTEMPTS)])))
            varsFile.write("]';\n")
            psnrFile.write("]';\n")
