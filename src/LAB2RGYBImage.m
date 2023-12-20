function rgyb = LAB2RGYBImage(lab)
    labrows = reshape(lab, [], 3);
    labtable = array2table(labrows);
    rgybtable = rowfun(@(x, y, z) RGB2LABPixel([x y z]).', labtable);
    rgyb = reshape(rgybtable{:,:}, size(lab));
end