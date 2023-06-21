for (i=1; i<3; i++) {	
open("/Users/noreen/Library/Mobile Documents/com~apple~CloudDocs/Documents/MIT/Weiss Lab/microscopy/cnw1m6-d4 analysis/" + d2s(i, 0) + "b.jpg");
run("32-bit");

setMinAndMax(13, 35);
run("Cyan");
run("RGB Color");
saveAs("Png", "/Users/noreen/Library/Mobile Documents/com~apple~CloudDocs/Documents/MIT/Weiss Lab/microscopy/cnw1m6-d4 analysis/Processed Cyan/" + d2s(i, 0)  + "c.png");

open("/Users/noreen/Library/Mobile Documents/com~apple~CloudDocs/Documents/MIT/Weiss Lab/microscopy/cnw1m6-d4 analysis/" + d2s(i, 0)  + "r.jpg");
setMinAndMax(16, 238);
run("RGB Color");
saveAs("Png", "/Users/noreen/Library/Mobile Documents/com~apple~CloudDocs/Documents/MIT/Weiss Lab/microscopy/cnw1m6-d4 analysis/Processed Cyan/" + d2s(i, 0)  + "r.png");

open("/Users/noreen/Library/Mobile Documents/com~apple~CloudDocs/Documents/MIT/Weiss Lab/microscopy/cnw1m6-d4 analysis/" + d2s(i, 0) + "y.jpg");
setMinAndMax(13, 130);
run("RGB Color");
saveAs("Png", "/Users/noreen/Library/Mobile Documents/com~apple~CloudDocs/Documents/MIT/Weiss Lab/microscopy/cnw1m6-d4 analysis/Processed Cyan/" + d2s(i, 0)  + "y.png");

run("Merge Channels...", "c1=" + d2s(i, 0)  + "r.png c5=" + d2s(i, 0)  + "c.png c7=" + d2s(i, 0)  + "y.png create");
saveAs("Png", "/Users/noreen/Library/Mobile Documents/com~apple~CloudDocs/Documents/MIT/Weiss Lab/microscopy/cnw1m6-d4 analysis/Processed Cyan/" + d2s(i, 0)  + "cyr.png");

close();
}
