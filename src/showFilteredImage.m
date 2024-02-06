function [] = showFilteredImage(rgb, xpassed, ypassed, params)
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

    if strcmp(params.greenDetection, 'on')
        hsv=rgb2hsv(rgb);
        [ygreen, xgreen, ~] = detectGreenMaxima(hsv, params.nrMaxima, params.boxSize, params.xMin, params.xMax, params.yMin, params.yMax)
        [~, nbGreen] = size(xgreen)
    
        for i=1:nbGreen
            rectangle( ...
                'Position', [xgreen(i) + params.yMin - params.boxSize/2, ygreen(i) + params.xMin - params.boxSize/2, params.boxSize, params.boxSize], ...
                'EdgeColor', 'g', ...
                'LineWidth', 4 ...
            );
        end
    end
end