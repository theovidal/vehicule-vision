function rgyb = LAB2RGYBImage(lab)  
    L=lab(:, :, 1);
    a=lab(:, :, 2);
    b=lab(:, :, 3);
    rgyb = L .* (a + b);
end 
