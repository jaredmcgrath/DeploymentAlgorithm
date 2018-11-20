function [ points ] = radial_points(x_0, y_0, r, sides)
% Creates a list of points within r of (x_0,y_0)
% Where all points are inclusively within 1 and sides
% r is the "discrete radius", the # of discrete grid spaces away
% from a center point (x,y) 
% For r = 2, cell{1,1} = [x y]
% and cell{1,2} = [x y+1; x+1 y; x y-1; x-1 y]
% and cell{1,3} = [x y+2; x+1 y+1; x+2 y; x+1 y-1; x y-2; x-1 y-1; x-2 y; x-1 y+1]
% Function then takes all the cells and concatonates vertically

% Preallocate the number of points neeed in points
syms n
num_points = double(symsum(2^n, n, 2, r+1)) + 1;
points = zeros(num_points,2);
j = 1;

% Loop for each radius length, 0 to r
% (The first loop will contain (x_0, y_0) only)
for i = 0:r
    % There will always be 2*(current radius, i) points in each cell array
    
    % First point will be deltaY = i
    % Next point -> subtract 1 from deltaY, add 1 to deltaX
    % continue until deltaY = -i
    % This will cover quadrant 1 and 4
    
    % Remainder of points are those strictly in Q 3 and 2
    % i.e. those not on the line x = 0
    
    % loop for Q1, Q4
    for deltaY = i : -1 : -i
        % deltaX always >0 in Q1,4
        deltaX = i - abs(deltaY);
        x = x_0 + deltaX;
        y = y_0 + deltaY;
        % Make sure (x,y) in bounds
        if x >= 1 && x <= sides && y >= 1 && y <= sides
            points(j,:) = [x y];
            j = j + 1;
        end
    end
    % loop for Q3, Q2
    for deltaY = -i : 1 : i
        % deltaX always <= 0
        deltaX = -(i - abs(deltaY));
        x = x_0 + deltaX;
        y = y_0 + deltaY;
        % always check for duplicates
        if ~(ismember([x y],points,'rows')) && x >= 1 && x <= sides &&...
                y >= 1 && y <= sides
            points(j,:) = [x y];
            j = j + 1;
        end
    end
end
% Get rid of the extra points that weren't used
points = points(1:j-1,:);

