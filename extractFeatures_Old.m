
function [SAD, brightness, edginess, blurriness] = extractFeatures(VIDEO_PATH)
    % Extract video features
    % VIDEO_PATH is a string path to a video.
    % SAD is the Su of Absolute Differences (calculated between first frame in second and each frame)
    % brightness is the change in Y between frames
    % edginess is the average value resultant from the Canny edge detection
    % blurriness is the distance between maxima and minima for edges detected using Canny edge detection
    
    % Last stuff
    %CLOCKWISE_SEARCH =  [ 1, 4, 7, 8, 9, 6, 3, 2];
    %ROW_OFFSET =        [-1,-1,-1, 0, 1, 1, 1, 0];
    %COL_OFFSET =        [-1, 0, 1, 1, 1, 0,-1,-1];
    
    % Sobel gradient
    %DIR_ROW = [ 0, 1, 1, 1, 0,-1,-1,-1, 0];
    %DIR_COL = [-1,-1, 0, 1, 1, 1, 0,-1,-1];
    
    % min based search
    ROW_OFFSET = [-1; 0; 1]*[1, 1, 1];
    COL_OFFSET = [1; 1; 1]*[-1, 0, 1];
    ANGLES = [135, 90, 45; 180, NaN, 0; 225, 270, 315];
    
    video = VideoReader(VIDEO_PATH);
    
    frameIdx = 0;
    SADcount = 0;
    SADsum = 0;
    brightnessSum = 0;
    edginessSum = 0;
    blurrinessSum = 0;
    
    %while hasFrame(video)
    numFrames = 10;
    SADtimes = zeros(1, numFrames);
    brightnessTimes = zeros(1, numFrames);
    edginessTimes = zeros(1, numFrames);
    blurrinessTimes = zeros(1, numFrames);
    for n=1:numFrames
        fprintf('Now processing frame #%i\n', frameIdx);
        frame = rgb2ycbcr(readFrame(video));
        frame = frame(:,:,1);
        int16frame = int16(frame);
        
        % SAD
        tic
        if mod(frameIdx, video.FrameRate) == 0
            baseFrame = int16frame;
        else
            SADcount = SADcount + 1;
            SADsum = SADsum + mean(abs(int16frame(:)-baseFrame(:)),'double');
        end
        SADtimes(n) = toc;
        
        % brightness
        tic
        if frameIdx ~= 0
            brightnessSum = brightnessSum + abs(mean(int16frame(:)-prevFrame(:),'double'));
        end
        prevFrame = int16frame;
        %brightnessSum = brightnessSum + mean(int16frame(:));
        brightnessTimes(n) = toc;
        
        % edginess
        tic
        cannyFrame = edge(frame, 'canny');
        edginessSum = edginessSum + mean(cannyFrame(:),'double');
        edginessTimes(n) = toc;
        
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
        
        
        %{
        % Sobel gradient
        % Gets lost in flat areas
        tic
        distSum = 0;
        regionalMax = imregionalmax(frame);
        regionalMin = imregionalmin(frame);
        [Gmag, Gdir] = imgradient(frame, 'Sobel');
        invalidDir = (Gmag == 0);
        clear Gmag;
        Gdir = int8((Gdir+225)/45);
        cannyPixNum = 0;
        for rowNum = 1:video.height
            for colNum = 1:video.width
                if cannyFrame(rowNum, colNum)
                    minCoords = [rowNum, colNum];
                    dir = 5;
                    fprintf('cannyPixNum = %i\n', cannyPixNum);
                    cannyPixNum = cannyPixNum + 1;
                    while ~regionalMin(minCoords(1), minCoords(2))
                        if ~invalidDir(minCoords(1), minCoords(2))
                            if (mod(dir-1,8)+1) == (mod(Gdir(minCoords(1), minCoords(2))-1,8)+1)
                                nearArea = Gdir(max(1,minCoords(1)-1):min(video.height,minCoords(1)+1),max(1,minCoords(2)-1):min(video.width,minCoords(2)+1));
                                dir = int8((atan2d(mean(DIR_COL(nearArea(:))), mean(DIR_ROW(nearArea(:))))+225)/45);
                            else
                                dir = Gdir(minCoords(1), minCoords(2));
                            end
                            dir = mod(dir+3,8)+1;
                        end
                        
                        fprintf('\nSeeking Down Gradient:\n');
                        fprintf('rowNum = %i\n', rowNum);
                        fprintf('colNum = %i\n', colNum);
                        fprintf('minCoords(1) = %i\n', minCoords(1));
                        fprintf('minCoords(2) = %i\n', minCoords(2));
                        fprintf('video.height = %i\n', video.height);
                        fprintf('video.width = %i\n', video.width);
                        fprintf('dir = %i\n', dir);
                        fprintf('DIR_ROW(dir) = %i\n', DIR_ROW(dir));
                        fprintf('DIR_COL(dir) = %i\n', DIR_COL(dir));
                        fprintf('frame:regionalMin:Gdir:invalidDir');
                        [frame(max(1,minCoords(1)-1):min(video.height,minCoords(1)+1),max(1,minCoords(2)-1):min(video.width,minCoords(2)+1)), regionalMin(max(1,minCoords(1)-1):min(video.height,minCoords(1)+1),max(1,minCoords(2)-1):min(video.width,minCoords(2)+1)), Gdir(max(1,minCoords(1)-1):min(video.height,minCoords(1)+1),max(1,minCoords(2)-1):min(video.width,minCoords(2)+1)), invalidDir(max(1,minCoords(1)-1):min(video.height,minCoords(1)+1),max(1,minCoords(2)-1):min(video.width,minCoords(2)+1))]
                        pause;
                        
                        if (minCoords(1) == min(video.height,max(1,minCoords(1) + DIR_ROW(dir)))) & (minCoords(2) == min(video.width ,max(1,minCoords(2) + DIR_COL(dir))))
                            fprintf('distSum = %i\n', distSum);
                            fprintf('rowNum = %i\n', rowNum);
                            fprintf('colNum = %i\n', colNum);
                            fprintf('minCoords(1) = %i\n', minCoords(1));
                            fprintf('minCoords(2) = %i\n', minCoords(2));
                            fprintf('video.height = %i\n', video.height);
                            fprintf('video.width = %i\n', video.width);
                            fprintf('dir = %i\n', dir);
                            fprintf('DIR_ROW(dir) = %i\n', DIR_ROW(dir));
                            fprintf('DIR_COL(dir) = %i\n', DIR_COL(dir));
                            SAD = frame;
                            brightness = regionalMax;
                            edginess = regionalMin;
                            blurriness = Gdir;
                            return
                        end
                        
                        minCoords(1) = min(video.height,max(1,minCoords(1) + DIR_ROW(dir)));
                        minCoords(2) = min(video.width ,max(1,minCoords(2) + DIR_COL(dir)));
                    end
                    maxCoords = [rowNum, colNum];
                    dir = 5;
                    while ~regionalMax(maxCoords(1), maxCoords(2))
                        if ~invalidDir(maxCoords(1), maxCoords(2))
                            if (mod(dir+3,8)+1) == (mod(Gdir(maxCoords(1), maxCoords(2))-1,8)+1)
                                nearArea = Gdir(max(1,maxCoords(1)-1):min(video.height,maxCoords(1)+1),max(1,maxCoords(2)-1):min(video.width,maxCoords(2)+1));
                                dir = int8((atan2d(mean(DIR_COL(nearArea(:))), mean(DIR_ROW(nearArea(:))))+225)/45);
                                %{
                                fprintf('nearArea:\n');
                                nearArea
                                fprintf('DIR_COL(nearArea(:)):\n')
                                DIR_COL(nearArea(:))
                                fprintf('mean(DIR_COL(nearArea(:))) = %f\n', mean(DIR_COL(nearArea(:))));
                                fprintf('DIR_ROW(nearArea(:)):\n')
                                DIR_ROW(nearArea(:))
                                fprintf('mean(DIR_ROW(nearArea(:))) = %f\n', mean(DIR_ROW(nearArea(:))));
                                fprintf('atan2d(mean(DIR_COL(nearArea(:))), mean(DIR_ROW(nearArea(:)))) = %f\n', atan2d(mean(DIR_COL(nearArea(:))), mean(DIR_ROW(nearArea(:)))));
                                fprintf('dir = %f\n', dir);
                                %}
                            else
                                dir = Gdir(maxCoords(1), maxCoords(2));
                            end
                        end
                        
                        fprintf('\nSeeking Up Gradient:\n');
                        fprintf('rowNum = %i\n', rowNum);
                        fprintf('colNum = %i\n', colNum);
                        fprintf('maxCoords(1) = %i\n', maxCoords(1));
                        fprintf('maxCoords(2) = %i\n', maxCoords(2));
                        fprintf('video.height = %i\n', video.height);
                        fprintf('video.width = %i\n', video.width);
                        fprintf('dir = %i\n', dir);
                        fprintf('DIR_ROW(dir) = %i\n', DIR_ROW(dir));
                        fprintf('DIR_COL(dir) = %i\n', DIR_COL(dir));
                        fprintf('frame:regionalMin:Gdir:invalidDir');
                        [frame(max(1,maxCoords(1)-1):min(video.height,maxCoords(1)+1),max(1,maxCoords(2)-1):min(video.width,maxCoords(2)+1)), regionalMax(max(1,maxCoords(1)-1):min(video.height,maxCoords(1)+1),max(1,maxCoords(2)-1):min(video.width,maxCoords(2)+1)), Gdir(max(1,maxCoords(1)-1):min(video.height,maxCoords(1)+1),max(1,maxCoords(2)-1):min(video.width,maxCoords(2)+1)), invalidDir(max(1,maxCoords(1)-1):min(video.height,maxCoords(1)+1),max(1,maxCoords(2)-1):min(video.width,maxCoords(2)+1))]
                        pause;
                        
                        if (maxCoords(1) == min(video.height,max(1,maxCoords(1) + DIR_ROW(dir)))) & (maxCoords(2) == min(video.width ,max(1,maxCoords(2) + DIR_COL(dir))))
                            fprintf('distSum = %i\n', distSum);
                            fprintf('rowNum = %i\n', rowNum);
                            fprintf('colNum = %i\n', colNum);
                            fprintf('maxCoords(1) = %i\n', maxCoords(1));
                            fprintf('maxCoords(2) = %i\n', maxCoords(2));
                            fprintf('video.height = %i\n', video.height);
                            fprintf('video.width = %i\n', video.width);
                            fprintf('dir = %i\n', dir);
                            fprintf('DIR_ROW(dir) = %i\n', DIR_ROW(dir));
                            fprintf('DIR_COL(dir) = %i\n', DIR_COL(dir));
                            SAD = frame;
                            brightness = regionalMax;
                            edginess = regionalMin;
                            blurriness = Gdir;
                            return
                        end
                        
                        maxCoords(1) = min(video.height,max(1,maxCoords(1) + DIR_ROW(dir)));
                        maxCoords(2) = min(video.width ,max(1,maxCoords(2) + DIR_COL(dir)));
                    end
                    distSum = distSum + norm(maxCoords-minCoords);
                end
            end
        end
        blurrinessSum = blurrinessSum + (distSum / sum(cannyFrame(:)));
        toc
        %}
        
        %{
        % min based search
        tic
        distSum = 0;
        for rowNum = 1:video.height
            for colNum = 1:video.width
                if cannyFrame(rowNum, colNum)
                    maxRow = rowNum;
                    maxCol = colNum;
                    
                    maxRowLow = max(1,maxRow-1);
                    maxRowHigh = min(video.height,maxRow+1);
                    maxColLow = max(1,maxCol-1);
                    maxColHigh = min(video.width,maxCol+1);
                    nearArea = frame(maxRowLow:maxRowHigh, maxColLow:maxColHigh);
                    [maxVal, maxIdx] = max(nearArea(:));
                    while maxVal ~= frame(maxRow, maxCol)
                        offsetRowLow = maxRowLow-maxRow+2;
                        offsetRowHigh = maxRowHigh-maxRow+2;
                        offsetColLow = maxColLow-maxCol+2;
                        offsetColHigh = maxColHigh-maxCol+2;
                        maxs = nearArea(:) == maxVal;
                        if sum(maxs) ~= 1
                            [Gmag, Gdir] = imgradient(frame(offsetRowLow:offsetRowHigh, offsetColLow:offsetColHigh), 'Sobel');
                            deg2grad = abs(mod(ANGLES(offsetRowLow:offsetRowHigh, offsetColLow:offsetColHigh)-Gdir(1+maxRow-maxRowLow, 1+maxCol-maxColLow)-180,360)-180);
                            [maxVal, maxIdx] = min(deg2grad(:) ./ maxs);
                        end
                        rowOffsetArea = ROW_OFFSET(offsetRowLow:offsetRowHigh, offsetColLow:offsetColHigh);
                        colOffsetArea = COL_OFFSET(offsetRowLow:offsetRowHigh, offsetColLow:offsetColHigh);
                        maxRow = maxRow + rowOffsetArea(maxIdx);
                        maxCol = maxCol + colOffsetArea(maxIdx);
                    
                        maxRowLow = max(1,maxRow-1);
                        maxRowHigh = min(video.height,maxRow+1);
                        maxColLow = max(1,maxCol-1);
                        maxColHigh = min(video.width,maxCol+1);
                        nearArea = frame(maxRowLow:maxRowHigh, maxColLow:maxColHigh);
                        [maxVal, maxIdx] = max(nearArea(:));
                    end
                    
                    minRow = rowNum;
                    minCol = colNum;
                    
                    minRowLow = max(1,minRow-1);
                    minRowHigh = min(video.height,minRow+1);
                    minColLow = max(1,minCol-1);
                    minColHigh = min(video.width,minCol+1);
                    nearArea = frame(minRowLow:minRowHigh, minColLow:minColHigh);
                    [minVal, minIdx] = min(nearArea(:));
                    while minVal ~= frame(minRow, minCol)
                        offsetRowLow = minRowLow-minRow+2;
                        offsetRowHigh = minRowHigh-minRow+2;
                        offsetColLow = minColLow-minCol+2;
                        offsetColHigh = minColHigh-minCol+2;
                        mins = nearArea(:) == minVal;
                        if sum(mins) ~= 1
                            [Gmag, Gdir] = imgradient(frame(offsetRowLow:offsetRowHigh, offsetColLow:offsetColHigh), 'Sobel');
                            deg2grad = abs(mod(ANGLES(offsetRowLow:offsetRowHigh, offsetColLow:offsetColHigh)-Gdir(1+minRow-minRowLow, 1+minCol-minColLow)-180,360)-180);
                            [minVal, minIdx] = max(deg2grad(:) .* mins);
                        end
                        rowOffsetArea = ROW_OFFSET(offsetRowLow:offsetRowHigh, offsetColLow:offsetColHigh);
                        colOffsetArea = COL_OFFSET(offsetRowLow:offsetRowHigh, offsetColLow:offsetColHigh);
                        minRow = minRow + rowOffsetArea(minIdx);
                        minCol = minCol + colOffsetArea(minIdx);
                    
                        minRowLow = max(1,minRow-1);
                        minRowHigh = min(video.height,minRow+1);
                        minColLow = max(1,minCol-1);
                        minColHigh = min(video.width,minCol+1);
                        nearArea = frame(minRowLow:minRowHigh, minColLow:minColHigh);
                        [minVal, minIdx] = min(nearArea(:));
                    end
                    
                    distSum = distSum + hypot(maxRow-minRow, maxCol-minCol);
                end
            end
        end
        blurrinessSum = blurrinessSum + (distSum / sum(cannyFrame(:)));
        toc
        %}
        
        % just get the gradient
        %{
        tic
        [Gmag, Gdir] = imgradient(frame, 'Sobel');
        blurrinessSum = blurrinessSum + mean(Gmag(cannyFrame),'double');
        blurrinessTimes(n) = toc;
        %}
        
        %{
        numEdges = sum(cannyFrame(:));
        edgeDistances = zeros(1, numEdges);
        edgeNum = 1;
        regionalMax = imregionalmax(frame);
        regionalMin = imregionalmin(frame);
        maxSearchFrame = padarray(frame, [1,1], -Inf);
        minSearchFrame = padarray(frame, [1,1],  Inf);
        for rowNum = 1:video.height
            for colNum = 1:video.width
                if cannyFrame(rowNum, colNum)
                    % find local maxima
                    maxRow = rowNum
                    maxCol = colNum
                    while ~regionalMax(maxRow, maxCol)
                        currWindow = maxSearchFrame(maxRow:maxRow+2,maxCol:maxCol+2);
                        [maxVal,maxIdx] = max(currWindow(CLOCKWISE_SEARCH));   % search clockwise
                        maxRow = maxRow + ROW_OFFSET(maxIdx);
                        maxCol = maxCol + COL_OFFSET(maxIdx);
                        CLOCKWISE_SEARCH = circshift(CLOCKWISE_SEARCH,3-maxIdx);
                        ROW_OFFSET = circshift(ROW_OFFSET,3-maxIdx);
                        COL_OFFSET = circshift(COL_OFFSET,3-maxIdx);
                    end
                    
                    % find local minima
                    minRow = rowNum;
                    minCol = colNum;
                    while ~regionalMin(minRow, minCol)
                        currWindow = minSearchFrame(minRow:minRow+2,minCol:minCol+2);
                        [minVal,minIdx] = min(currWindow(CLOCKWISE_SEARCH));   % search clockwise
                        minRow = minRow + ROW_OFFSET(minIdx);
                        minCol = minCol + COL_OFFSET(minIdx);
                        CLOCKWISE_SEARCH = circshift(CLOCKWISE_SEARCH,3-minIdx);
                        ROW_OFFSET = circshift(ROW_OFFSET,3-minIdx);
                        COL_OFFSET = circshift(COL_OFFSET,3-minIdx);
                    end
                    
                    % append the distance between the maxima and minima to the list
                    edgeDistances(edgeNum) = hypot(maxRow-minRow, maxCol-minCol);
                    edgeNum = edgeNum + 1;
                end
            end
        end
        blurrinessSum = mean(edgeDistances);
        %}
        frameIdx = frameIdx + 1;
    end
    
    SAD = SADsum / SADcount;
    brightness = brightnessSum / (frameIdx - 1);
    edginess = edginessSum / frameIdx;
    blurriness = blurrinessSum / frameIdx;
    
    fprintf('Avg SAD time = %f\n', mean(SADtimes));
    fprintf('Avg brightness time = %f\n', mean(brightnessTimes));
    fprintf('Avg edginess time = %f\n', mean(edginessTimes));
    fprintf('Avg blurriness time = %f\n', mean(blurrinessTimes));
end
