% {intensity_threshold, channel filename character}
y_param = {0.12, 'y'};
r_param = {0.07, 'r'};
area_thresh = 400;
num_doses = 64; 

usrC = strsplit(pwd,'/');
fex_code_path = ['/Users/' usrC{3} '/Documents/MIT/Weiss Lab/microscopy/cbrewer'];
addpath(genpath(fex_code_path))

dirs = {'analysis_images/'};

if ~exist('data.mat')
        out_y = clust_stats(y_param, num_doses, area_thresh, dirs);
        out_r = clust_stats(r_param, num_doses, area_thresh, dirs);
        data = {out_y, out_r};
        save('data','data')
else 
    load('data.mat')
    out_y = data{1};
    out_r = data{2};
end

numClustArray = out_y{1};
    areaClustArray = out_y{2};
    
    % show heat maps of array with image(<Array>)
    fig = figure('Position', [525 1 563 804]);
    t = tiledlayout(2,1,'TileSpacing','Compact');
    title(t, ['Y m4 3-reps'])
   
    nexttile;
    h = heatmap(numClustArray, 'CellLabelColor','none');
    h.GridVisible = 'off';
    colormap viridis
    title("Avg. Number Clusters")
    caxis([0 5])
    colorbar
    
    nexttile;
    h = heatmap(areaClustArray, 'CellLabelColor','none');
    h.GridVisible = 'off';
    colormap viridis
    title("Avg. Area Clusters (sq. uM)")
    caxis([0 5e4])
    colorbar

    saveas(t, "Y-heatmaps-litvalues.png");
    
    numClustArray = out_r{1};
    areaClustArray = out_r{2};
    
    fig = figure('Position', [525 1 563 804]);
    t = tiledlayout(2,1,'TileSpacing','Compact');
    title(t, ['R m4 3-reps'])
    
    nexttile;
    h = heatmap(numClustArray, 'CellLabelColor','none');
    colormap viridis
    h.GridVisible = 'off';
    title("Avg. Number Clusters")
    caxis([0 5])
    colorbar
    
    nexttile;
    h = heatmap(areaClustArray, 'CellLabelColor','none');
    colormap viridis
    h.GridVisible = 'off';
    title("Avg. Area Clusters (sq. uM)")
    caxis([0 5e4])
    colorbar

    saveas(t, "R-heatmaps-litvalues.png");


function out = clust_stats(chan_param, num_doses, area_thresh, dirs)
    intens_tresh = chan_param{1,1};
    chan = chan_param{1,2};
    
    % data structures formatted as 64 wells X channel

    [numClusters, areaClusters, malClusters] = deal(zeros(64,1));
    
    
    for d = 1:length(dirs)
       
        %parpool(3);
        for f = 1:num_doses
            
            fName = [dirs{d} 'clustered_' chan '_' num2str(f) '.png'];
            fprintf("Processing %s \n", fName)

            I = imread(fName);

            [labeled, num] = bwlabel(I);

            numClusters(f, 1) = numClusters(f, 1) + num;
            stats = regionprops(I, "Area", "MajorAxisLength");
            areaClusters(f, 1) = areaClusters(f, 1) + sum([stats(:).Area]).*.62;

           
            
        end
    end

    avg_areaClusters = areaClusters./numClusters;
    avg_malClusters = malClusters./numClusters;

    idx = 1;
    numClustArray = reshape(numClusters(:, idx), [8 8])' ./ 3;
   
    areaClustArray = reshape(avg_areaClusters(:, idx), [8 8])' ./ 3;
    areaClustArray(isnan(areaClustArray)) = 0;
    
    out{1} = numClustArray;
    out{2} = areaClustArray;
end
    
    


