function [aggregateOutput] = aggregateFilterResponse(Im, filteredIm, message)

%the format of filteredIm is: filteredIm(:,:,angle,orientation)
fprintf('%s\n', message);


numImages = size(filteredIm,2);
numSizes = size(filteredIm{1},3);
numAngles = size(filteredIm{1},4);
numOrientations = size(filteredIm{1},5);

orientationSum_normalized = {};
aggregateOutput = [];

for i = 1:numImages
    fprintf('    aggregating filter of image %i of %i \n', i, numImages');
    
    for s = 1:numSizes
        for a = 1:numAngles
            for o = 1:numOrientations
                orientationSum(o) = sum(sum(sum(filteredIm{i}(:,:,s,a,o).*Im{i})));
            end
        end
    end
    
    orientationSum = orientationSum - mean(orientationSum);
    maxOrientation = max(abs(orientationSum));
    orientationSum_normalized{i} = (orientationSum/maxOrientation);
end



for i = 1:numImages %reshape it
    aggregateOutput = [aggregateOutput, orientationSum_normalized{i}'];
end

fprintf('    aggregation complete\n');
