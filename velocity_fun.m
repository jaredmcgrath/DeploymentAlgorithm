function [delta_x, delta_y] = velocity_fun(Velocity_Type,direction_Vector,velocity,max_velocity)
% Velocity Types: 
% 1: Constant Velocity determined in GUI.
% 2: Velocity is proportional to distance between agent and centroid.
% MOVEMENTSCALE determines the proportion of the distance.
% max_velocity is the bound for velocity

if Velocity_Type == 1
    if(velocity > max_velocity)
        velocity = max_velocity;
    end
    delta_x = direction_Vector(1)/sqrt(direction_Vector(1)^2+direction_Vector(2)^2)*velocity;
    delta_y = direction_Vector(2)/sqrt(direction_Vector(1)^2+direction_Vector(2)^2)*velocity;
elseif Velocity_Type == 2
    delta_x = direction_Vector(1);
    delta_y = direction_Vector(2);
    if(sqrt(delta_x^2 + delta_y^2) > max_velocity) % max velocity has been exceeded
        direction_Vector(1) = direction_Vector(1)/(sqrt(direction_Vector(1)^2+direction_Vector(2)^2));
        direction_Vector(2) = direction_Vector(2)/(sqrt(direction_Vector(1)^2+direction_Vector(2)^2));
        delta_x = direction_Vector(1)*max_velocity;
        delta_y = direction_Vector(2)*max_velocity;
    end
end
end