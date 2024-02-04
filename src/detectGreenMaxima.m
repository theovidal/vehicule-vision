function [x, y, maxVals] = detectGreenMaxima(hsv, nrMaxima, boxSize)
    % Green : 75-140 ; 0-100 ; 70-100
    [originalX, originalY, ~] = size(hsv)
    
    indexes = hsv(:,:,1) >= 75 & hsv(:,:,1) <= 140 & hsv(:,:,3) > 70;

    hsvEdit = hsv(:,:,3);

    values = hsvEdit .* indexes;
    [size_x, size_y] = size(values);

    x=[];
    y=[];
    maxVals=[];

    for i=1:nrMaxima
        [M, I] = max(values, [], "all", "linear");
        X = mod(I - 1, size_x) + 1;
        Y=1 + floor((I - 1)/size_x);

        region_x_min=X - boxSize;
        region_y_min=Y - boxSize;
        region_x_max=X + boxSize;
        region_y_max=Y + boxSize;
        safe_y_min = max(region_y_min ,1);
        safe_y_max = min(region_y_max , size_y);
        safe_x_min = max(region_x_min ,1);
        safe_x_max = min(region_x_max , size_x);
        values(safe_x_min:safe_x_max, safe_y_min:safe_y_max) = 0;
          
        maxVals = [maxVals, M];
        x = [x, X];
        y = [y, Y];
    end
end