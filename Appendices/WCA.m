%% This script allows you to select a folder of WCA data, outputs the average per droplet, ready to paste into PRISM or Origin.
% Line 72 transposes the output for use in Origin. Comment it out for PRISM.
% .txt naming convention needs to be material a b.txt Where a is the index
% for the cover slide and b is the index of the droplet on each slide.
% Dashes (-) can also be used but should be avoided.
% Written by Joseph Barnes, 2019
%% Get names of files in directory
clear
din=uigetdir('','Select folder containing data'); %select the data folder
files=dir(din); %list the files
nfiles=length(files); %find the number of files
filenames=string(zeros(nfiles,1));
for m=1:nfiles
    name=string(files(m).name); %get individual file name
    filenames(m)=name; %copy file names into matrix
end
%% Edit names and generate list of materials
filenames(1:2)=[]; %remove top two meaningless files
for n=1:length(filenames)
    material=strsplit(filenames(n,1)); %split filenames at each space
    material=material(1); %keep only the first phrase
    materials(n,1)=material; %put these into a column vector
end
materials=unique(materials); %remove duplicates
%% import data from files
fileno=1;
errors=0;
nsamples=inputdlg("How many slides per material?","Number of slides:",1,"3");
nsamples=str2double(nsamples{1});
ndrops=inputdlg("How many droplets per slide?","Number of droplets:",1,"5");
ndrops=str2double(ndrops{1});
prodn=(nsamples*ndrops)+1;
output=string(NaN(1,prodn));
headings=string(NaN(1,prodn));
headings(1,1)="Material";
for n=1:length(materials)
    material=materials(n); %choose which material to work on this time round
    data=NaN(140,(nsamples*ndrops));
    cd(din);
    for a=1:nsamples
        for b=1:ndrops
            thisfile1=strjoin([material," ",a,"-",b,".txt"],""); %generate the file name to open
            thisfile2=strjoin([material," ",a," ",b,".txt"],"");
            outhead=strjoin(["WCA-S",a,"D",b],"");
            if isfile(thisfile1) %if the file exists with a dash
            ncol=(a-1)*ndrops+b; %work out which column the data goes into
            import=importcol(thisfile1); %get the data
            data(1:length(import),ncol)=import; %put the data into the right column in "data"
            headings(1,ncol+1)=outhead; %make a note of the output heading for later
                if fileno<filenames.length
                 fileno=fileno+1;
                else
                end
            elseif isfile(thisfile2) %if the file exists with a space
            ncol=(a-1)*ndrops+b; %work out which column the data goes into
            import=importcol(thisfile2); %get the data
            data(1:length(import),ncol)=import; %put the data into the right column in "data"
            headings(1,ncol+1)=outhead; %make a note of the output heading for later
                if fileno<filenames.length
                 fileno=fileno+1;
                else
                end
            else
            errors=errors+1;   
            end
        end
    end
%% Process Data for this material
   averages=mean(data,'omitnan'); %calculate average of each column
   output(n+2,:)=[material,averages]; %put all the info into "output"
end
timepoint=inputdlg("Enter the timepoint and conditions these readings were taken at:");
output(1,1)=timepoint;%add timepoint to first cell of output.
output(2,:)=headings;%add headings to second row of 'output'.
outname=string(timepoint);
cd("../");
dout=uigetdir('','Select save location:'); %select the save folder
cd(dout);
xlswrite(outname,output); %save the excel
%% Create a transposed output file.
outname=strjoin([outname,"_transposed"],"");
output=output.';%Transpose the output for use in Origin
xlswrite(outname,output); %save the excel
%% success box
msgbox(sprintf("Done! There were %d missing files. \n",errors));
