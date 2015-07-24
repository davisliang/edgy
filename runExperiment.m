function [] = runExperiment()

%% load network params
loadPath_1 = '/Users/Davis/Desktop/Model/params/params1.mat';
loadPath_2 = '/Users/Davis/Desktop/Model/params/params2.mat';

data_1 = load(loadPath_1);
data_2 = load(loadPath_2);

maxnum = data_1.maxnum;

whi_PSD = data_1.whi_PSD;
woh_PSD = data_1.woh_PSD;
whi_Gabor = data_1.whi_Gabor;
woh_Gabor = data_1.woh_Gabor;

whi = data_2.whi;
woh = data_2.woh;


%% load experiment data
dataPath = '/Users/Davis/Desktop/Model/dataset/compare_experiment';
dataType = '*.jpg';

[data_gabor, label_gabor, name_gabor] = loadGaborSets(fullfile(dataPath), dataType, 'loading experiment set (with gabor preprocessing)');
[data_PSD] = loadPSDSets(fullfile(dataPath), dataType, 'loading experiment set (with PSD preprocessing)');

%% process data through PSD stream
data_PSD = 2*((data_PSD/maxnum)-0.5);

%% process data through gabor stream
[dictionary, orientationLabel] = createGabors();
[data_gabor_filtered] = filterSet(data_gabor, dictionary, 'filtering experiment set');
data_gabor = aggregateFilterResponse(data_gabor, data_gabor_filtered, 'aggregating experiment set response');

%% shape inputs to fit network params
[input] = generateInput(data_gabor, [], [], data_PSD, [], [], whi_PSD, woh_PSD, whi_Gabor, woh_Gabor, maxnum, 'processing inputs to second level');

%% feed forwards through network.
numImages = size(input,2);

for i = 1:numImages
    [wrong, out] = feedforwards(whi, woh, input(:,i), 0);
    fprintf('Rectilinearity for %s is: %f \n', name_gabor{i}, out(2));
end

