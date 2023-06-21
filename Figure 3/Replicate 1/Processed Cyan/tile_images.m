usrC = strsplit(pwd,'/');
data_path = ['/Users/' usrC{3} '/Documents/MIT/Weiss Lab/microscopy/cnw1m4-d4 analysis/Processed cNW1m4/'];

% myFiles = dir(fullfile(data_path,'*.jpg'));
% length(myFiles)
f = {};
 for s = 1:64
     f{length(f) + 1} = ['Processed Cyan/',num2str(s), 'cyr_noscale.jpg'];
 end
out = imtile(f, 'GridSize', [8 8]);
imshow(out);
