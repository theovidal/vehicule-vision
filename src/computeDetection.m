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

    showFilteredImage(rgb, xpassed, ypassed, params);
end
