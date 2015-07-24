function [dictionary, orientationLabel] = createRectGabors()
display(['building gabors...']);

numScales = 3;
numOrientations = 30;
numAngles = 1;
gaborSize = 10;

%% create filter bank
for j = 1:numScales
    sizeMod(j) = (2*pi/256)*1.1*j;
end

for j = 1:numOrientations
    theta(j) = (pi/(numOrientations/2))*(j-1);
end

for j = 1:numAngles
    phi(j) = pi;
end


for j = 1:numScales
    Dictionary{j} = generate_angled_gabor_dictionary(phi,theta, 'width', gaborSize*(((pi/16)/sizeMod(j))), 'f', 40);
end

%% we extract data from just the first cell, as we only want the first scale...
dictionary = Dictionary;

%% we build a labeling system for the current angle.
for i = 1:numOrientations
    orientationLabel(i) = (180/numOrientations)*(i-1); %current angle
end

display(['    filters successfully created']);