function [] = showImagesAndResults(start, stop, directory, params)
    files=dir(directory);
       
    % We want to skip the two listed directories "." (current) and ".." (previous)
    % So the index must be superior or equal to 3
    i=start + 2;
    autoplay = true;
   
    % We use these matrixes to store the coordinates of the maxima between
    % images, so we don't need to calculate them each time
    % and we can process them in between
    xsaved=zeros(1,1);
    ysaved=zeros(1,1);

    h=figure('KeyPressFcn', @KeyPressCb);
    axis off;
    axis equal;

    while true
        if autoplay
            if i < stop
                [xsaved, ysaved]=controlAutoPlay(h, directory, files(i,1), i, params, xsaved, ysaved);
                i=i+1;
            else
                autoplay = false;
            end
        else
            pause(1/100);
        end
    end

    function KeyPressCb(~, event)
        if strcmp(event.Key, 'space')
            autoplay = ~autoplay;
        else
            [i, xsaved, ysaved]=controlKeyInput(h, directory, files, i, params, xsaved, ysaved, event);
        end
    end
end

function [new_i, xpassed, ypassed] = controlKeyInput(h, directory, files, index, params, xsaved, ysaved, event)
    % By default we don't change anything, except if a control key (right
    % or left arrow) is pressed
    xpassed=xsaved;
    ypassed=ysaved;
    new_i = index;

    [numFiles, ~] = size(files);
    numImages = numFiles - 2;

    % We add 2 to the indices refering to files, in order to skip "." and ".." directories
    if strcmp(event.Key, 'rightarrow') && index < numImages + 2
        new_i = index + 1;
        [xpassed, ypassed]=computeDetection(h, directory, files(index,1), index, params, xsaved, ysaved)
    elseif strcmp(event.Key, 'leftarrow') && index > 2
        new_i = index - 1;
        [xpassed, ypassed]=computeDetection(h, directory, files(index,1), index, params, xsaved, ysaved);
    end
end

function [xpassed, ypassed] = controlAutoPlay(h, directory, file, index, params, xsaved, ysaved)
    [xpassed, ypassed]=computeDetection(h, directory, file, index, params, xsaved, ysaved);
end
