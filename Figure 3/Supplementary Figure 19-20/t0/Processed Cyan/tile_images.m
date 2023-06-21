usrC = strsplit(pwd,'/');
data_path = ['/Users/' usrC{3} '/Documents/MIT/Weiss Lab/microscopy/cnw1m4-d4 analysis/Processed cNW1m4/'];

% myFiles = dir(fullfile(data_path,'*.jpg'));
% length(myFiles)
f = {};
 for s = 1:24
     f{length(f) + 1} = [num2str(s), 'cyr.png'];
 end
out = imtile(f, 'GridSize', [4 6]);
imshow(out);
