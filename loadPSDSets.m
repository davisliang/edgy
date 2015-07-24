function [data, labels, name] = loadPSDSets(dataPath, dataType, message)
%THIS TAKES PSD!
fprintf('%s \n', message);

cd(dataPath);
files = dir(dataType);
fprintf('     processing images (fft)... \n');

data = [];
labels = [];
name = {};

for i=1:length(files)
    filename = files(i).name;
    name{i} = filename;
    labels = [labels, str2num(filename(1))];  %labels(i)  gives label for image i
    filePath = fullfile(dataPath, filename); 
    data = [data, imagePSD(filePath)]; %data(:, i) gives PSD of image i
    
end

fprintf('     load successful. \n');