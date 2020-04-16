function PrintTrajectoriesWithTime(figures_dir, mom_baby_movement_times, resampled_data_csv_file, dyad_stats_csv_file)
% PrintTrajectoriesWithTime prints the mother and baby paths 
%
%% Syntax
% PrintTrajectoriesWithTime(figures_dir, mom_baby_movement_times, resampled_data_csv_file, dyad_stats_csv_file)
%
%% Description
% PrintTrajectoriesWithTime gets csv files from datavyu and from digitizing procedure
% and prints the mother and infant paths at the 100ms time scale. The
% printed path also shows movement in time, going from one color to the
% other. 
%
% Required Input.
% figures_dir: directory for saving the figures
% mom_baby_movement_times: a MATLAB structure with mom and baby moveemnt times
% resampled_data_file: MAT file that includes data resmpling for mom and baby location in the room every 100ms
% dyad_stats_file: CSV file from datavyu with session level stats per dyad


% sets the edge colors for the path (in terms of time)
start_color = [1,50,255]/255;
end_color = [252,78,42]/255; 

% loads the csv files
moms_stats  = csvimport(dyad_stats_csv_file);
mom_baby_data = csvimport(resampled_data_csv_file);
moms_data = cell2mat(moms_stats(2:end,2:3));
mom_baby_num_data = cell2mat(mom_baby_data(2:end,2:end));

% going over babies (1) and mothers (2) data 
for baby_or_mother=1:2
    
    % go over all dyads
    for dyad_id=1:size(moms_data,1)
        
        % creates a figure for the path
        fig = figure('renderer','painters');
        
        % gets the relevant dyad data
        sub_data = mom_baby_num_data(mom_baby_num_data(:,1)==moms_data(dyad_id,1),:);
        
        % gets the mother and baby paths
        baby_sub_data = sub_data(:,4:5);
        mom_sub_data = sub_data(:,6:7);
        time = sub_data(:,3);
        
        % gets the movement time for baby and for mother spereately 
        baby_movement_time = mom_baby_movement_times{dyad_id,1};
        mom_movement_time = mom_baby_movement_times{dyad_id,2};
        mom_baby_moving_case = [];
        
        % go over every 100ms and prints the location of mother and baby
        for c=2:length(time)
            step_time = round((time(c)+time(c-1))/2);
            if (ismember(step_time,baby_movement_time) & ismember(step_time,mom_movement_time))
                mom_baby_moving_case = [mom_baby_moving_case; 1];
            elseif (~ismember(step_time,baby_movement_time) & ismember(step_time,mom_movement_time))
                mom_baby_moving_case = [mom_baby_moving_case; 2];
            elseif (ismember(step_time,baby_movement_time) & ~ismember(step_time,mom_movement_time))
                mom_baby_moving_case = [mom_baby_moving_case; 3];
            elseif (~ismember(step_time,baby_movement_time) & ~ismember(step_time,mom_movement_time))
                mom_baby_moving_case = [mom_baby_moving_case; 4];
            end
        end

        % sets the colors (representing time within the session
        color_length = size(mom_baby_moving_case,1);
        colors_p = [linspace(start_color(1),end_color(1),color_length)', ...
                    linspace(start_color(2),end_color(2),color_length)', ...
                    linspace(start_color(3),end_color(3),color_length)'];

        % determines whether printing mom or baby
        for ii=2:size(mom_baby_moving_case,1)
            c=colors_p(ii,:);
            if (baby_or_mother==1)
                plot([baby_sub_data(ii-1,1) baby_sub_data(ii,1)],[baby_sub_data(ii-1,2) baby_sub_data(ii,2)],'Color',c,'Linewidth',3.5);
            else
                plot([mom_sub_data(ii-1,1) mom_sub_data(ii,1)],[mom_sub_data(ii-1,2) mom_sub_data(ii,2)],'Color',c,'Linewidth',3.5);
            end

            hold on
        end
        
        % sets other figure proprties
        ylim([0 900]);
        xlim([0 600]);
        ylabel('Y coordinate');
        xlabel('X coordinate');
        fig.Color = [1 1 1];
        fig.InvertHardcopy = 'off';
        set(fig,'PaperUnits','centimeters','PaperPosition',[0 0 30 20])
        
        % print the paths to a EPS file
        if (baby_or_mother==1)
            print('-depsc', fullfile(figures_dir,['S#' num2str(dyad_id) 'b_both_move.eps']), '-r300');
        else
            print('-depsc', fullfile(figures_dir,['S#' num2str(dyad_id) 'm_both_move.eps']), '-r300');
        end
        close all;
    end
end