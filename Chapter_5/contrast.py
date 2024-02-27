import os
import cv2 as cv
import numpy as np
import shutil

# List all subdirectories using scandir()
sourcefolder = 'Femora'
destination = 'Adjusted'

with os.scandir(sourcefolder + '/') as folders:
    for folder in folders:
        if folder.is_dir():
            day = folder.name
            with os.scandir(sourcefolder + '/' + folder.name) as files:
                for file in files:
                    if file.is_file() and "tif" not in file.name:
                        print("Copying file " + file.name)
                        os.makedirs(os.path.dirname(destination + '/' + folder.name + '/' + file.name), exist_ok=True)
                        shutil.copyfile(sourcefolder + '/' + folder.name + '/' + file.name, destination + '/' + folder.name + '/' + file.name)

                    if file.is_file() and "tif" in file.name:
                        print("Adjusting file " + file.name)  
                        img = cv.imread(sourcefolder + '/' + folder.name + '/' + file.name, cv.IMREAD_GRAYSCALE)
                        # check img.shape here
                        if img.shape[0] != 2688 and img.shape[1] != 4032:
                            print("Not a SkyScan tif")
                        else:
                            height = img.shape[0]
                            width = img.shape[1]
                            left = img[0:height, 0:100] # edit strip width here
                            right = img[0:height, width-100:width]
                            edges = np.concatenate([left,right])
                            bkg = np.average(edges)
                            diff = 255-bkg
                            new = img[0:height, 0:width] + diff
                            new[new > 254] = 255
                            new[new == 0] = 255
                            newimg = np.zeros(img.shape, img.dtype)
                            newimg[0:height, 0:width] = new
                            #img[0:height, 0:width][img[0:height, 0:width] > 254] = 255
                            #img[0:height, 0:width][img[0:height, 0:width] ==0 ] = 255
                            os.makedirs(os.path.dirname(destination + '/' + folder.name + '/' + file.name), exist_ok=True)
                            cv.imwrite(destination + '/' + folder.name + '/' + file.name, newimg)
                            """
                            # Show stuff
                            cv.imshow('Original Image', img)
                            cv.imshow('New Image', newimg)
                            # Wait until user press some key
                            cv.waitKey()
                            """
