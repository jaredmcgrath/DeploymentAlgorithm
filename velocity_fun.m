function [delta_x, delta_y] = velocity_fun(direction_Vector,max_velocity,pos)
% Velocity Types: 
% This function used to be different but in our case, we assume that
% agent's move in the specified direction at max_velocity
% In the move_agents function, a simple check makes sure agents don't
% overshoot their target

% Keep track of how far an agent has moved
movement_total = 0;
delta_x = 0;
delta_y = 0;
% Restrict movement to discrete grid spaces
% If the X position is not on a gridline, move it over that amount in the
% direction specified by the vector
if mod(pos(1,1),1) ~= 0
    if direction_Vector(1,1) > 0
        delta_x = 1 - mod(pos(1,1),1);
    else
        delta_x = -mod(pos(1,1),1);
    end
    movement_total = abs(delta_x);
    direction_Vector(1,1) = direction_Vector(1,1) - delta_x;
% Similarly, if Y position is not on a gridline
elseif mod(pos(1,2),1) ~= 0
    if direction_Vector(1,2) > 0
        delta_y = 1 - mod(pos(1,2),1);
    else
        delta_y = -mod(pos(1,2),1);
    end
    movement_total = abs(delta_y);
    direction_Vector(1,2) = direction_Vector(1,2) - delta_y;
end
% At this point, agents must be on a gridline
% We will alternate between moving in the X and Y directions, moving one
addX = true;
while movement_total + 1 <= max_velocity && round(abs(direction_Vector(1,1))) >= 1 ...
        && round(abs(direction_Vector(1,2))) >= 1
    if addX
        d = sign(direction_Vector(1,1));
        delta_x = delta_x + d;
        movement_total = movement_total + 1;
        direction_Vector(1,1) = direction_Vector(1,1) - d;
        addX = false;
    else
        d = sign(direction_Vector(1,2));
        delta_y = delta_y + d;
        movement_total = movement_total + 1;
        direction_Vector(1,2) = direction_Vector(1,2) - d;
        addX = true;
    end
end
% If we can still move more, add the remainder
% After this if statement, either x or y will be off the gridlines, but not
% both. Hence, we can get as close to the direction vector as possible
if movement_total < max_velocity
    % If moving in the X direction is gets us closer
    if abs(direction_Vector(1,1)) > abs(direction_Vector(1,2))
        % Move in magnitude of max_velocity - movement_total or remainder
        % of direction_Vector, whichever is less. Then we won't overshoot
        % the target
        delta_x = delta_x + sign(direction_Vector(1,1)) * ...
            min((max_velocity - movement_total),abs(direction_Vector(1,1)));
    % If moving in the Y direction gets us closer
    else
        delta_y = delta_y + sign(direction_Vector(1,2)) * ...
            min((max_velocity - movement_total),abs(direction_Vector(1,2)));
    end
end
%% Old code; probably not as accurate
% % Move in the x direction first:
% % If we can move entirely in the X direction, do so
% if max_velocity <= abs(floor(direction_Vector(1,1))) + movement_total
%     % Use floor in case we also can move in Y
%     delta_x = delta_x + floor(direction_Vector(1,1));
%     movement_total = movement_total + abs(floor(direction_Vector(1,1)));
% else
%     % If this block of code is run, then we won't move in Y at all
%     delta_x = delta_x + sign(direction_Vector(1,1))*(max_velocity - movement_total);
%     movement_total = max_velocity;
% end
% % Then move in the Y direction
% if max_velocity <= abs(floor(direction_Vector(1,2))) + movement_total
%     % Don't use floor as this is the last movement
%     delta_y = delta_y + direction_Vector(1,2);
%     % Don't need to update totals
% %     movement_total = movement_total + abs(direction_Vector(1,2));
% %     direction_Vector(1,2) = 0;
% else
%     % In the case that we've already used all movement, delta_y won't
%     % change here
%     delta_y = delta_y + sign(direction_Vector(1,2))*(max_velocity - movement_total);
% end
end