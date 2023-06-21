usrC = strsplit(pwd,'/');
data_path = ['/Users/' usrC{3} '/Documents/MIT/Weiss Lab/microscopy/cnw1-m4-rep3-d4/Processed/'];

% myFiles = dir(fullfile(data_path,'*.jpg'));
% length(myFiles)
f = {};
 for s = 1:64
     f{length(f) + 1} = ['Processed cNW1m6/',num2str(s), 'byr.jpg'];
 end
out = imtile(f, 'GridSize', [8 8]);
imshow(out);
