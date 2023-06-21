cwd = getDir("cwd") ;
for (i=1; i<65; i++) {	
open( d2s(i, 0) + "b.jpg");
run("32-bit");
setMinAndMax(14, 38);

run("Cyan");
run("RGB Color");
saveAs(cwd + "Processed Cyan/" + d2s(i, 0)  + "c.jpg");
open( d2s(i, 0)  + "r.jpg");
setMinAndMax(49, 223);
run("RGB Color");
saveAs(cwd + "Processed Cyan/" + d2s(i, 0)  + "r.jpg");
open(d2s(i, 0) + "y.jpg");
setMinAndMax(36, 131);
run("RGB Color");
saveAs("Png", cwd + "Processed Cyan/" + d2s(i, 0)  + "y.jpg");
run("Merge Channels...", "c1=" + d2s(i, 0)  + "r.jpg c5=" + d2s(i, 0)  + "c.jpg c7=" + d2s(i, 0)  + "y.jpg create");
saveAs("Jpg", cwd + "Processed Cyan/" + d2s(i, 0)  + "cyr.jpg");

close();
}
