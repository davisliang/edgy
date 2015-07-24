function [filteredData] = filterSet(data, gabor, message)
% this function filters and entire dataset with the supplied gabor filter
% of proper format.
% @author Davis Liang
% @version 1.0
% date: 7/13/15

% data{i} denotes image i
% gabor{i} denotes gabor i
filteredData = {};

fprintf('%s \n', message);

numImages = size(data, 2);

numSizes = size(gabor,2);

numOrientations = size(gabor{1},2);
numAngles = size(gabor,1);

for i = 1:numImages
    fprintf('    filtering image %i of %i\n', i, numImages);
    for s = 1:numSizes
        for secO = 1:numOrientations
            for primO = 1:numAngles
                filteredData{i}(:, :, s, primO, secO) = imfilter(data{i}, gabor{s}{primO, secO}, 'replicate', 'conv');
            end
        end
    end
end
         

fprintf('    filtering complete. \n');
%filteredData{i,s,o) refers to output feature map for image i from gabor of
%size s and orientation o.