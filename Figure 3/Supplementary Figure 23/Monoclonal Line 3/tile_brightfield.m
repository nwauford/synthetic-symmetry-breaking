
f = {};
 for s = 1:64
     if s == 8
        f{length(f) + 1} = [num2str(s), 'f.png']; 
     else
        f{length(f) + 1} = [num2str(s), 'f.jpg'];
     end
     
 end
out = imtile(f, 'GridSize', [8 8]);
imshow(out);
