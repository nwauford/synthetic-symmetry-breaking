for (i=1; i<25; i++) {	
open("/Users/noreen/Library/Mobile Documents/com~apple~CloudDocs/Documents/MIT/Weiss Lab/microscopy/cnw1m4 timepoints 2/t48/" + d2s(i, 0) + "b.png");
run("Cyan");
setMinAndMax(41, 112);
run("RGB Color");
saveAs("Png", "/Users/noreen/Library/Mobile Documents/com~apple~CloudDocs/Documents/MIT/Weiss Lab/microscopy/cnw1m4 timepoints 2/t48/Processed Cyan/" + d2s(i, 0)  + "c.png");
//close();
open("/Users/noreen/Library/Mobile Documents/com~apple~CloudDocs/Documents/MIT/Weiss Lab/microscopy/cnw1m4 timepoints 2/t48/" + d2s(i, 0)  + "r.png");
setMinAndMax(39, 174);
run("RGB Color");
saveAs("Png", "/Users/noreen/Library/Mobile Documents/com~apple~CloudDocs/Documents/MIT/Weiss Lab/microscopy/cnw1m4 timepoints 2/t48/Processed Cyan/" + d2s(i, 0)  + "r.png");
//close();
open("/Users/noreen/Library/Mobile Documents/com~apple~CloudDocs/Documents/MIT/Weiss Lab/microscopy/cnw1m4 timepoints 2/t48/" + d2s(i, 0) + "y.png");
setMinAndMax(22, 114);
run("RGB Color");
saveAs("Png", "/Users/noreen/Library/Mobile Documents/com~apple~CloudDocs/Documents/MIT/Weiss Lab/microscopy/cnw1m4 timepoints 2/t48/Processed Cyan/" + d2s(i, 0)  + "y.png");
run("Merge Channels...", "c1=" + d2s(i, 0)  + "r.png c5=" + d2s(i, 0)  + "c.png c7=" + d2s(i, 0)  + "y.png create");
saveAs("Png", "/Users/noreen/Library/Mobile Documents/com~apple~CloudDocs/Documents/MIT/Weiss Lab/microscopy/cnw1m4 timepoints 2/t48/Processed Cyan/" + d2s(i, 0)  + "cyr.png");

close();
}
