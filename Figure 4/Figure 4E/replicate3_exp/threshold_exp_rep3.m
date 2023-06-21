numClusters = zeros(64,2);
if ~exist('data_r3.mat')
    for i = 1:64
        I = imread([num2str(i) 'r.png']);
%         figure('position',[31 230 643 561]);  
%         imshow(I);    
        I = rgb2gray(I);
        BW = imbinarize(I, .095);
        BW2 = bwareafilt(BW,[1200 Inf]);
        [labeled, num] = bwlabel(BW2);
        numClusters(i, 1) = num;
%         figure('position',[697 227 708 554]);
%         imshow(labeled)

        I = imread([num2str(i) 'y.png']);
%         figure('position',[31 230 643 561]);  
%         imshow(I);    
        I = rgb2gray(I);
        BW = imbinarize(I, .185);
        BW2 = bwareafilt(BW,[1200 Inf]);
        [labeled, num] = bwlabel(BW2);
        numClusters(i, 2) = num;
%         figure('position',[697 227 708 554]);
%         imshow(labeled)
        
    end
    save('data_r3.mat', 'numClusters')
else
    error()
    load('data_r3.mat')
end

 redArr = reshape(numClusters(:, 1), [8 8])
 redArr = redArr';
redArr = redArr .* (256 / max(numClusters(:, 1))); 
yArr = reshape(numClusters(:, 2), [8 8]);
yArr = yArr';
yArr = yArr .* (256 / max(numClusters(:, 2))); 

figure;
image(redArr)
colormap viridis
caxis([0 5])
title('Red cluster numbers');

figure;
image(yArr)
colormap viridis
caxis([0 5])
title('Yellow cluster numbers');

numClusters