%% This script takes the output csv's from Labkit, does some stats and...
% compiles them into one results file, it also names the scans more appropriately from the xlsx files.

clear
%% Import sample dictionary
dict = readtable("FinalExp-Key.xlsx");

%% Initialise output table
varTypes = ["string","string","double","double","double"];
varNames = ["Sample","Label","VoxelCount","Total_VoxelCount","PercentVoxelCount"];
sz = [0 numel(varNames)];
csvdata = table('Size',sz,'VariableTypes',varTypes,'VariableNames',varNames);
sz = [0 numel(varNames)];
data = table('Size',sz,'VariableTypes',varTypes,'VariableNames',varNames);

%% Loop Through .csv files in directory
files = dir('*.csv');
n=0;
for file = files'
    n=n+1; 
    fprintf("Processing file %s (%d of %d) \n",file.name,n,length(files));
    csv = readtable(file.name); % get csv file contents
    num_labels = height(csv); % get number of segment labels in csv file
    tube_ID = replace(file.name,'-morpho.csv',''); % extract Tube ID from file name
    tube_ID = replace(tube_ID,'seg-',''); 
    sample_data = dict(matches(dict.Tube_ID,tube_ID),:); % look up sample data from dictionary
    sample_name = string(sample_data.Sample); % extract sample name from data
    sample_timepoint = string(sample_data.Timepoint); % extract sample timpoint from data
    sample = strcat(sample_name, " ",sample_timepoint); % Generate new Sample name
    switch num_labels
        case 2
            Sample = [sample;sample]; % 2 tissue types, so need 2 rows.
            Total_VoxelCount = sum(csv.VoxelCount); % Calculate total voxel count
            Total_VoxelCount = [Total_VoxelCount;Total_VoxelCount];
        case 3
            Sample = [sample;sample;sample]; % 3 tissue types, so need 3 rows.
            nowrap = csv(csv.Label ~=10,:); % Need to exclude bone wrap from total voxel count
            Total_VoxelCount = sum(nowrap.VoxelCount); % Calculate total voxel count
            Total_VoxelCount = [0;Total_VoxelCount;Total_VoxelCount];
    end
    Sample = table(Sample); % Convert into table
    Total_VoxelCount = table(Total_VoxelCount);

    csvdata = [Sample csv Total_VoxelCount]; % Combine sample name with CSV contents
    csvdata.PercentVoxelCount = csvdata.VoxelCount ./ csvdata.Total_VoxelCount;
    data = vertcat(data,csvdata); % Append output to 'data'
end

%% Change Labels from brightness levels to tissue names
data.Label(strcmp(data.Label,"255"))="Mineralised";
data.Label(strcmp(data.Label,"128"))="Non-Mineralised";
data.Label(strcmp(data.Label,"10"))="Scaffold-Wrap";

%% Do the statistics:
%% Initialise output table
varTypes = ["string","string","double","double","double","double","double"];
varNames = ["Sample","Label","av_VoxelCount","SD_VoxelCount","av_PercentVoxelCount","SD_PercentVoxelCount","n_Reps"];
sz = [0 numel(varNames)];
results = table('Size',sz,'VariableTypes',varTypes,'VariableNames',varNames);

%% Calculations per sample
sample_list = unique(data.Sample); % Get list of unique samples/TPs
label_list = unique(data.Label); % Get list of unique labels

for Sample = sample_list'
    S_TP_reps = data(matches(data.Sample,Sample),:); % List all replicates for this S/TP
    n_Reps = height(S_TP_reps) / height(label_list); % No. Replicates of this sample

    for Label = label_list'
        S_TP_L = S_TP_reps(matches(S_TP_reps.Label,Label),:); % List all replicates for this S/TP + label combo
        av_VoxelCount = mean(S_TP_L.VoxelCount, 'omitnan');
        SD_VoxelCount = std(S_TP_L.VoxelCount);
        av_PercentVoxelCount = mean(S_TP_L.PercentVoxelCount, 'omitnan');
        SD_PercentVoxelCount = std(S_TP_L.PercentVoxelCount);

        results_line = table(Sample,Label,av_VoxelCount,SD_VoxelCount,av_PercentVoxelCount,SD_PercentVoxelCount,n_Reps);
        results = vertcat(results,results_line); % Append output to 'results'
    end
end
disp(results)

%Remove rows containing occurrences of 'X' in 'Sample'
trimmedresults=results(cellfun(@isempty, strfind(results.Sample, 'X')), :);

%% Save data matrix as XLSX file
savename = 'XCT-morpho-Stats.xlsx';
if exist(savename, 'file')==2
  delete(savename);
end
writetable(trimmedresults,savename);
fprintf("Stats saved as %s \n", savename)

