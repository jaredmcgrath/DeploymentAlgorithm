 function [agent_orders, order_queue, selected_orders, new_wait_time] = sort_orders(agent_points, agent_positions, order_queue, selected_orders, wait_time)
% Function does 2 things:
% 1) If an agent is at the location of an order, consider the order
% complete. We then remove that order from the queue, if agent is within
% 0.5 units of the location of the order
%
% 2) Place each agent's orders in a cell of a 1xN cell array, where the ith
% cell is the ith agent's orders, by anything in particular
%
% Function returns all orders sorted by agent, an updated order_queue, a
% list of orders that are being pursued by agents, and a new list of wait
% times for any agents who might have retrieved an item
%
% Used to ensure no agent will try to take another agent's order if it is
% already selected
all_selected_orders = [-1 -1];

n = size(agent_positions,1);
new_wait_time = zeros(1,n);
agent_orders = cell(1,n);
% Agents can only retireve an order if they have selected it
for i = 1:n
    x = round(agent_positions(i,1));
    y = round(agent_positions(i,2));
    % If the agent retrieved its selected order, clear it from the list
    if ~isempty(selected_orders{1,i})
        % If the agent can retrieve its order
        if (selected_orders{1,i} == [x y])
            selected_orders{1,i} = [];
            order_queue(y, x) = 0;
            % Add wait time before agent is free again
            new_wait_time(1,i) = wait_time;
        % Otherwise, we must track which orders are already selected
        else
            all_selected_orders = addToArray(all_selected_orders, ...
                selected_orders{1,i}(1,1), selected_orders{1,i}(1,2));
        end
    end
end
% Figure out which agents retrieve which orders
for agent_num = 1:n
    % If agent has no order selected, its list of orders is initialized
    % empty
    if isempty(selected_orders{1,agent_num})
        agent_order_cell = [-1 -1];
    % Otherwise, agent's list of orders is initialized with the selected
    % order
    else
        agent_order_cell = selected_orders{1,agent_num};
    end
    for i = 1:size(agent_points{1,agent_num},1)
        % To make the x,y values clear, state them explicitly
        % (x,y) is a point in a given agent's region
        x = agent_points{1,agent_num}(i,1);
        y = agent_points{1,agent_num}(i,2);
        % If there is an order at this (x,y)
        if order_queue(y,x) ~= 0
            % And there are no selected orders
            if isempty(all_selected_orders)
                % Add the order
                agent_order_cell = addToArray(agent_order_cell, x, y);
            % Otherise, only add order if it isn't already selected
            elseif ~ismember(all_selected_orders, [x y], 'rows')
                agent_order_cell = addToArray(agent_order_cell, x, y);
            end
        end
    end
    % Populate the cell array
    if agent_order_cell ~= [-1 -1]
        agent_orders{1,agent_num} = agent_order_cell;
    end
end