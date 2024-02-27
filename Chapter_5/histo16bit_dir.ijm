//saves a table of the 16-bit histogram of a 16-bit image

//setBatchMode(true); Does not seem to work - only gets histogram for 1st slice in batch mode
dir_in = getDirectory("Image Directory: ");
dir_out = getDirectory("Results out directory: ");
list_in = getFileList(dir_in);

for (j = 0; j<list_in.length; j++) {
	showProgress(j+1, list_in.length);
	open(dir_in+list_in[j]);
	setBatchMode(true); // seems fine to do here
	histo_16();
	setBatchMode(false);
	saveAs("Results", dir_out+list_in[j]+"_histo.csv");
	close();
}

function histo_16() {
	nbins = 256;
	hmin = 0;
	hmax = 65535;
	counts_sum = newArray(nbins);

	setMinAndMax(0, 65535);
	call("ij.ImagePlus.setDefault16bitRange", 16);
	
	for (slice =1; slice <=nSlices; slice++) {
		if (nSlices > 1) run ("Set Slice...", "slice="+slice);
		run("Duplicate...", "title=tmp");
		run("32-bit");
		getHistogram(values, counts, nbins, hmin, hmax);
		close();
		for (i = 0; i < nbins; i++) {
			counts_sum[i] = counts_sum[i] + counts[i];
		}
	}

	run("Clear Results");
	for (i = 0; i < nbins; i++) {
		setResult("Bin start", i, values[i]);
		setResult("Counts", i, counts_sum[i]);
	}
	updateResults();
}
