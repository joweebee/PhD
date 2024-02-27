# Chapter 5: Determining the Efficacy of a Novel Ex-Vivo Model for Bone Healing

## 5.2.4.2: uCT Reconstruction
Due to misalignment of the Skyscan instrument filters and ageing of the source and detector, the brightness of the images collected changed across the scan height. This meant that the numerical density data collected from a sample at the top of a tube was not directly comparable with a sample from the bottom of a scan tube. To correct for this, a [contrast.py](https://github.com/joweebee/PhD/blob/main/Chapter_5/contrast.py) was written, which sampled the ‘background colour’ at the edges of each 2D scan image, and increased the brightness of every pixel in the image so that the background would average to be white (brightness = 255). 
