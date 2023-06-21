usrC = strsplit(pwd,'/');
data_path = ['/Users/' usrC{3} '/Documents/MIT/Weiss Lab/microscopy/cnw1m3-d4 analysis/Processed cNW1m3/'];

% myFiles = dir(fullfile(data_path,'*.jpg'));
% length(myFiles)
f = {};
 for s = 1:64
%      f{length(f) + 1} = ['Processed cNW1m3/',num2str(s), 'byr.jpg'];
     f{length(f) + 1} = [num2str(s), 'f.jpg'];
 end
out = imtile(f, 'GridSize', [8 8]);
imshow(out);
