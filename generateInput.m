function [outTrain, outTest, outValid] = generateInput(data_gabor_train, data_gabor_test, data_gabor_valid, data_PSD_train, data_PSD_test, data_PSD_valid, whi_PSD, ...
    woh_PSD, whi_Gabor, woh_Gabor, maxnum, message)


%% set up constants
fprintf('%s\n', message);

numTrainImages = size(data_gabor_train, 2);  %number of images in set.
numTestImages = size(data_gabor_test, 2);
numValidImages = size(data_gabor_valid, 2);

outTrain = [];
outTest = [];
outValid = [];

%% calculate and display outputs.
%for training set
for i = 1:numTrainImages
    [wrong, outPSD] = feedforwards(whi_PSD, woh_PSD, data_PSD_train(:,i), 0);
    [wrong, outGabor] = feedforwards(whi_Gabor, woh_Gabor, data_gabor_train(:,i), 0);
    out_temp = [outPSD(2); outGabor(2)];
    outTrain = [outTrain, out_temp];
end
%for testing set
for i = 1:numTestImages
    [wrong, outPSD] = feedforwards(whi_PSD, woh_PSD, data_PSD_test(:,i), 0);
    [wrong, outGabor] = feedforwards(whi_Gabor, woh_Gabor, data_gabor_test(:,i), 0);
    out_temp = [outPSD(2); outGabor(2)];
    outTest = [outTest, out_temp];
end
%for validaiton set
for i = 1:numValidImages
    [wrong, outPSD] = feedforwards(whi_PSD, woh_PSD, data_PSD_valid(:,i), 0);
    [wrong, outGabor] = feedforwards(whi_Gabor, woh_Gabor, data_gabor_valid(:,i), 0);
    out_temp = [outPSD(2); outGabor(2)];
    outValid = [outValid, out_temp];
end
    

% outputs are rows: PSDoutput, Rectilinear output. Columns: images
display('    calculation complete');
