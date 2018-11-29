function [ agentPoints ] = assign_points( agentPositions, sides, target_region_mass, density )
% Assigns the points that can be seen by the agents to their closest
% agents. These points are added to agentPoints, a 1xn cell array, where
% the ith cell is an rx2 matrix containing the ith agent's points.

% CellPoints contains all the points that a coms group can see. Then
% cellpoints is divided between the agents in the corresponding coms group.

n = size(agentPositions,1);
% agentPoints is a 1-row, n-column cell array where the ith cell contains
% a list of points in the ith agent's region
agentPoints = cell(1,n);

% Matrix that is 0 if hasn't been assigned to, 1 if it has
% Used to keep track of unassigned points in the second for loop
assigned_points = zeros(sides,sides);

% Might not need this, based on implementation
% for i = 1 : n
%     agentPoints{1,i} = -1*ones(1,2); % Initialize agentPoints to [-1 -1] arrays.
% end

threshold = 0;
for i = 1 : size(agentPositions,1) % iterate over each agent
    cellPoints = [-1 -1];
    x_0 = round(agentPositions(i,1)); % find position of that agent
    y_0 = round(agentPositions(i,2));
    cumulative_mass = 0;
    k = 1;
    % To optimize, use radius equal to ceil(sqrt(2)*sides/n)
    points = radial_points(x_0, y_0, ceil(sqrt(2)*sides/n), sides);

    % This loop adds space to an agent's region while the region has a
    % mass less than the target mass +/- a threshold
    while ((cumulative_mass - threshold) < target_region_mass) && (k < size(points,1))
        % Helper vars cuz typing is hard
        x = points(k,1);
        y = points(k,2);
        % add point
        cellPoints = addToArray(cellPoints, x, y);
        % update cumulative mass of region
        cumulative_mass = cumulative_mass + density(y,x);
        % update assigned_points
        assigned_points(y,x) = assigned_points(y,x) + 1;
        % update counter
        k = k + 1;
    end
    threshold = threshold + (cumulative_mass - target_region_mass);
    agentPoints{1,i} = cellPoints;
end
% Now, this loop goes through each point in each cell
% Need to ensure all points are assigned to a region
% -> any unassigned points should be assigned to nearest agent
% -> also need to check if this causes a large imbalance
% -> also need to check if there is overlap
over_assigned = [-1 -1];

% Populate lists
for y = 1:sides
    for x = 1:sides
        % Find unassigned points
        % Should test this
        if assigned_points(y,x) == 0
            %disp(['Unassigned point (' sprintf('%d',x) ',' sprintf('%d',y) ')'])
            minDist = [0 Inf];
            for agentNum = 1:n
                dist = distance_between(x, y, agentPositions(agentNum,1), agentPositions(agentNum,2));
                if dist < minDist(2)
                    minDist = [agentNum dist];
                end
            end
            % Add the point to the closest agent's region
            agentPoints{1,minDist(1)} = addToArray(agentPoints{1,minDist(1)}, x, y);
        elseif assigned_points(y,x) > 1
            %disp(['Over assigned point (' sprintf('%d',x) ',' sprintf('%d',y) ')'])
            over_assigned = addToArray(over_assigned, x, y);
        end
    end
end
for i = 1:size(over_assigned,1)
    x = over_assigned(i,1);
    y = over_assigned(i,2);
    % Need mass of each region to determine which agent gets to keep the
    % point
    mass = mass_calc(agentPoints, density, n);
    minMass = [0 Inf 0];
    % Loop to populate agents_with_pt
    for agentNum = 1:n
        % tf is true/false value indicating whether (x,y) is in agent
        % idx is index where point is located
        [tf,idx] = ismember([x y], agentPoints{1,agentNum}, 'rows');
        % If agent contains point
        if tf
            % If agent has lowest running mass
            if mass(1,agentNum) < minMass(2)
                % Last agent will have point displaced, as long as it's not the
                % initial values for minMass
                if minMass(1) > 0
                    agentPoints{1,minMass(1)}(minMass(3),:) = [];
                end
                % Update minMass
                minMass = [agentNum mass(1,agentNum) idx];
            % Even if agent doesn't have lowest mass, the point still needs
            % to be displaced from the region
            else
                agentPoints{1,agentNum}(idx,:) = [];
            end
        end
    end
end
end

