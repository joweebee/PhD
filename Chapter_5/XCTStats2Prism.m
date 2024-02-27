%% This script reformats .xlsx files of XCT data for export into Prism.
clear
%% Import compiled morpho results
data = readtable('XCT-morpho-stats.xlsx');

%% Split sample and timestamp
TP = table(split(data.Sample));
TP = splitvars(TP, "Var1","NewVariableNames",["SampleID","Timepoint"]);

%% Combine into new table
data = [TP data];

%% Remove unneeded cols
data = data(cellfun(@isempty, strfind(data.Label, 'Non-')), :); % Remove rows containing anything other than 'mineralised'
data = data(cellfun(@isempty, strfind(data.Label, 'Wrap')), :); % Remove rows containing anything other than 'mineralised'
data = removevars(data,{'Sample','Label','av_VoxelCount','SD_VoxelCount'}); % Remove unwanted stats

%% Construct Prism table
n_timepoints = height(unique(data.Timepoint));
materials = table(unique(data.SampleID));
materials = renamevars(materials,"Var1","Sample");
n_materials = height(materials);
oldcols = ["av_PercentVoxelCount","SD_PercentVoxelCount","n_Reps"];

for timepoint = ["D1" "D7" "D14" "D28"]
    matTP = data(matches(data.Timepoint,timepoint),:)
    matTP = removevars(matTP,{'SampleID','Timepoint'}); % Remove unwanted cols
    newcols = strcat(timepoint,oldcols);
    matTP = renamevars(matTP,oldcols,newcols);
    materials = [materials matTP];
end

%% Save data matrix as XLSX file
savename = 'XCT-prism-output.xlsx';
if exist(savename, 'file')==2
  delete(savename);
end
writetable(materials,savename);
fprintf("Prism Output saved as %s \n", savename)


