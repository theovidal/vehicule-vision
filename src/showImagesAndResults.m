function [] = showImagesAndResults(start, stop, directory)
    files=dir(directory);
       
    %arrayfun(@(file) controlAutoPlay(h, directory, file), files((start + 2):stop, 1));

    i=start + 2;
    autoplay = true;

    h=figure('KeyPressFcn', @KeyPressCb)
    h

    while true
        if autoplay && i < stop
            controlAutoPlay(h, directory, files(i,1));
            i=i+1;
            pause(1/60)
        else
            pause(1/100)
        end
    end

    function KeyPressCb(~, event)
        if strcmp(event.Key, 'space')
            autoplay = ~autoplay;
        else
            i=controlKeyInput(h, directory, files, event, i, start, stop);
        end
    end
end

function [new_i] = controlKeyInput(h, directory, files, event, i, start, stop)
    if strcmp(event.Key, 'rightarrow') && i < stop
        new_i = i + 1
        showImage(h, directory, files(i,1))
    elseif strcmp(event.Key, 'leftarrow') && i > start + 2
        new_i = i - 1
        showImage(h, directory, files(i,1))
    else
        new_i = i
    end
end

function [] = controlAutoPlay(h, directory, file)
    tStart = tic;
    showImage(h, directory, file);
    tStop = toc(tStart);
    pause(max([0; 1/30 - tStop]));
end

function [] = showImage(h, directory, file)
    boxSize=80;

    h=figure(h);
    imagePath=sprintf('%s/%s', directory, file.name);
 
    %subplot(1,3,1)
    axis off
    axis equal
    image=imread(imagePath);
    rgb=deformatImages(image);
    imagesc(rgb);

    %subplot(1,3,2)
    lab = RGB2LABImage(rgb);
    %imagesc(lab);

    %subplot(1,3,3)
    rgyb = LAB2RGYBImage(lab);
    %imagesc(rgyb);
    
    %subplot(1,3,1)
    [x, y, maxVals] = detectMaxima(rgyb, 5, boxSize)
    s=size(maxVals)
    for i=1:s(2)
        rectangle('Position', [x(i) - boxSize/2, y(i) - boxSize/2, boxSize, boxSize], 'EdgeColor', 'r', 'LineWidth', 4);
    end
end
