% Detect nrMaxima maximas in a RGYB image, so the nrMaxima red points of
% maximum intensity, and isolate a zone of (2*boxSize) * (2*boxSize) around
% them
function [x, y, maxVals] = detectMaxima(RGYB, nrMaxima, boxSize, xMin, xMax, yMin, yMax)
    maxVals = [];
    x = [];
    y = [];
    rgybedit = RGYB(xMin:xMax, yMin:yMax);

    [size_x, size_y] = size(rgybedit);

    for i=1:nrMaxima
        [M, I] = max(rgybedit, [], "all", "linear");
        X = mod(I - 1, size_x) + 1;
        Y = 1 + floor((I - 1)/size_x);

        region_x_min = X - boxSize;
        region_y_min = Y - boxSize;
        region_x_max = X + boxSize;
        region_y_max = Y + boxSize;
        safe_y_min = max(region_y_min, 1);
        safe_y_max = min(region_y_max, size_y);
        safe_x_min = max(region_x_min, 1);
        safe_x_max = min(region_x_max, size_x);
        rgybedit(safe_x_min:safe_x_max, safe_y_min:safe_y_max) = 0;
          
        maxVals = [maxVals, M];
        x = [x, X];
        y = [y, Y];
    end
end
