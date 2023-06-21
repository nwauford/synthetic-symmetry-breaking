for (i=1; i<65; i++) {	
open("/Users/noreen/Library/Mobile Documents/com~apple~CloudDocs/Documents/MIT/Weiss Lab/microscopy/cnw1m4-d4 analysis/Processed Cyan/" + d2s(i, 0) + "cyr.jpg");
makeRectangle(36, 877, 515, 32);
run("Colors...", "foreground=black background=black selection=yellow");
run("Fill", "slice");
saveAs("Jpeg", "/Users/noreen/Library/Mobile Documents/com~apple~CloudDocs/Documents/MIT/Weiss Lab/microscopy/cnw1m4-d4 analysis/Processed Cyan/" + d2s(i, 0)  + "cyr_noscale.jpg");
close();
}
