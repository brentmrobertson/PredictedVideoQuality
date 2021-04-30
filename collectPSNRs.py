
import os
import statistics

OUTPUT_LOCATION = r'D:\CompressedVideos'

FRAMERATES = [30, 60]
BITRATES = [3000, 5000]

VIDEO_NAMES = [ 'GTAV', 'ToddlerFountain', 'EuroTruckSimulator2', 'DrivingPOV',
                'Fallout4', 'SquareAndTimelapse', 'FoodMarket', 'RollerCoaster',
                'Aerial', 'Rust', 'Witcher3', 'BarScene',
                'DinnerScene', 'Dancers', 'DotA2', 'PierSeaside',
                'Hearthstone', 'StarCraft', 'WindAndNature', 'CSGO',
                'TunnelFlag', 'Minecraft', 'RitualDance']

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
    print([attempt for attempt in attempts if (attempt < lowerFence) or (attempt > upperFence)])
    return statistics.mean([attempt for attempt in attempts if (attempt >= lowerFence) and (attempt <= upperFence)])
    

if __name__ == '__main__':
    for framerate in FRAMERATES:
        for bitrate in BITRATES:
            with open(os.path.join(
                OUTPUT_LOCATION,
                '{}fps'.format(framerate),
                '{}kbps'.format(bitrate),
                'PSNRs.csv'), 'wt') as csvFile:
                
                # Header
                csvFile.write('Video')
                for per in [0]+PERS:
                    csvFile.write(',{} PER'.format(per))
                csvFile.write('\n')
                
                # Content
                for videoName in VIDEO_NAMES:
                    csvFile.write(videoName)
                    
                    # 0 PER
                    csvFile.write(',{}'.format(getPSNRfromLog(os.path.join(
                        OUTPUT_LOCATION,
                        '{}fps'.format(framerate),
                        '{}kbps'.format(bitrate),
                        '0per',
                        '{}_psnr.log'.format(videoName)))))
                    
                    for per in PERS:
                        print('{}fps'.format(framerate),
                                '{}kbps'.format(bitrate),
                                '{}per'.format(per),
                                videoName)
                        csvFile.write(',{}'.format(getMeanWithoutOutliers([getPSNRfromLog(os.path.join(
                                OUTPUT_LOCATION,
                                '{}fps'.format(framerate),
                                '{}kbps'.format(bitrate),
                                '{}per'.format(per),
                                '{}'.format(attemptNum),
                                '{}_psnr.log'.format(videoName)))
                            for attemptNum in range(NUM_ATTEMPTS)])))
                    
                    csvFile.write('\n')
