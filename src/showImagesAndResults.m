function [] = showImagesAndResults(numImages, start, stop, directory, params)
    files=dir(directory);
       
    % We want to skip the two listed directories "." (current) and ".." (previous)
    % So the index must be superior or equal to 3
    i=start + 2;
    autoplay = true;
   
    % We use these matrixes to store the coordinates of the maxima between
    % images, so we don't need to calculate them each time
    % and we can process them in between
    xboxed=zeros(1,1);
    yboxed=zeros(1,1);

    h=figure('KeyPressFcn', @KeyPressCb);
    axis off;
    axis equal;

    while true
        if autoplay
            if i < stop
                [xboxed, yboxed]=controlAutoPlay(h, directory, files(i,1), i, params, xboxed, yboxed);
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
            [i, xboxed, yboxed]=controlKeyInput(h, directory, files, i, params, xboxed, yboxed, event, numImages);
        end
    end
end

function [new_i, xpassed, ypassed] = controlKeyInput(h, directory, files, index, params, xboxed, yboxed, event, numImages)
    % By default we don't change anything, except if a control key (right
    % or left arrow) is pressed
    xpassed=xboxed;
    ypassed=yboxed;
    new_i = index;

    % We add 2 to the indices refering to files, in order to skip "." and ".." directories
    if strcmp(event.Key, 'rightarrow') && index < numImages + 2
        new_i = index + 1;
        [xpassed, ypassed]=showImage(h, directory, files(index,1), index, params, xboxed, yboxed)
    elseif strcmp(event.Key, 'leftarrow') && index > 2
        new_i = index - 1;
        [xpassed, ypassed]=showImage(h, directory, files(index,1), index, params, xboxed, yboxed);
    end
end

function [xpassed, ypassed] = controlAutoPlay(h, directory, file, index, params, xboxed, yboxed)
    [xpassed, ypassed]=showImage(h, directory, file, index, params, xboxed, yboxed);
end

function [xpassed, ypassed] = showImage(h, directory, file, index, params, xboxed, yboxed)
    imagePath=sprintf('%s/%s', directory, file.name);
 
    h=figure(h);
    imageData=imread(imagePath);
    rgb=deformatImages(imageData);

    % We calculate new maxima every four images, so this bitwise operation
    % is equivalent to testing if index mod 4 == 3
    if (bitand(index, 11) == 0)
        lab = RGB2LABImage(rgb);
        rgyb = LAB2RGYBImage(lab);
        imagesc(rgyb);
        [y, x, maxVals] = detectMaxima(rgyb, params.nrMaxima, params.boxSize, params.xMin, params.xMax, params.yMin, params.yMax);
        [xpassed, ypassed] = filterDetections(rgyb, x, y, maxVals, params);
    else
        xpassed = xboxed;
        ypassed = yboxed;
    end

    % If the user wanted to plot intermediary calculation, we now need to
    % place the final results in the first subplot
    if params.plotIntermediary == 'on'
        subplot(2,1,1);
    end
    
    imagesc(rgb);

    [~, nbPassed] = size(xpassed);
    for i=1:nbPassed
        rectangle( ...
            'Position', [xpassed(i) - params.boxSize/2, ypassed(i) - params.boxSize/2, params.boxSize, params.boxSize], ...
            'EdgeColor', 'r', ...
            'LineWidth', 4 ...
        );
    end
end
