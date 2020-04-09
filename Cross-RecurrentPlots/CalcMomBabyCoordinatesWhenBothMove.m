clear;clc;
% Cases:
% 1 - both move
% 2 - mom move, baby don't
% 3 - baby move, mom don't
% 4 - both don't move
moms_stats  = csvimport('NewData\MomStats.csv');
mom_baby_data = csvimport('NewData\ResampledData.csv');
load('NewResults\mom_baby_movement_data.mat','mom_baby_movements');
moms_data = cell2mat(moms_stats(2:end,2:3));
mom_baby_num_data = cell2mat(mom_baby_data(2:end,2:end));
load('NewResults\clustered_moms.mat');
colors = {[1 0.9 0.9];[0.9 1 0.9];[0.9 0.9 1]}; 
for md=1:size(moms_data,1)
    both_move_counter = 1;
    sub_data = mom_baby_num_data(mom_baby_num_data(:,1)==moms_data(md,1),:);
    baby_sub_data = sub_data(:,4:5);
    mom_sub_data = sub_data(:,6:7);
    time = sub_data(:,3);
    baby_movement_times = mom_baby_movements{md,1};
    mom_movement_times = mom_baby_movements{md,2};
    baby_move_both{md,1}= [];
    mom_move_both{md,1}= [];
    time_move_both{md,1}= [];
 %   momtouch_move_both{md,1}= [];
    for c=2:length(time)
        step_time = round((time(c)+time(c-1))/2);
        if (ismember(step_time,baby_movement_times) | ismember(step_time,mom_movement_times))
            baby_move_both{md,both_move_counter}= [baby_move_both{md,both_move_counter}; baby_sub_data(c,:)];
            mom_move_both{md,both_move_counter}= [mom_move_both{md,both_move_counter}; mom_sub_data(c,:)];
            time_move_both{md,both_move_counter}= [time_move_both{md,both_move_counter}; step_time];
            %momtouch_times = momtouch(step_time==baby_movement);
            %momtouch_move_both{md,both_move_counter}= [momtouch_move_both{md,both_move_counter}; momtouch_times(:,1)];
        elseif (~isempty(baby_move_both{md,both_move_counter}))
            mom_move_in_segment = intersect(mom_movement_times,time_move_both{md,both_move_counter});
            baby_move_in_segment = intersect(baby_movement_times,time_move_both{md,both_move_counter});
            if (length(mom_move_in_segment)<=10 | length(baby_move_in_segment)<=10)
                baby_move_both{md,both_move_counter}= [];
                mom_move_both{md,both_move_counter}= [];
                time_move_both{md,both_move_counter}= [];
             %   momtouch_move_both{md,both_move_counter}= [];
            else
                both_move_counter = both_move_counter+1;
                baby_move_both{md,both_move_counter}= [];
                mom_move_both{md,both_move_counter}= [];
                time_move_both{md,both_move_counter}= [];
              %  momtouch_move_both{md,both_move_counter}= [];
            end
            
        end
    end
end

%save('NewResults\mom_baby_movement_during_both.mat','baby_move_both','mom_move_both','time_move_both');
save('NewResults\mom_baby_movement_atleast_one.mat','baby_move_both','mom_move_both','time_move_both');