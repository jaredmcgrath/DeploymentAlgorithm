function distances = dist_between_pt_arr(origin, pos)
% Function returns the distances between the origin and every coordinate in
% pos
n = size(pos,1);
distances = zeros(1,n);
for i = 1:n
    distances(1,i) = distance_between(origin(1), origin(2), pos(i,1), pos(i,2));
end
end