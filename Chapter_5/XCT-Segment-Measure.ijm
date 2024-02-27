// 
   requires("1.54h"); 
   dir = getDirectory("Choose a Directory ");
   
   setBatchMode(false);
   folder2 = dir + "/" + "segmented";
   File.makeDirectory(folder2);
   count = 0;
   countFiles(dir);
   n = 0;
   run("Text Window...", "name=[Progress] width=60 height=2");
   run("Text Window...", "name=[Status] width=60 height=2");
   processFiles(dir);
   //print(count+" files processed");
   
   function countFiles(dir) {
      list = getFileList(dir);
      for (i=0; i<list.length; i++) {
          if (endsWith(list[i], "/"))
              countFiles(""+dir+list[i]);
          else
              count++;
      }
  }

   function processFiles(dir) {
      list = getFileList(dir);
      for (i=0; i<list.length; i++) {
          if (endsWith(list[i], "/"))
              processFiles(""+dir+list[i]);
          else {
             showProgress(n++, count);
             path = dir+list[i];
             processFile(path);
          }
      }
  }

  function processFile(path) {
       if (endsWith(path, ".tif")) { //Only open tif files in the folder.
           open(path);
           print("[Status]", "\\Update:Opening file: " + path); 
           thisimage=getTitle();
           filepath=getDirectory("image"); 
print("[Progress]", "\\Update:Processing bone: " + thisimage + " (" +n + " of " + count + ")");

//Segment with labkit:
print("[Status]", "\\Update:Segmenting image: " + thisimage); 
selectWindow(thisimage);

// Choose a line to comment out to choose the segmenter_file:
segmenter_file_path = "F:\\Sectioned Bone Scans All June 23\\Manual\\3segmentbone.classifier"
//segmenter_file_path = "F:\\Sectioned Bone Scans All June 23\\Manual\\stainedbone-4segments.classifier"

run("Segment Image With Labkit", "input=" + thisimage + " segmenter_file=[" + segmenter_file_path + "] use_gpu=true");
selectImage("segmentation of " + thisimage);
setMinAndMax(0, 2);

//save image 
Image_out = filepath + "segmented/seg-" + thisimage; 
print("[Status]", "\\Update:Saving image: " + Image_out); 
saveAs("Tiff", Image_out);
run("Close All");

// Adjust Pixel Values to give ALL labels
open(Image_out);
for (i=1; i<=nSlices; i++) {
    setSlice(i);
	changeValues(0,0,255); // 255 = Bone
	changeValues(1,1,128); // 128 = Cartilage
	changeValues(2,2,0); // 0 = PS
	changeValues(3,3,10); // 10 = Wrap

// Measure in 3D with MorpholibJ:
print("[Status]", "\\Update:Measuring regions in image: " + thisimage);
run("Analyze Regions 3D", "voxel_count surface_area_method=[Crofton (13 dirs.)] euler_connectivity=6");
print("[Status]", "\\Update:saving MorpholibJ results for image: " + thisimage);
Image_out = replace(Image_out, ".tif","-morpho.csv"); 
saveAs("Results", Image_out);
run("Close All"); 

// clear memory before repeat:
print("[Status]", "\\Update:Clearing RAM");
run("Collect Garbage");
call("java.lang.System.gc");

      }
  }
print("[Progress]", "\\Update:Finished processing " + n + " files!");