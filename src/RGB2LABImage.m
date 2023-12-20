function lab = RGB2LABImage(rgb)
    rgbrows = reshape(rgb, [], 3);

    %labrows = arrayfun(@(rowid) RGB2LABPixel(rgbrows(rowid,:)), (1:size(rgbrows,1).'), 'UniformOutput', false)
    %out = reshape(cell2mat(labrows),numel(cell2mat(labrows)),1);
    %lab = reshape(out, size(rgb));

    rgbtable = array2table(rgbrows);
    labtable = rowfun(@(x, y, z) RGB2LABPixel([x y z]).', rgbtable);
    lab = reshape(labtable{:,:}, size(rgb));
end

%function rgbl = RGBs2RGBLinearImage(rgb)
    
%end



%function xyz = RGBLinear2XYZImage(rgbl)

%end


%function lab = XYZ2LABImage(xyz) 

%end

%function nonlinearity = f(t)

%end

    
