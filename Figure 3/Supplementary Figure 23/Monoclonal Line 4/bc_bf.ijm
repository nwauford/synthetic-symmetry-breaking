for (i=53; i<65; i++) {	
open("/Users/noreen/Documents/MIT/Weiss Lab/microscopy/cnw1m3-d4 analysis/" + d2s(i, 0) + "f.jpg");
setMinAndMax(0, 114);
run("Apply LUT");
saveAs("Tiff", "/Users/noreen/Documents/MIT/Weiss Lab/microscopy/cnw1m3-d4 analysis/Processed brightfield/" + d2s(i, 0)  + "f-bc.tiff");
close();
}
