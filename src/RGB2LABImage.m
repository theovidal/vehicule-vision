% Convert color space of an image from RGB to LAB
function lab = RGB2LABImage(rgb)
    rgbl = RGBs2RGBLinearImage(rgb);
    xyz = RGBLinear2XYZImage(rgbl);
    lab = XYZ2LABImage(xyz);
end


function rgb = RGBs2RGBLinearImage(rgb)
    T = 0.04045;
    rgb(rgb < T) = rgb(rgb <T)/12.92; 
    rgb(rgb >= T) = ((rgb(rgb >= T)+0.055)/1.055).^ 2.4;
end


function xyz = RGBLinear2XYZImage(rgbl)
    M = [0.4124     0.3576      0.1805;
        0.2126      0.7152      0.0722;
        0.0193     0.1192      0.9505];
    xyz = M * reshape(rgbl, [], 3)';
    xyz = reshape(xyz', size(rgbl));
end


function lab = XYZ2LABImage(xyz) 
    shape = size(xyz);
    D65white = [0.9505     1       1.0890];

    Xf=f(xyz(:, :, 1)/D65white(1));
    Yf=f(xyz(:, :, 2)/D65white(2));
    Zf=f(xyz(:, :, 3)/D65white(3));
    
    lab = zeros(shape);
    lab(:,:, 1) = 116*Yf-16;
    lab(:,:, 2) = 500*(Xf-Yf);
    lab(:,:, 3) = 200*(Yf-Zf);
end


function nonlinearity = f(M)
    threshold = (6/29)^3;

    M(M > threshold) = M(M > (6/29)^3) .^ (1/3);
    M(M <= threshold) = 7.787 * M(M <= (6/29)^3) + (16/116)*ones(size(M(M <= (6/29)^3)));
    
    nonlinearity = M;
end