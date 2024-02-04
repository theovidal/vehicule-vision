function [xpassed, ypassed] = computeDetection(h, directory, file, index, params, xsaved, ysaved)
    imagePath=sprintf('%s/%s', directory, file.name);
    imageData=imread(imagePath);
    rgb=deformatImages(imageData);

    h=figure(h);
    % We calculate new maxima every four images, so this bitwise operation
    % is equivalent to testing if index mod 4 == 3
    if (bitand(index, 11) == 0)
        lab = RGB2LABImage(rgb);
        rgyb = LAB2RGYBImage(lab);
        imagesc(rgyb);

        % Coordonates in a matrix and in a image are inverted, hence the
        % switch between x and y
        [y, x, maxVals] = detectMaxima(rgyb, params.nrMaxima, params.boxSize, params.xMin, params.xMax, params.yMin, params.yMax);
        [xpassed, ypassed] = filterDetections(rgyb, x, y, maxVals, params);
    else
        xpassed = xsaved;
        ypassed = ysaved;
    end

    hsv=RGB2HSVImage(rgb);
    subplot(2,1,2);
    imagesc(hsv);
    subplot(2,1,1);
    [ygreen, xgreen, ~] = detectGreenMaxima(hsv, params.nrMaxima, params.boxSize)

    showImage(rgb, xpassed, ypassed, xgreen, ygreen, params);
end

function [] = showImage(rgb, xpassed, ypassed, xgreen, ygreen, params)
    % If the user wanted to plot intermediary calculation, we now need to
    % place the final results in the first subplot
    if ~strcmp(params.plotIntermediary, 'on')
        %axis off
        axis equal
        imagesc(rgb);
    end

    [~, nbPassed] = size(xpassed);

    % Print the final boxes, that are results of filters in
    % filterDetections function
    for i=1:nbPassed
        % The maximas are calculated in a matrix which origin is the point
        % (xMin, yMin), so we have to move back those points so they can be
        % printed correctly (and as usual, the coordinates on the image and
        % in matrixes are inverted)
        rectangle( ...
            'Position', [xpassed(i) + params.yMin - 1 - params.boxSize/2, ypassed(i) + params.xMin - 1 - params.boxSize/2, params.boxSize, params.boxSize], ...
            'EdgeColor', 'r', ...
            'LineWidth', 4 ...
        );
    end

    [~, nbGreen] = size(xgreen)

    for i=1:nbGreen
        rectangle( ...
            'Position', [xgreen(i) - params.boxSize/2, ygreen(i) - params.boxSize/2, params.boxSize, params.boxSize], ...
            'EdgeColor', 'g', ...
            'LineWidth', 4 ...
        );
    end
end