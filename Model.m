function[] = Model()
%% set up data and save paths
savePath_1 = '/Users/Davis/Desktop/Model/params/params1.mat';
savePath_2 = '/Users/Davis/Desktop/Model/params/params2.mat';
networkPath_PSD = '/Users/Davis/Desktop/Model/params/PSDWeights.mat';
networkPath_Gabor = '/Users/Davis/Desktop/Model/params/gaborWeights.mat';

dataPath = '/Users/Davis/Desktop/Model/dataset';
dataType = '*.jpg';

%% pull out relevant data
data_PSD = load(networkPath_PSD);
data_Gabor = load(networkPath_Gabor);

maxnum = data_PSD.maxnum;
whi_PSD = data_PSD.whi;
woh_PSD = data_PSD.woh;

whi_Gabor = data_Gabor.whi;
woh_Gabor = data_Gabor.woh;

%% load and preprocess PSD and Gabor Data
[data_gabor_train, label_gabor_train, name_gabor_train] = loadGaborSets(fullfile(dataPath, 'train'), dataType, 'loading training set (with gabor preprocessing)');
[data_gabor_test, label_gabor_test, name_gabor_test] = loadGaborSets(fullfile(dataPath, 'test'), dataType, 'loading testing set (with gabor preprocessing)');
[data_gabor_valid, label_gabor_valid, name_gabor_valid] = loadGaborSets(fullfile(dataPath, 'valid'), dataType, 'loading validation set (with gabor preprocessing)');

[data_PSD_train] = loadPSDSets(fullfile(dataPath, 'train'), dataType, 'loading training set (with PSD preprocessing)');
[data_PSD_test] = loadPSDSets(fullfile(dataPath, 'test'), dataType, 'loading testing set (with PSD preprocessing)');
[data_PSD_valid] = loadPSDSets(fullfile(dataPath, 'valid'), dataType, 'loading validation set (with PSD preprocessing)');

%% process data through PSD Stream
% we calculate a new maxnum for the second layer
data_PSD_train = 2*((data_PSD_train/maxnum) - 0.5); %normalize in accordance to training set.
data_PSD_test = 2*((data_PSD_test/maxnum) - 0.5);
data_PSD_valid = 2*((data_PSD_valid/maxnum) - 0.5);
%PSD data is ready for network input.

%% process data through the gabor Stream
%create gabor filters
[dictionary, orientationLabel] = createGabors();
[data_gabor_train_filtered] = filterSet(data_gabor_train, dictionary, 'filtering training set');
[data_gabor_test_filtered] = filterSet(data_gabor_test, dictionary, 'filtering testing set');
[data_gabor_valid_filtered] = filterSet(data_gabor_valid, dictionary, 'filtering validation set');

data_gabor_train = aggregateFilterResponse(data_gabor_train, data_gabor_train_filtered, 'aggregating training set filter response');
data_gabor_test = aggregateFilterResponse(data_gabor_test, data_gabor_test_filtered, 'aggregating testing set filter response');
data_gabor_valid = aggregateFilterResponse(data_gabor_valid, data_gabor_valid_filtered, 'aggregating validation set filter response');


%% shape inputs to network.
[input_train, input_test, input_valid] = generateInput(data_gabor_train, data_gabor_test, data_gabor_valid, data_PSD_train, ...
    data_PSD_test, data_PSD_valid, whi_PSD, woh_PSD, whi_Gabor, woh_Gabor, maxnum, 'processing inputs to second level network');

save(savePath_1, 'input_train', 'input_test', 'input_valid', 'whi_PSD', 'woh_PSD', 'whi_Gabor', 'woh_Gabor', 'maxnum', ...
    'label_gabor_train', 'label_gabor_valid', 'label_gabor_test', 'name_gabor_train', 'name_gabor_test', 'name_gabor_valid');

%% input to network, train
[whi, woh] = ModelTrain(savePath_1);

save(savePath_2, 'whi', 'woh');
%% experiment should be run in a different program.
fprintf('network assembly complete. \n');

