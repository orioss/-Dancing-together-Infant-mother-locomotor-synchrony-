
clear; clc;
%start_color = [29,145,192]/255;
moms_stats  = csvimport('NewData\MomStats.csv');
load('NewResults\mom_baby_movement_times_only.mat');
load('NewResults\subjects_floor_time_durations.mat');
moms_data = cell2mat(moms_stats(2:end,2:3));
mom_baby_movement_cases_precentage = [];
% load('clustered_moms.mat');
for md=1:size(moms_data,1)
    sub_floor_time = subjects_floor_time_durations(subjects_floor_time_durations(:,1)==moms_data(md,1),2)*60;
    baby_movement = mom_baby_movements{md,1};
    mom_movement = mom_baby_movements{md,2};
    first_movement=min(baby_movement(1),mom_movement(1));
    last_movement=max(baby_movement(end),mom_movement(end));
    mom_baby_moving_case = [];
    for c=first_movement:last_movement
        step_time = c;
        if (ismember(step_time,baby_movement) & ismember(step_time,mom_movement))
            mom_baby_moving_case = [mom_baby_moving_case; 1];
        elseif (~ismember(step_time,baby_movement) & ismember(step_time,mom_movement))
            mom_baby_moving_case = [mom_baby_moving_case; 2];
        elseif (ismember(step_time,baby_movement) & ~ismember(step_time,mom_movement))
            mom_baby_moving_case = [mom_baby_moving_case; 3];
        end
    end
    
    both = length(mom_baby_moving_case(mom_baby_moving_case==1));
    only_mom = length(mom_baby_moving_case(mom_baby_moving_case==2));
    only_baby = length(mom_baby_moving_case(mom_baby_moving_case==3));
    mom_baby_movement_cases_precentage = [mom_baby_movement_cases_precentage; only_baby only_mom both];
end