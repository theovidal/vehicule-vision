% Convert color space of an image from LAB to RGYB, so we can easily
% exploit it to detect red zones, corresponding to a traffic light ordering
% the vehicule to stop
function rgyb = LAB2RGYBImage(lab)  
    L=lab(:, :, 1);
    a=lab(:, :, 2);
    b=lab(:, :, 3);
    rgyb = L .* (a + b);
end 
