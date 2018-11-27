function [delta_x, delta_y] = velocity_fun(direction_Vector,max_velocity)
% Velocity Types: 
% This function used to be different but in our case, we assume that
% agent's move in the specified direction at max_velocity
% In the move_agents function, a simple check makes sure agents don't
% overshoot their target

delta_x = direction_Vector(1)/sqrt(direction_Vector(1)^2+direction_Vector(2)^2)*max_velocity;
delta_y = direction_Vector(2)/sqrt(direction_Vector(1)^2+direction_Vector(2)^2)*max_velocity;
end