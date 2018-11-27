function agent_wait_times = update_wait_times(agent_wait_times)
% Function just decrements all non-zero wait times by 1
for i = 1:size(agent_wait_times,2)
    if agent_wait_times(1,i) ~= 0
        agent_wait_times(1,i) = agent_wait_times(1,i) - 1;
    end
end
end