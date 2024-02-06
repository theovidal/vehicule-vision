function [] = showIntermediaryImageAndCircles(dilatedI, xcenters, ycenters, centers, radii, params)
    % Here we assume the user effectively wanted to plot intermediary
    % results (otherwise the function wouldn't have been called in the
    % first place
    axis equal
    imagesc(dilatedI)
    [~, nbInitial] = size(xcenters);

    % Print ALL the maximas detecter by the detectMaxima function, before
    % any filtering
    for i=1:nbInitial
        rectangle( ...
            'Position', [xcenters(i) + params.yMin - params.boxSize/2, ycenters(i) + params.xMin - params.boxSize/2, params.boxSize, params.boxSize], ...
            'EdgeColor', 'g', ...
            'LineWidth', 4);
    end

    [nb, ~]=size(centers);

    % Plot all the circles identified by the filterDetectionsShape function
    for i = 1:nb(1)
        rectangle('Position', [centers(i,1) - radii(i)/2, centers(i,2)-radii(i)/2, radii(i), radii(i)], ...
            'EdgeColor', 'b', ...
            'LineWidth', 4);
    end
end

