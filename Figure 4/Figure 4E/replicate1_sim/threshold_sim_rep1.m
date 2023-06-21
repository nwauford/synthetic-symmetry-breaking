numClusters = zeros(64,2);
if ~exist('data_sim1.mat')
    for i = 1:64
        if i < 11
            I = imread(['R_channel/sim_00' num2str(i - 1) '_cropped_1.png']);
        else
            I = imread(['R_channel/sim_0' num2str(i - 1) '_cropped_1.png']);
        end
%         figure('position',[31 230 643 561]);  
%         imshow(I);
        I = rgb2gray(I);
        BW = imbinarize(I, .07);
        Icropped = imcrop(BW, [0 0 1360 880]);
        BW2 = bwareafilt(Icropped,[1200 Inf]);
        [labeled, num] = bwlabel(BW2);
        numClusters(i, 1) = num;
%         figure('position',[697 227 708 554]);
%         imshow(labeled)

        imwrite( labeled, ['clustered_r_' num2str(i) '.png'])


       if i < 11
            I = imread(['Y_channel/sim_00' num2str(i - 1) '_cropped_2.png']);
        else
            I = imread(['Y_channel/sim_0' num2str(i - 1) '_cropped_2.png']);
       end
%         figure('position',[31 230 643 561]);  
%         imshow(I);
        I = rgb2gray(I);
        BW = imbinarize(I, .165);
        Icropped = imcrop(BW, [0 0 1360 880]);
        BW2 = bwareafilt(Icropped,[600 Inf]);
        [labeled, num] = bwlabel(BW2);
        numClusters(i, 2) = num;
%         figure('position',[697 227 708 554]);
%         imshow(labeled)
        imwrite( labeled, ['clustered_y_' num2str(i) '.png'])
    end
    save('data_sim1.mat', 'numClusters')
else
    load('data_sim1.mat')
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

% numClusters