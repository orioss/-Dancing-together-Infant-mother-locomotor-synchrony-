function CalcBabyMomMovementTrajectories(data_dir, movement_times_file, resampled_data_file, mom_baby_stats_file)
% CalcBabyMomMovement calculates the mom and the baby movement trajectory
% and movement times
%
%% Syntax
% CalcBabyMomMovementTrajectories(data_dir, movement_times_file, resampled_data_file, mom_baby_stats_file)
%
%% Description
% CalcBabyMomMovementTrajectories gets mom and baby movement times, resampled data to
% 100ms, and overall movement details and calculates their trajectories
% throughout the session. Files with all the trajectories da ta are saved
% in a given directory
%
% Required Input.
% data_dir: directory to save trajectory files
% movement_times_file: MAT file that includes mom and baby movement time from datavyu
% resampled_data_file: MAT file that includes data resmpling for mom and baby location in the room every 100ms
% mom_baby_stats_file: MAT file that includes 

% load all data files
moms_stats  = csvimport(mom_baby_stats_file);
mom_baby_data = csvimport(resampled_data_file);
load(movement_times_file);
moms_data = cell2mat(moms_stats(2:end,2:3));
mom_baby_num_data = cell2mat(mom_baby_data(2:end,2:end));

% sets the color for movement cases (baby only, mom only, both, or none)
colors = [251,128,114; 204,235,197; 128,177,211];
colors = colors./255

% initialize trajectory and distance changes arrays
mom_baby_dist_by_stats_total_distance = zeros(size(moms_data,1),3);
mom_baby_dist_by_stats_segmants = zeros(size(moms_data,1),4);
mom_baby_dist_by_stats_segmants_further = zeros(size(moms_data,1),3);
mom_baby_dist_by_stats_segmants_closer = zeros(size(moms_data,1),3);
mom_baby_dist_by_stats_getting_closer = zeros(size(moms_data,1),3);
mom_baby_dist_by_stats_getting_further = zeros(size(moms_data,1),3);
mom_baby_dist_changes = zeros(size(moms_data,1),4); % both | only baby | only mom | all besides stay still
from_stationary_result=zeros(size(moms_data,1),2);
from_stationary_result_30=zeros(size(moms_data,1),2);
from_stationary_result_50=zeros(size(moms_data,1),2);

% initialize variables to be used
prev_prev_seg = 0;
prev_seg = 0;
segment_size = 0;
last_segment_size = 0;
all_subjects_moving_case = [];

% go over all dyads
for md=1:size(moms_data,1)
    fig = figure;
    
    % gets the resampled mom and baby data
   sub_data = mom_baby_num_data(mom_baby_num_data(:,1)==moms_data(md,1),:);
   baby_sub_data = sub_data(:,4:5);
   mom_sub_data = sub_data(:,6:7);
   time = sub_data(:,3);
   baby_dists = [];
   mom_dists = [];
   
   % extracts bouts - baby only, mom only, both
   for bi=2:size(sub_data,1)
       baby_dists = [baby_dists calcdist([baby_sub_data(bi-1,:); baby_sub_data(bi,:)])];
   end    
   for mi=2:size(sub_data,1)
       mom_dists = [mom_dists calcdist([mom_sub_data(mi-1,:); mom_sub_data(mi,:)])];
   end        
   mom_baby_dist=[];
   for mbi=1:size(sub_data,1)
       mom_baby_dist(mbi) = calcdist([baby_sub_data(mbi,:); mom_sub_data(mbi,:)]);
   end

    baby_movement = mom_baby_movements{md,1};
    mom_movement = mom_baby_movements{md,2};
    mom_baby_moving_case = [];
    
    % Devides the movement times moment to moment to 4 cases:
    % 1 - both move
    % 2 - mom move, baby don't
    % 3 - baby move, mom don't
    % 4 - both don't move
    for c=2:length(baby_dists)
        step_time = round((time(c)+time(c-1))/2);
        if (ismember(step_time,baby_movement) & ismember(step_time,mom_movement))
            mom_baby_moving_case = [mom_baby_moving_case; 1];
        elseif (~ismember(step_time,baby_movement) & ismember(step_time,mom_movement))
            mom_baby_moving_case = [mom_baby_moving_case; 2];
        elseif (ismember(step_time,baby_movement) & ~ismember(step_time,mom_movement))
            mom_baby_moving_case = [mom_baby_moving_case; 3];
        elseif (~ismember(step_time,baby_movement) & ~ismember(step_time,mom_movement))
            mom_baby_moving_case = [mom_baby_moving_case; 4];
            mom_baby_dist(c)=mom_baby_dist(c-1);
        end
    end
    
    % determines the color in the figure
    prev_c='y';
    for ii=2:length(mom_baby_moving_case)
        if (mom_baby_moving_case(ii)==1)
            c='r';
        elseif (mom_baby_moving_case(ii)==2)
            c='b';
        elseif (mom_baby_moving_case(ii)==3)
            c='g';
        elseif (mom_baby_moving_case(ii)==4 & mom_baby_moving_case(ii-1)==4)
            c='y';
        end
        
        % it's not the same color
        if (~strcmp(c,prev_c))
            if (strcmp(prev_c,'r'))
                mom_baby_dist_by_stats_segmants(md,1)=mom_baby_dist_by_stats_segmants(md,1)+1;
                prev_prev_seg=prev_seg;
                prev_seg=1;
            elseif (strcmp(prev_c,'b'))
                mom_baby_dist_by_stats_segmants(md,2)=mom_baby_dist_by_stats_segmants(md,2)+1;
                prev_prev_seg=prev_seg;
                prev_seg=2;
            elseif (strcmp(prev_c,'g'))
                mom_baby_dist_by_stats_segmants(md,3)=mom_baby_dist_by_stats_segmants(md,3)+1;
                prev_prev_seg=prev_seg;
                prev_seg=3;
            elseif (strcmp(prev_c,'y'))        
                mom_baby_dist_by_stats_segmants(md,4)=mom_baby_dist_by_stats_segmants(md,4)+1;
                last_segment_size=segment_size;
                segment_size = 0;
                prev_prev_seg=prev_seg;
                prev_seg=4;
            end
        else
            if ((strcmp(prev_c,'y')))
                segment_size = segment_size + 1;
                last_segment_size=0;
            end
        end
            
        % determines which color it is
        if (strcmp(c,'r'))
            mom_baby_dist_by_stats_total_distance(md,1) = mom_baby_dist_by_stats_total_distance(md,1)+abs(mom_baby_dist(ii)-mom_baby_dist(ii-1));
            % determines if it's an increase or decrease 
            % increase
            if (mom_baby_dist(ii-1)<mom_baby_dist(ii))
                mom_baby_dist_by_stats_getting_further(md,1) = mom_baby_dist_by_stats_getting_further(md,1)+mom_baby_dist(ii)-mom_baby_dist(ii-1);
                mom_baby_dist_by_stats_segmants_further(md,1) = mom_baby_dist_by_stats_segmants_further(md,1)+1;
            % decrease
            elseif (mom_baby_dist(ii-1)>mom_baby_dist(ii))
                mom_baby_dist_by_stats_getting_closer(md,1) = mom_baby_dist_by_stats_getting_closer(md,1)+abs(mom_baby_dist(ii)-mom_baby_dist(ii-1));
                mom_baby_dist_by_stats_segmants_closer(md,1) = mom_baby_dist_by_stats_segmants_closer(md,1)+1;
            end
            
            % to check who started to walk after both stationary
            if (prev_prev_seg==4 & prev_seg==3)
               from_stationary_result(md,1)=from_stationary_result(md,1)+1; 
            end
            
            if (prev_prev_seg==4 & prev_seg==3 & last_segment_size>30)
               from_stationary_result_30(md,1)=from_stationary_result_30(md,1)+1; 
            end
            
            if (prev_prev_seg==4 & prev_seg==3 & last_segment_size>50)
               from_stationary_result_50(md,1)=from_stationary_result_50(md,1)+1; 
            end
            
            % to check who started to walk after both stationary
            if (prev_prev_seg==4 & prev_seg==2)
               from_stationary_result(md,2)=from_stationary_result(md,2)+1; 
            end
            
            if (prev_prev_seg==4 & prev_seg==2 & last_segment_size>30)
               from_stationary_result_30(md,2)=from_stationary_result_30(md,2)+1; 
            end
            
            if (prev_prev_seg==4 & prev_seg==2 & last_segment_size>50)
               from_stationary_result_50(md,2)=from_stationary_result_50(md,2)+1; 
            end
            
        elseif (strcmp(c,'b'))
            mom_baby_dist_by_stats_total_distance(md,2) = mom_baby_dist_by_stats_total_distance(md,2)+abs(mom_baby_dist(ii)-mom_baby_dist(ii-1));
            if (mom_baby_dist(ii-1)<mom_baby_dist(ii))
                mom_baby_dist_by_stats_getting_further(md,2) = mom_baby_dist_by_stats_getting_further(md,2)+mom_baby_dist(ii)-mom_baby_dist(ii-1);
                mom_baby_dist_by_stats_segmants_further(md,2) = mom_baby_dist_by_stats_segmants_further(md,2)+1;
            elseif (mom_baby_dist(ii-1)>mom_baby_dist(ii))
                mom_baby_dist_by_stats_getting_closer(md,2) = mom_baby_dist_by_stats_getting_closer(md,2)+abs(mom_baby_dist(ii)-mom_baby_dist(ii-1));
                mom_baby_dist_by_stats_segmants_closer(md,2) = mom_baby_dist_by_stats_segmants_closer(md,2)+1;
            end
            
            % to check who started to walk after both stationary
            if (prev_prev_seg==4 & prev_seg==3)
               from_stationary_result(md,1)=from_stationary_result(md,1)+1; 
            end
            
            if (prev_prev_seg==4 & prev_seg==3 & last_segment_size>30)
               from_stationary_result_30(md,1)=from_stationary_result_30(md,1)+1; 
            end
            
            if (prev_prev_seg==4 & prev_seg==3 & last_segment_size>50)
               from_stationary_result_50(md,1)=from_stationary_result_50(md,1)+1; 
            end
        elseif (strcmp(c,'g'))
            mom_baby_dist_by_stats_total_distance(md,3) = mom_baby_dist_by_stats_total_distance(md,3)+abs(mom_baby_dist(ii)-mom_baby_dist(ii-1));
            if (mom_baby_dist(ii-1)<mom_baby_dist(ii))
                mom_baby_dist_by_stats_getting_further(md,3) = mom_baby_dist_by_stats_getting_further(md,3)+mom_baby_dist(ii)-mom_baby_dist(ii-1);
                mom_baby_dist_by_stats_segmants_further(md,3) = mom_baby_dist_by_stats_segmants_further(md,3)+1;
            elseif (mom_baby_dist(ii-1)>mom_baby_dist(ii))
                mom_baby_dist_by_stats_getting_closer(md,3) = mom_baby_dist_by_stats_getting_closer(md,3)+abs(mom_baby_dist(ii)-mom_baby_dist(ii-1));
                mom_baby_dist_by_stats_segmants_closer(md,3) = mom_baby_dist_by_stats_segmants_closer(md,3)+1;
            end
            
            % to check who started to walk after both stationary
            if (prev_prev_seg==4 & prev_seg==2)
               from_stationary_result(md,2)=from_stationary_result(md,2)+1; 
            end
            
            if (prev_prev_seg==4 & prev_seg==2 & last_segment_size>30)
               from_stationary_result_30(md,2)=from_stationary_result_30(md,2)+1; 
            end
            
            if (prev_prev_seg==4 & prev_seg==2 & last_segment_size>50)
               from_stationary_result_50(md,2)=from_stationary_result_50(md,2)+1; 
            end
        end
        plot([ii-1 ii],[mom_baby_dist(ii-1) mom_baby_dist(ii)],'Color',c,'Linewidth',1.5);
        prev_c = c;
        hold on
    end
    
    % prints the trajectory figure
    ylim([0 600]);
    ylabel('Mom-Baby distance (cm)');
    set(gca, 'XTick',[1:600:length(mom_baby_moving_case)]);
    set(gca, 'XTickLabel',strread(num2str(round([1:600:length(mom_baby_moving_case)]./600)),'%s')');
    xlabel('Session duration (minutes)');
    fig.Color = colors(cl(md),:);
    fig.InvertHardcopy = 'off';
    set(fig,'PaperUnits','centimeters','PaperPosition',[0 0 30 20])
    print('-dpng', fullfile('NewResults','MovementFigures',['mom_baby_distances_movement_subj' num2str(subject_order_s(md)) '.png']), '-r300');
    dists{md} = mom_baby_dist;
    close all;
    
    mom_baby_moving_case_no_stationary = mom_baby_moving_case(mom_baby_moving_case~=4);
    
    % saves trajectory information
    all_subjects_moving_case = [all_subjects_moving_case; ...
                                length(mom_baby_moving_case_no_stationary(mom_baby_moving_case_no_stationary==1))/length(mom_baby_moving_case_no_stationary)*100 ...
                                length(mom_baby_moving_case_no_stationary(mom_baby_moving_case_no_stationary==2))/length(mom_baby_moving_case_no_stationary)*100 ...
                                length(mom_baby_moving_case_no_stationary(mom_baby_moving_case_no_stationary==3))/length(mom_baby_moving_case_no_stationary)*100];
end

save(fullfile(data_dir,'mom_baby_dist_changes_stats_only_elevation.mat'),'mom_baby_dist_by_stats_total_distance', ...
    'mom_baby_dist_by_stats_segmants','mom_baby_dist_by_stats_getting_closer','mom_baby_dist_by_stats_getting_further','mom_baby_dist_by_stats_segmants_further','mom_baby_dist_by_stats_segmants_closer','dists','all_subjects_moving_case');
