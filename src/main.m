clear all; close all; clc;

% --- BEGIN OF USER CUSTOMISATION --- %

% This structure contains all the parameters the user can adjust for the
% detection and filters
params=struct( ...
    'plotIntermediary', 'off', ... % 'on' to plot the "computer vision", displaying the color space and intermediary maximas
    'nrMaxima', 6, ... % Initial number of maximas to search for, before filtering
    'boxSize', 60, ... % Dimension of the box in which only a single maxima can be
    ... % Filter type : apply detection in a specific portion of the screen
    'xMin', 1, ...
    'xMax', 200, ...
    'yMin', 200, ...
    'yMax', 640, ...
    ... % Filter type : match traffic lights as circles
    'circleDetection', 'off', ...
    'circleMinRadius', 15, ...
    'circleMaxRadius', 30, ...
    ... % ...but before applying this filter, the RGYB image needs to be
    ... % dilated so red points are becoming red "blobs" that we can identify as
    ... % circles later
    'dilatationRadius', 10, ...
    'dilatationHeight', 200, ...
    ... % Filter type : only keep maximas that are superior to a threshold
    'detectionThreshold', 7000 ...
);

% Dataset of videos provided by the school or downloaded from Youtube
% Format for each row : path, number of images
data = [
    "assets/day-sequence", 11179;
    "assets/night-sequence", 9001
]

% Index of the dataset to choose
index=1;

% --- END OF USER CUSTOMISATION --- %

path=data(index, 1);
numImages=str2num(data(index, 2)); % MATLAB matrixes can only handle one data type, here strings

showImagesAndResults(4400, numImages, path, params)
