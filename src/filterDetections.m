% Filter the points found as maxima by the detectMaxima function
function [xpassed, ypassed] = filterDetections(rgyb, x, y, maxima, params)
    [xpassed, ypassed] = filterDetectionsThreshold(x, y, maxima, params);
    [xpassed, ypassed] = filterDetectionsShape(rgyb, xpassed, ypassed, params);
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
    se = offsetstrel('ball',10,200);
    dilatedI = imdilate(rgyb,se);

    % If the user wants to, we plot the dilated image and the maxima
    % previously found (before applying this filter)
    if params.plotIntermediary == 'on'
        subplot(2,1,2)
        imagesc(dilatedI)
        [~, nbInitial] = size(x);
        for i=1:nbInitial
            rectangle('Position', [x(i) - params.boxSize/2, y(i) - params.boxSize/2, params.boxSize, params.boxSize], 'EdgeColor', 'g', 'LineWidth', 4);
        end
    end

    % Using the Image Processing Toolbox to find circles
    [centers, radii] = imfindcircles(dilatedI,[params.circleMinRadius, params.circleMaxRadius],"ObjectPolarity","bright");
    [nb, ~]=size(centers);
    if nb > 0
        xCenters = floor(centers(:, 1));
        yCenters = floor(centers(:, 2));
        for i=1:nb(1)
            % If the user wants to, we plot all the circles we found (as
            % rectangles so it's quicker to display)
            if params.plotIntermediary == 'on'
                rectangle('Position', [centers(i,1) - radii(i)/2, centers(i,2)-radii(i)/2, radii(i), radii(i)], 'EdgeColor', 'b', 'LineWidth', 4);
            end
    
            % We only keep maxima that are in range of a circle
            indices=(x <= xCenters(i) + params.boxSize/2) & (x >= xCenters(i) - params.boxSize/2) & (y <= yCenters(i) + params.boxSize/2) & (y >= yCenters(i) - params.boxSize/2)
            xpassed = [xpassed, x(indices)];
            ypassed = [ypassed, y(indices)];
        end
    end
end