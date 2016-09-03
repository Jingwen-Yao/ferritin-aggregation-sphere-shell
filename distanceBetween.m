function [ distance ] = distanceBetween( position1, position2 )
% Calculate the distance between 2 points
% Calculate the distance between 2 points
distance = sqrt((position1(1)-position2(1)).^2+...
                (position1(2)-position2(2)).^2+...
                (position1(3)-position2(3)).^2);

end

