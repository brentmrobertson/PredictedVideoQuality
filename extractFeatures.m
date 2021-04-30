
function [SAD, brightness, edginess, blurriness] = extractFeatures(VIDEO_PATH)
    % Extract video features
    % VIDEO_PATH is a string path to a video.
    % SAD is the Sum of Absolute Differences (calculated between first frame in second and each frame)
    % brightness is the change in Y between frames
    % edginess is the average value resultant from the Canny edge detection
    % blurriness is the distance between maxima and minima for edges detected using Canny edge detection
    
    video = VideoReader(VIDEO_PATH);
    
    frameIdx = 0;
    SADcount = 0;
    SADsum = 0;
    brightnessSum = 0;
    edginessSum = 0;
    blurrinessSum = 0;
    
    while hasFrame(video)
        frame = rgb2ycbcr(readFrame(video));
        frame = frame(:,:,1);
        int16frame = int16(frame);
        
        % SAD
        if mod(frameIdx, video.FrameRate) == 0
            baseFrame = int16frame;
        else
            SADcount = SADcount + 1;
            SADsum = SADsum + mean(abs(int16frame(:)-baseFrame(:)),'double');
        end
        
        % brightness
        if frameIdx ~= 0
            brightnessSum = brightnessSum + abs(mean(int16frame(:)-prevFrame(:),'double'));
        end
        prevFrame = int16frame;
        
        % edginess
        cannyFrame = edge(frame, 'canny');
        edginessSum = edginessSum + mean(cannyFrame(:),'double');
        
        % blurriness
        % row length only
        distSum = 0;
        extrema = islocalmax(frame,2) | islocalmin(frame,2);
        for rowNum = 1:video.height
            for colNum = 1:video.width
                if cannyFrame(rowNum, colNum)
                    leftOffset = 0;
                    while ~extrema(rowNum, colNum+leftOffset) & ((colNum+leftOffset) ~= 1)
                        leftOffset = leftOffset - 1;
                    end
                    rightOffset = 0;
                    while ~extrema(rowNum, colNum+rightOffset) & ((colNum+rightOffset) ~= video.width)
                        rightOffset = rightOffset + 1;
                    end
                    distSum = distSum + rightOffset - leftOffset;
                end
            end
        end
        blurrinessSum = blurrinessSum + (distSum / sum(cannyFrame(:)));
        
        frameIdx = frameIdx + 1;
    end
    
    SAD = SADsum / SADcount;
    brightness = brightnessSum / (frameIdx - 1);
    edginess = edginessSum / frameIdx;
    blurriness = blurrinessSum / frameIdx;
end
