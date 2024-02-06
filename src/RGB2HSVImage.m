% Convert color space of an image from RGB to HSV
% See https://fr.wikipedia.org/wiki/Teinte_Saturation_Valeur?useskin=vector#Transformation_entre_TSV_et_RVB
function [hsv] = RGB2HSVImage(rgb)
    hsv=zeros(size(rgb));
    [width, height, ~]=size(rgb);

    maxValue=max(rgb, [], 3);
    minValue=min(rgb, [], 3);

    r=rgb(:, :, 1);
    g=rgb(:, :, 2);
    b=rgb(:, :, 3);

    % Setting the "hue" for each pixel
    h = zeros(width, height);
    h(maxValue == minValue) = 0;

    redAssign = 60 * mod((g - b) ./ (maxValue - minValue), 6);
    redIndexes = maxValue == r;
    h(redIndexes) = redAssign(redIndexes);

    greenAssign = 60 * (2 + (b - r) ./ (maxValue - minValue));
    greenIndexes = maxValue == g;
    h(greenIndexes) = greenAssign(greenIndexes);

    blueAssign = 60 * (4 + (r - g) ./ (maxValue - minValue));
    blueIndexes = maxValue == b;
    h(blueIndexes) = blueAssign(blueIndexes);

    % Setting the "saturation" for each pixel
    s = zeros(width, height);

    s(maxValue == 0) = 0;

    assign=1 - minValue ./ maxValue;
    s(maxValue ~= 0) = assign(maxValue ~= 0);

    % Setting the "value" for each pixel
    v=maxValue;

    % Gathering all the pixels
    hsv=cat(3, h, s, v);
end