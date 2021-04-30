load('VideoParameters.mat')

figure;

method = 'average';
metric = 'euclidean';
%selection = [1:23];
selection = [1:2 4:12 14 17:20 22:23];
numCategories=4;

Z = linkage(zscore([SAD(selection)', brightness(selection)', edginess(selection)', blurriness(selection)']), method, metric);
hDend = dendrogram(Z, 'Labels', names(selection), 'ColorThreshold', mean([Z(end-(numCategories-1),3) Z(end-(numCategories-2),3)]));

colors = [0,0,0];
lineHandles = [];
for lineNum=1:length(hDend)
    addColor = true;
    for colorNum=1:size(colors,1)
        if all(hDend(lineNum).Color == [0 1 1])
            hDend(lineNum).Color = [0 0 1];
        end
        if all(hDend(lineNum).Color == [.5 1 0])
            hDend(lineNum).Color = [0 1 0];
        end
        if all(hDend(lineNum).Color == colors(colorNum,:))
            hDend(lineNum).HandleVisibility = 'off';
            addColor = false;
            break
        end
    end
    if addColor
        colors = [colors; hDend(lineNum).Color];
        lineHandles = [lineHandles hDend(lineNum)];
    end
end

legend(lineHandles([1,3,2,4]), 'Group 1', 'Group 2', 'Group 3', 'Group 4');
ylabel('Euclidean Mean Z-Score Distance')

xtickangle(45);
title('Test Video Clustering');

% % line at second split
% hline = refline([0 Z(end-1,3)]);
% hline.Color = [0 .5 .5];
% hline.LineStyle = '--';
% hline.HandleVisibility = 'off';
% 
% % line at third split
% hline = refline([0 Z(end-2,3)]);
% hline.Color = [0 .5 .5];
% hline.LineStyle = '--';
% hline.HandleVisibility = 'off';
% 
% % line at fourth split
% hline = refline([0 Z(end-3,3)]);
% hline.Color = [0 .5 .5];
% hline.LineStyle = '--';
% hline.HandleVisibility = 'off';
% 
% % mark lines on axis
% newYTicks = [zeros(1,numCategories), get(gca, 'YTick')];
% for idx = 0:numCategories-1
%     newYTicks(idx+1) = Z(end-idx,3);
% end
% set(gca, 'YTick', sort(newYTicks));

clear lineHandles hDend method metric selection numCategories Z hline newYTicks idx;
