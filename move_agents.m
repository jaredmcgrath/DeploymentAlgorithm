function [ agentPositions, distance_travelled, selected_orders ] = ...
    move_agents( agentPositions, centroids, agent_orders, ...
    distance_travelled,max_velocity,selected_orders,agent_wait_times)
% Moves each agent towards its assigned centroid or selected order, if it
% has one.
% 
% Centroids is a nx2 matrix, where (i,1) and (i,2) represent the ith
% agent's centroid's x and y value, respectively.
% agentPositions is nx2 matrix, where (i,1) and (i,2) is the ith's 
% agent's x and y position, respectively.
% 
% If an agent has a non-zero wait time, it cannot be moved
%
% max_velocity is the velocity at which a given agent can travel. Also
% determines the max distance an agent can move in a single iteration


n = size(agentPositions,1); % Find number of agents
total_distance = distance_travelled(end); % Track the sum of the total distance travelled by each of the robots
for i = 1 : n
    % Only move agent if it is not waiting
    if agent_wait_times(1,i) == 0
        % First thing to check is if we should select an order:
        if ~isempty(agent_orders{1,i}) && isempty(selected_orders{1,i})
            % Select an order
            [x, y] = get_closest_order(agentPositions(i,:), agent_orders{1,i});
            selected_orders{1,i} = [x y];
        end
        % If there are no orders for a given agent and there are no orders
        % being pursued, move towards the centorid
        if isempty(agent_orders{1,i}) && isempty(selected_orders{1,i})
            direction = [centroids(i,1) - agentPositions(i,1), centroids(i,2) - agentPositions(i,2)];
            % velocity_fun will use manhattan distances to ensure at least
            % x or y will fall on an whole number
            [delta_x, delta_y] = velocity_fun(direction, max_velocity, agentPositions(i,:));
            % Update total distance
            total_distance = total_distance + abs(delta_x) + abs(delta_y);
            % Update agent positions
            agentPositions(i,1) = agentPositions(i,1) + delta_x;
            agentPositions(i,2) = agentPositions(i,2) + delta_y;
        % If there is an order for agents to move towards, move them
        elseif ~isempty(selected_orders{1,i})
            % Move agent towards order
            direction = [selected_orders{1,i}(1,1) - agentPositions(i,1), selected_orders{1,i}(1,2) - agentPositions(i,2)];
            % velocity_fun will use manhattan distances to ensure at least
            % x or y will fall on an whole number
            [delta_x, delta_y] = velocity_fun(direction, max_velocity, agentPositions(i,:));
            % Update total distance
            total_distance = total_distance + abs(delta_x) + abs(delta_y);
            % Update agent positions
            agentPositions(i,1) = agentPositions(i,1) + delta_x;
            agentPositions(i,2) = agentPositions(i,2) + delta_y;
        end
    end
end    
distance_travelled = horzcat(distance_travelled, total_distance);
end