function CalcGrangerCausalityInJointSegments(data_dir, mom_baby_both_movement_file, subject_numbers, max_time_lags)
% CalcGrangerCausalityInBothSegments calculates who "led" a joint movement
% based on Granger Causality calculation
%
%% Syntax
% CalcGrangerCausalityInJointSegments(data_dir, mom_baby_both_movement_file, subject_numbers, max_time_lags)
%
%% Description
% GrangerCausality run Granger causality on joint segments from all dyads.
% It calculates whether one of the partners led the joint segment. It
% counts only "conclusive" leaders. Conclusive leader Granger cause the
% other partner in at least one dimension and the other partner does not
% granger cause in both dimensions
%
% Required Input.
% data_dir: data directory to save Granger causality results
% mom_baby_both_movement_file: file containing the dyad trajectories in
% space for joint movements
% subject_numbers: dyads IDs
% max_time_lags: The maximumg time lag for the granger causality calculation

% loads the joint segments from all dyads
load(mom_baby_both_movement_file);

% set up results arrays 
segements_counters=[];
causality_times = [];
causality_vals_baby = zeros(size(baby_move_both,1),1);
causality_vals_mom = zeros(size(baby_move_both,1),1);

% go over all dyads
for sub=1:size(baby_move_both,1)
    segments_counter = 1;
    
    % go over all joint segments
    for joint_segment=1:size(baby_move_both,2)

        % gets the spatial and temporal data for the segment
        baby_data = mom_move_both{sub,joint_segment};
        mom_data = baby_move_both{sub,joint_segment};
        time_data = time_move_both{sub,joint_segment};

        if (~isempty(time_data))
            
            % x causality mom->baby
            [F_x_baby,c_v_x_baby] = granger_cause(baby_data(:,1),mom_data(:,1),0.05,max_time_lags);

            % y causality mom->baby
            [F_y_baby,c_v_y_baby] = granger_cause(baby_data(:,2),mom_data(:,2),0.05,max_time_lags);

            % x causality baby->mom
            [F_x_mom,c_v_x_mom] = granger_cause(mom_data(:,1),baby_data(:,1),0.05,max_time_lags);

            % y causality baby->mom
            [F_y_mom,c_v_y_mom] = granger_cause(mom_data(:,2),baby_data(:,2),0.05,max_time_lags);

            % Mom led baby to move
            if ((F_x_baby>c_v_x_baby | F_y_baby>c_v_y_baby) & ~(F_x_mom>c_v_x_mom | F_y_mom>c_v_y_mom))
               causality_vals_baby(sub)  = causality_vals_baby(sub)+1;
               onset = time_data(1);
               offset = time_data(end);
               causality_times = [causality_times; subject_numbers(sub) 1 onset offset];
            end

            % Baby led mom to move
            if ((F_x_mom>c_v_x_mom | F_y_mom>c_v_y_mom) & ~(F_x_baby>c_v_x_baby | F_y_baby>c_v_y_baby))
               causality_vals_mom(sub)  = causality_vals_mom(sub)+1;
               onset = time_data(1);
               offset = time_data(end);
               causality_times = [causality_times; subject_numbers(sub) 2 onset offset];
            end
            segments_counter = segments_counter +1;
        end
    end
    
    % calculates the percentage of baby led and mom led from all joint
    % movements (that have data
    causality_vals_baby(sub) = causality_vals_baby(sub)/segments_counter*100;
    causality_vals_mom(sub) = causality_vals_mom(sub)/segments_counter*100;
    segements_counters(sub) = segments_counter;
end

% saves granger-causality results to mat file
save(fullfile(data_dir,'granger_causality_resutls.mat'));