
f = {};
 for s = 1:64
     f{length(f) + 1} = [num2str(s), 'f-bc-auto.tiff'];
 end
out = imtile(f, 'GridSize', [8 8]);
imshow(out);
