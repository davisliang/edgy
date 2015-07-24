function [data, labels, name] = loadGaborSets(dataPath, dataType, message)
%THIS TAKES PSD!
fprintf('%s\n',message);
cd(dataPath);

files = dir(dataType);

data = {};
labels = [];
name = {};

for i=1:length(files)
    filename = files(i).name;
    name{i} = filename;
    labels = [labels, str2num(filename(1))];  %#ok<ST2NM> %labels(i)  gives label for image i
    filePath = fullfile(dataPath, filename); 
    
    
    img = imread(filePath);
    if size(img,3) == 3
        img_grey = rgb2gray(img);
    else
        img_grey=img;
    end
    
    img_resized = imresize(img_grey, [200,200]);
    img_canny = edge(img_resized);
    data{i} = (double(img_canny)); %data(:, i) gives PSD of image i   
end

fprintf('    dataset successfully loaded. \n');

%labels{i} = label for image i
%data{i} = normalized greyscale image i
%name{i} = filename for image i