function [agent_orders, order_queue] = sort_orders(agent_points, agent_positions, order_queue)
% Function does 2 things:
% 1) If an agent is at the location of an order, consider the order
% complete. We then remove that order from the queue
% 2) Place each agent's orders in a cell of a 1xN cell array, where the ith
% cell is the ith agent's orders, not sorted
% NOTE FOR FELIX: move_agents should look for the closest order to each
% agent and make them get that, or some other weighting based on a
% combination of proximity/time/etc.
% Function returns an updated order_queue and a list of the closest orders
% for each agent

n = size(agent_positions,1);

agent_orders = cell(1,n);
% To retrieve an order, just set the order queue at each agent's location
% to 0
for i = 1:n
    order_queue(agent_positions(i,2), agent_positions(i,1)) = 0;
end
% Figure out which agents retrieve which orders
for agent_num = 1:n
    agent_order_cell= [-1 -1];
    for i = 1:size(agent_points{1,agent_num},1)
        % To make the x,y values clear, state them explicitly
        % (x,y) is a point in a given agent's region
        x = agent_points{1,agent_num}(i,1);
        y = agent_points{1,agent_num}(i,2);
        % If there is an order at this point, add it to the agent's order
        % cell
        if order_queue(y,x) ~= 0
            agent_order_cell = addToArray(agent_order_cell, x, y);
        end
    end
    % Populate the cell array
    if agent_order_cell ~= [-1 -1]
        agent_orders{1,agent_num} = agent_order_cell;
    end
end