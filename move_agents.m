function [ agentPositions, distance_travelled, selected_orders ] = ...
    move_agents( agentPositions, centroids, agent_orders, ...
    distance_travelled,velocity,max_velocity,selected_orders)
% Moves each agent towards its assigned centroid.
% 
% Centroids is a nx2 matrix, where (i,1) and (i,2) represent the ith
% agent's centroid's x and y value, respectively.
% agentPositions is nx2 matrix, where (i,1) and (i,2) is the ith's 
% agent's x and y position, respectively.
% 
% MOVEMENTSCALE must be greater than 0 and should be less than 2. It is
% the fraction of the distance that an agent will travel in the x and y
% direction. For example, if it is 1 then the agent will move to its 
% desired point in one iteration. If it is 0.5 the agent will be halfway 
% there. 

% Velocity is the constant velocity at which the user wishes the agent to
% travel. 

% Using a MOVEMENTSCALE of around 1.8 will usually cause the algorithm to 
% converge the fastest, but for the purposes of this project having a 
% MOVEMENTSCALE greater than 1 may be unrealistic. 

% Depending on whether an agent is going to its centroid or retrieving an
% order, we can take advantage of how velocity_fun uses it's algorithm_type
% paramter. algorithm_type == 1 is the constant velocity from the GUI, used
% for retireving orders. algorithm_type == 2 is velocity proportional to
% distance between agent location and centroid, used when going to centroid

n = size(agentPositions,1); % Find number of agents
total_distance = distance_travelled(end); % Track the sum of the total distance travelled by each of the robots
for i = 1 : n
    % First thing to check is if we should select an order:
    if ~isempty(agent_orders{1,i}) && isempty(selected_orders{1,i})
        % Select an order
        selected_orders{1,i} = agent_orders{1,i}(1,:);
    end
    % If there are no orders for a given agent and there are no orders
    % being pursued, move towards the centorid
    if isempty(agent_orders{1,i}) && isempty(selected_orders{1,i})
        direction = [centroids(i,1) - agentPositions(i,1), centroids(i,2) - agentPositions(i,2)];
        [delta_x, delta_y] = velocity_fun(2, direction, velocity, max_velocity);
        % Update total distance
        total_distance = total_distance + sqrt(delta_x^2 + delta_y^2);
        % Update agent positions
        agentPositions(i,1) = agentPositions(i,1) + delta_x;
        agentPositions(i,2) = agentPositions(i,2) + delta_y;
    % If there is an order for agents to move towards, move them
    elseif ~isempty(selected_orders{1,i})
        % Move agent towards order
        direction = [selected_orders{1,i}(1,1) - agentPositions(i,1), selected_orders{1,i}(1,2) - agentPositions(i,2)];
        [delta_x, delta_y] = velocity_fun(1, direction, velocity, max_velocity);
        % Update total distance
        total_distance = total_distance + sqrt(delta_x^2 + delta_y^2);
        % Update agent positions
        agentPositions(i,1) = agentPositions(i,1) + delta_x;
        agentPositions(i,2) = agentPositions(i,2) + delta_y;
    end
end    
distance_travelled = horzcat(distance_travelled, total_distance);
end