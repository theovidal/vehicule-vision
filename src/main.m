clear all; close all; clc;

% --- BEGIN OF USER CUSTOMISATION --- %

% This structure contains all the parameters the user can adjust for the
% detection and filters
params=struct( ...
    ... % 'on' to plot the "computer vision", displaying the color space and intermediary filtering
    ... % If circle detection is enabled, displays the RGYB image with dilation, and detected circles
    ... % If off, only displays the RGYB image without transformation
    ... % In all cases, the maxima returned by detectMaxima are plotted as green rectangles
    'plotIntermediary', 'off', ... 
    ... 
    'nrMaxima', 6, ... % Initial number of maximas to search for, before filtering
    'boxSize', 60, ... % Dimension of the box in which only a single maxima can be
    ...
    ... % 'on' to be able to control the auto play with space bar (pause/play) and left/right arrows (forward/backward)
    ... % Please note that this option slows a bit the video flow so MATLAB is able to register key events ; this is mainly a feature meant for debug
    'controlAutoPlay', 'on', ...
    ...
    ... % FILTER TYPE : apply detection in a specific portion of the screen
    'xMin', 1, ...
    'xMax', 200, ...
    'yMin', 1, ...
    'yMax', 640, ...
    ...
    ... % FILTER TYPE : match traffic lights as circles
    'filterCircle', 'off', ... % 'on' to enable this filter
    'circleMinRadius', 15, ...
    'circleMaxRadius', 30, ...
    ... % Before applying this filter, the RGYB image needs to be
    ... % dilated so red points are becoming red "blobs" that we can identify as
    ... % circles later (creating flat maximas inside the image)
    ... % We use a "circle" dilation for this purpose, hence these params
    'dilatationRadius', 10, ...
    'dilatationHeight', 200, ...
    ...
    ... % FILTER TYPE : only keep maximas that are superior to a threshold
    'filterThreshold', 'on', ... % 'on' to enable this filter
    'detectionThreshold', 7000, ...
    ...
    ... % EXPERIMENTAL FEATURE : enable green traffic light detection - it doesn't work properly, it tends to detect many green objects but not the traffic lights.
    ... % This could also be a problem of the camera : very lighted green points appear as white
    'greenDetection', 'off'...
);

% Dataset of videos provided by the school or downloaded from Youtube
% Format for each row : path, number of images
data = [
    "assets/day-sequence", 11179;
    "assets/night-sequence", 9001
]

% Index of the dataset to choose
index=1;

% Index of the image to start from
startPos = 4000;

% --- END OF USER CUSTOMISATION --- %

path=data(index, 1);
numImages=str2num(data(index, 2)); % MATLAB matrixes can only handle one data type, here strings

% The "showImagesAndResults" has been split into three functions :
% - controlVideoPlayback, which handles the autoplay mode and key inputs
% - computeDetection, which opens an image, do the color space conversions
% and call detectMaxima and filterDetections
% - showFilteredImage, which plots the figure with the final rectangles
controlVideoPlayback(startPos, numImages, path, params)
