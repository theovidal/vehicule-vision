function [xpassed, ypassed] = filterDetections(x, y, maximas)
    threshold = 5200;

    [xpassed, ypassed] = filterDetectionsThreshold(x, y, maximas, threshold);
end

function [xpassed, ypassed, maximaspassed] = filterDetectionsThreshold(x, y, maximas, threshold)
    indexes = maximas > threshold;
    maximaspassed = maximas(indexes);
    xpassed = x(indexes);
    ypassed = y(indexes);
end