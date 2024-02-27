# Chapter 5: Determining the Efficacy of a Novel Ex-Vivo Model for Bone Healing

## 5.2.4.2: uCT Reconstruction
Due to misalignment of the Skyscan instrument filters and ageing of the source and detector, the brightness of the images collected changed across the scan height. This meant that the numerical density data collected from a sample at the top of a tube was not directly comparable with a sample from the bottom of a scan tube. To correct for this, a [contrast.py](https://github.com/joweebee/PhD/blob/main/Chapter_5/contrast.py) was written, which sampled the ‘background colour’ at the edges of each 2D scan image, and increased the brightness of every pixel in the image so that the background would average to be white (brightness = 255). 

## 5.4.2:	Density Calibration Against Hydroxyapatite Phantom
uCT Reconstructions were processed using ImageJ to produce histograms representing the density of each femoral scan:
- [JB_mask_bones.ijm](https://github.com/joweebee/PhD/blob/main/Chapter_5/JB_mask_bones.ijm) is an ImageJ macro (written by Dr Julia Behnsen) to mask out the material surrounding the femora for histogram calculations.
- [histo16bit_dir.ijm](https://github.com/joweebee/PhD/blob/main/Chapter_5/histo16bit_dir.ijm) is an ImageJ macro (written by Dr Julia Behnsen) which calculates the histogram for every 16 bit TIF stack in a directory and outputs to a .csv file.

## 5.4.3:	Segmentation and Quantitative Analysis
- [XCT-Segment-Measure.ijm](https://github.com/joweebee/PhD/blob/main/Chapter_5/XCT-Segment-Measure.ijm) is an ImageJ macro which segments every .TIF stack in a directory using a pre-trained LabKit classifier file, measures the 3D regions in each segment with MorpholibJ, and outputs the results to a .csv file.
- [compile_morpho.m](https://github.com/joweebee/PhD/blob/main/Chapter_5/compile_morpho.m) is a MATLAB script which compiles the individual .csv results files in a directory into one .xlsx file, renames the sample according to [the sample key](https://github.com/joweebee/PhD/blob/main/Chapter_5/FinalExp-Key.xlsx), renames the labels to represent the tissue types, and calculates averages and standard deviations per scaffold.
- [XCTStats2Prism.m](https://github.com/joweebee/PhD/blob/main/Chapter_5/XCTStats2Prism.m) is a MATLAB script which takes the output .xlsx file from [compile_morpho.m](https://github.com/joweebee/PhD/blob/main/Chapter_5/compile_morpho.m) and formats the data for easy importing into GraphPad Prism.
