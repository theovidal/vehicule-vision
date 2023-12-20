function [x, y, maxVals] = detectMaxima(RGYB, nrMaxima, boxSize)
    maxVals = [];
    x = [];
    y = [];
    rgybedit = RGYB;

    s = size(RGYB)
    size_x = s(1);
    size_y = s(2);

    for i=1:nrMaxima
        rgybedit(251, 520)
        [M, I] = max(rgybedit, [], "all", "linear")
        X = 1 + floor((I - 1)/size_x);
        Y = mod(I - 1, size_x) + 1;

        region_x_min=X - boxSize;
        region_y_min=Y - boxSize;
        region_x_max=X + boxSize;
        region_y_max=Y + boxSize;
        safe_y_min = max(region_y_min ,1)
        safe_y_max = min(region_y_max , size_x)
        safe_x_min = max(region_x_min ,1)
        safe_x_max = min(region_x_max , size_y)
        rgybedit(safe_y_min:safe_y_max, safe_x_min:safe_x_max) = 0;
            
        maxVals = [maxVals, M];
        x = [x, X];
        y = [y, Y];
    end
end