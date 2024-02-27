//script to mask bones (remove stuff around the bone) for histogram measurements etc

dir_in = getDirectory("Source Directory: ");
dir_out = getDirectory("Processed Directory: ");
list_in = getFileList(dir_in);

setBatchMode(true);
for (i = 0; i<list_in.length; i++) {
	loadfile = dir_in+list_in[i];
	open(loadfile);
	img1 = getTitle();
	run("Median 3D...", "x=1 y=1 z=1");
	//setThreshold(6200, 65535, "raw"); //unscaled bones
	setThreshold(17500, 65535, "raw"); //scaled bones
	setOption("BlackBackground", false);
	run("Convert to Mask", "method=Default background=Dark black create");
	run("Fill Holes (Binary/Gray)");
	run("Erode (3D)", "iso=255");
	run("Erode (3D)", "iso=255");
	run("Erode (3D)", "iso=255");
	run("Dilate (3D)", "iso=255");
	run("Dilate (3D)", "iso=255");
	run("Dilate (3D)", "iso=255");
	run("Connected Components Labeling", "connectivity=26 type=[16 bits]");
	run("Keep Largest Label");
	run("Divide...", "value=255 stack");
	img2 = getTitle();
	selectWindow(img1);
	resetThreshold();
	imageCalculator("Multiply create stack", img1, img2);
	saveAs("tiff", dir_out+substring(list_in[i],0,list_in[i].length-4)+"_masked.tif");
	run("Close");
	run("Collect Garbage");
}