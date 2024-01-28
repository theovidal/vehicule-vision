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
        [y, x, maxVals] = detectMaxima(rgyb, params.nrMaxima, params.boxSize, params.xMin, params.xMax, params.yMin, params.yMax);
        [xpassed, ypassed] = filterDetections(rgyb, x, y, maxVals, params);
    else
        xpassed = xsaved;
        ypassed = ysaved;
    end

    showImage(rgb, xpassed, ypassed, params);
end

function [] = showImage(rgb, xpassed, ypassed, params)
    % If the user wanted to plot intermediary calculation, we now need to
    % place the final results in the first subplot
    if params.plotIntermediary == 'on'
        subplot(1,2,1);
    end
    axis off
    axis equal
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