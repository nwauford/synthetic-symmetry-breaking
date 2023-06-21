cwd = getDir("cwd");
for (i=1; i<65; i++) {	
open(d2s(i, 0) + "b.png");
run("Cyan");
setMinAndMax(34, 156);
run("RGB Color");
saveAs("Png", cwd + d2s(i, 0)  + "c.png");

open( d2s(i, 0)  + "r.png");
setMinAndMax(49, 181);
run("RGB Color");
saveAs("Png", cwd + d2s(i, 0)  + "r.png");

open(d2s(i, 0) + "y.png");
setMinAndMax(36, 164);
run("RGB Color");
saveAs("Png", cwd + d2s(i, 0)  + "y.png");
run("Merge Channels...", "c1=" + d2s(i, 0)  + "r.png c5=" + d2s(i, 0)  + "c.png c7=" + d2s(i, 0)  + "y.png create");
saveAs("Png", cwd + d2s(i, 0)  + "cyr.png");

close();
}
