function [order_x, order_y] = get_closest_order(pos, orders)
% Function finds the order closest to the agent's position out of all
% orders, using Euclidean distance. (order_x, order_y) is the x and y of
% the closest order

order_x = orders(1,1);
order_y = orders(1,2);
dist = sqrt((order_x - pos(1,1))^2 + (order_y - pos(1,2))^2);
for i = 2:size(orders,1)
    next_dist = sqrt((orders(i,1) - pos(1,1))^2 + (orders(i,2) - pos(1,2))^2);
    if next_dist < dist
        dist = next_dist;
        order_x = orders(i,1);
        order_y = orders(i,2);
    end
end
end