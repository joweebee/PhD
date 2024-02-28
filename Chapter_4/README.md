## Chapter 4: Improving Mechanical Stability - Cell Response to Crosslinked Scaffolds

# 4.2.1: Immunofluorescent Staining and Analysis

A workflow was developed to most efficiently process the RGB Z-stacks produced by Zeiss Zen, whilst retaining image quality:
1. Use Zen to set channel levels, then batch export as OME.TIFF, keeping the levels set for each channel.
2. Use [OME2PNG.ijm](https://github.com/joweebee/PhD/blob/main/Chapter_4/OME2PNG.ijm), which is an ImageJ macro written to flatten a folder of TIFF files into .PNG files, adding scale bars for publication. This is better quality than doing it from within Zen.
