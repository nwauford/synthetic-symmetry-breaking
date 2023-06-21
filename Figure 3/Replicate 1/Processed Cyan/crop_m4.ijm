for (i=1; i<65; i++) {	
open("/Users/noreen/Library/Mobile Documents/com~apple~CloudDocs/Documents/MIT/Weiss Lab/microscopy/cnw1m4-d4 analysis/Processed Cyan/" + d2s(i, 0) + "cyr.jpg");
makeRectangle(167, 0, 936, 880);
run("Crop");
saveAs("Jpeg", "/Users/noreen/Library/Mobile Documents/com~apple~CloudDocs/Documents/MIT/Weiss Lab/microscopy/cnw1m4-d4 analysis/Processed Cyan/" + d2s(i, 0)  + "cyr_crop.jpg");
close();
}
