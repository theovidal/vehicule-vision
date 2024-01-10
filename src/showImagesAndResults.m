function [] = showImagesAndResults(start, stop, directory, nbMaxima)
    files=dir(directory);
       
    %arrayfun(@(file) controlAutoPlay(h, directory, file), files((start + 2):stop, 1));

    i=start + 2;
    autoplay = true;
   
    xboxed=zeros(1,1)
    yboxed=zeros(1,1)

    h=figure('KeyPressFcn', @KeyPressCb)

    while true
        if autoplay && i < stop
            [xboxed, yboxed]=controlAutoPlay(h, directory, files(i,1), i, nbMaxima, xboxed, yboxed);
            i=i+1;
            %pause(1/60)
        else
            pause(1/100);
        end
    end

    function KeyPressCb(~, event)
        if strcmp(event.Key, 'space')
            autoplay = ~autoplay;
        else
            [i, xboxed, yboxed]=controlKeyInput(h, directory, files, i, nbMaxima, xboxed, yboxed, event, i, start, stop);
        end
    end
end

function [new_i, xpassed, ypassed] = controlKeyInput(h, directory, files, i, nbMaxima, xboxed, yboxed, event, start, stop)
    if strcmp(event.Key, 'rightarrow') && i < stop
        new_i = i + 1;
        [xpassed, ypassed]=showImage(h, directory, files(i,1), index, nbMaxima)
    elseif strcmp(event.Key, 'leftarrow') && i > start + 2
        new_i = i - 1;
        [xpassed, ypassed]=showImage(h, directory, files(i,1), index, nbMaxima);
    else
        new_i = i;
    end
end

function [xpassed, ypassed] = controlAutoPlay(h, directory, file, index, nbMaxima, xboxed, yboxed)
    tStart = tic;
    [xpassed, ypassed]=showImage(h, directory, file, index, nbMaxima, xboxed, yboxed);
    tStop = toc(tStart);
    %pause(max([0; 1/30 - tStop]));
end

function [xpassed, ypassed] = showImage(h, directory, file, index, nbMaxima, xboxed, yboxed)
    boxSize=80;

    h=figure(h);
    imagePath=sprintf('%s/%s', directory, file.name);
 
    %subplot(1,3,1)
    axis off
    axis equal
    image=imread(imagePath);
    rgb=deformatImages(image);
    imagesc(rgb);

    if (bitand(index, 11) == 0)
        %subplot(1,3,2)
        lab = RGB2LABImage(rgb);
        %imagesc(lab);
    
        %subplot(1,3,3)
        rgyb = LAB2RGYBImage(lab);
        %imagesc(rgyb);
        
        %subplot(1,3,1)
        % Les points dans une image sont référencés d'abord par abcisse puis
        % ordonnée, on prend donc l'opposé des calculs matriciels
        [y, x, maxVals] = detectMaxima(rgyb, nbMaxima, boxSize);
        [xpassed, ypassed] = filterDetections(x, y, maxVals);
    else
        xpassed = xboxed;
        ypassed = yboxed;
    end
    s=size(xpassed);
    for i=1:s(2)
        rectangle('Position', [xpassed(i) - boxSize/2, ypassed(i) - boxSize/2, boxSize, boxSize], 'EdgeColor', 'r', 'LineWidth', 4);
    end
end
