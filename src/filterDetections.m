% Filter the points found as maxima by the detectMaxima function
% If the user wants to, the function also plots the intermediary results as
% described by the 'plotIntermediary' parameter
function [xpassed, ypassed] = filterDetections(rgyb, x, y, maxima, params)
    xpassed = x;
    ypassed = y;
    if strcmp(params.filterThreshold, 'on')
        [xpassed, ypassed] = filterDetectionsThreshold(x, y, maxima, params);
    end
    if strcmp(params.filterCircle, 'on')
        [xpassed, ypassed] = filterDetectionsShape(rgyb, xpassed, ypassed, params);
    end
end

% Filter all maxima which underlying value exceeds the threshold
function [xpassed, ypassed] = filterDetectionsThreshold(x, y, maxima, params)
    indices = maxima > params.detectionThreshold;
    xpassed = x(indices);
    ypassed = y(indices);
end

% Filter all maxima whose box contains a circle (which can be a traffic
% light)
function [xpassed, ypassed] = filterDetectionsShape(rgyb, x, y, params)
    xpassed=[];
    ypassed=[];

    % Apply dilatation to the image so the red maxima are now "blobs" that
    % are much easier to analyse
    se = offsetstrel('ball', params.dilatationRadius, params.dilatationHeight);
    dilatedI = imdilate(rgyb, se);

    % Using the Image Processing Toolbox to find circles
    [centers, radii] = imfindcircles(dilatedI,[params.circleMinRadius, params.circleMaxRadius],"ObjectPolarity","bright");
    [nb, ~]=size(centers);
    if nb > 0
        xCenters = floor(centers(:, 1));
        yCenters = floor(centers(:, 2));
        for i=1:nb(1)
            % We only keep maxima that are in range of a circle
            indices=(x <= xCenters(i) + params.boxSize/2) & (x >= xCenters(i) - params.boxSize/2) & (y <= yCenters(i) + params.boxSize/2) & (y >= yCenters(i) - params.boxSize/2);
            xpassed = [xpassed, x(indices)];
            ypassed = [ypassed, y(indices)];
        end
    end

    % If the user wants to, we plot the dilated image and the maxima
    % previously found (before applying this filter)
    % We have to do it at the end of this function since the RGYB image
    % must be plotted before the rectangles (otherwise they'll be hidden
    % behind)
    if strcmp(params.plotIntermediary, 'on')
        showIntermediaryImageAndCircles(dilatedI, x, y, centers, radii, params);
    end
end
