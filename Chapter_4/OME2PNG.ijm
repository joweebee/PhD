   // Use Zen to set channel levels then export as OME.TIFF, keeping the levels you set. Then use this script to produce TIFF files with scale bars for publication. This is better quality than doing it from within Zen.
   
   requires("1.33s"); 
   dir = getDirectory("Choose a Directory ");
   setBatchMode(true);
   folder2 = dir + "/" + "processed";
   File.makeDirectory(folder2);
   count = 0;
   //print("Counting Files"); 
   countFiles(dir);
   n = 0;
   run("Text Window...", "name=[Progress] width=120 height=2");
   run("Text Window...", "name=[Status] width=120 height=2");

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
  	   //print("Processing"); 
       if (endsWith(path, ".ome.tiff")) { //Only open OME.TIFF files in the folder.
           open(path);
              //print("Opening"); 
           thisimage=getTitle();
           filepath=getDirectory("image"); 
			print("[Progress]", "\\Update:Processing image: " + thisimage + " (" +n + " of " + count + ")");
			
			
			selectWindow(thisimage);
			run("Remove Outliers...", "radius=2 threshold=50 which=Bright stack");
			run("Deinterleave", "how=3 keep");
			blue = thisimage+" #1"; 
			green = thisimage+" #2"; 
			red = thisimage+" #3"; 
			run("Merge Channels...", "c1=[" + red + "] c2=[" + green + "] c3=[" + blue +"]");
			run("Set Scale...", "distance=16.0906 known=1 unit=micron global");
			run("Scale Bar...", "width=50 height=48 thickness=48 font=72 color=White background=None location=[Lower Right] horizontal bold"); 
			//save image 
			Image_out = filepath + "processed/" + thisimage; 
			Image_out = replace(Image_out, "ome.tiff","png"); 
			print("[Status]", "\\Update:Saving image: " + Image_out); 
			saveAs ("png", Image_out); 
			run("Close All"); 
       }
			else{
				thisimage=getTitle();
				print("[Status]", "\\Update:Image not correct format: " + thisimage); 
      }
  }
