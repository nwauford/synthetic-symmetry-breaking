for (i=1; i<65; i++) {	
open("/Users/noreen/Documents/MIT/Weiss Lab/microscopy/cnw1m4-d4 analysis/" + d2s(i, 0) + "f.jpg");
run("Enhance Contrast", "saturation=0.35");
run("Apply LUT");
saveAs("Tiff", "/Users/noreen/Documents/MIT/Weiss Lab/microscopy/cnw1m4-d4 analysis/Processed brightfield/" + d2s(i, 0)  + "f-bc.tiff");
//close();
}
