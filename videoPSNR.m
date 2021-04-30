function [avgPSNR] = videoPSNR(ALTERED_VIDEO_PATH, REFERENCE_VIDEO_PATH)
    %VIDEOPSNR Calculate PSNR for each frame in the videos and return the average PSNR.
    
    alteredVideo = VideoReader(ALTERED_VIDEO_PATH);
    referenceVideo = VideoReader(REFERENCE_VIDEO_PATH);
    
    frameIdx = 0;
    PSNRsum=0;
    while hasFrame(referenceVideo) && hasFrame(alteredVideo)
        referenceFrame = rgb2ycbcr(readFrame(referenceVideo));
        alteredFrame = rgb2ycbcr(readFrame(alteredVideo));
        PSNRsum = PSNRsum + psnr(alteredFrame, referenceFrame);
        frameIdx = frameIdx + 1;
    end
    
    avgPSNR = PSNRsum / (frameIdx + 1);
end
