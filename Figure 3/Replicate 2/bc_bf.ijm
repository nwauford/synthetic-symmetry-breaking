for (i=1; i<65; i++) {	
open("/Users/noreen/Documents/MIT/Weiss Lab/microscopy/cnw1-m4-rep4-d4/" + d2s(i, 0) + "f.png");
run("Enhance Contrast", "saturation=0.35");
run("Apply LUT");
saveAs("Tiff", "/Users/noreen/Documents/MIT/Weiss Lab/microscopy/cnw1-m4-rep4-d4/Processed brightfield/" + d2s(i, 0)  + "f-bc.tiff");
close();
}
