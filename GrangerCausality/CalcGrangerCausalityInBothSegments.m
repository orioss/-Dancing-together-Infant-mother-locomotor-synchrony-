clear;
clc;
load(fullfile('NewResults','clustered_moms.mat'));
%load(fullfile('NewResults','mom_baby_movement_during_both.mat'));
load(fullfile('NewResults','mom_baby_movement_atleast_one.mat'));
baby_stats_nums = csvimport(fullfile('NewData','BabyStats.csv'));
baby_stats_numbers =  cell2mat(baby_stats_nums(2:end,2));
segements_counters=[];
res_cause=[];
res_cause_or=[];
causality_times = [];
for mst=30:5:50
    for ws=1:5:50
        window_size = ws;
        minimal_segment_time = mst;
        causality_vals_baby = zeros(size(baby_move_both,1),1);
        causality_vals_mom = zeros(size(baby_move_both,1),1);
        causality_touch_mom = zeros(size(baby_move_both,1),3);
        for sub=1:size(baby_move_both,1)
            segments_counter = 1;
            for segment=1:size(baby_move_both,2)

                baby_data = mom_move_both{sub,segment};
                mom_data = baby_move_both{sub,segment};
                time_data = time_move_both{sub,segment};

                if (~isempty(time_data) && (length(time_data)>=minimal_segment_time))
                    % x causality mom->baby
                    [F_x_baby,c_v_x_baby] = granger_cause(baby_data(:,1),mom_data(:,1),0.05,window_size);

                    % y causality mom->baby
                    [F_y_baby,c_v_y_baby] = granger_cause(baby_data(:,2),mom_data(:,2),0.05,window_size);

                    % x causality baby->mom
                    [F_x_mom,c_v_x_mom] = granger_cause(mom_data(:,1),baby_data(:,1),0.05,window_size);

                    % y causality baby->mom
                    [F_y_mom,c_v_y_mom] = granger_cause(mom_data(:,2),baby_data(:,2),0.05,window_size);

                    % Mom caused baby to move
                    if ((F_x_baby>c_v_x_baby | F_y_baby>c_v_y_baby) & ~(F_x_mom>c_v_x_mom | F_y_mom>c_v_y_mom))
                       causality_vals_baby(sub)  = causality_vals_baby(sub)+1;
                       %causality_touch_mom(sub,1)=causality_touch_mom(sub,1)+1;
                       onset = time_data(1);
                       offset = time_data(end);
                       causality_times = [causality_times; baby_stats_numbers(sub) 1 onset offset];
                    end

                    % Baby caused mom to move
                    if ((F_x_mom>c_v_x_mom | F_y_mom>c_v_y_mom) & ~(F_x_baby>c_v_x_baby | F_y_baby>c_v_y_baby))
                       causality_vals_mom(sub)  = causality_vals_mom(sub)+1;
                       onset = time_data(1);
                       offset = time_data(end);
                       causality_times = [causality_times; baby_stats_numbers(sub) 2 onset offset];
                       %causality_touch_mom(sub,2)=causality_touch_mom(sub,2)+1;
                    end

                    if (~(F_x_mom>c_v_x_mom | F_y_mom>c_v_y_mom) & ~(F_x_baby>c_v_x_baby | F_y_baby>c_v_y_baby))
                        %causality_touch_mom(sub,3)=causality_touch_mom(sub,3)+1;
                    end
                    segments_counter = segments_counter +1;
                end
            end

            causality_vals_baby(sub) = causality_vals_baby(sub)/segments_counter*100;
            causality_vals_mom(sub) = causality_vals_mom(sub)/segments_counter*100;
            segements_counters(sub) = segments_counter;
        end
        causality_vals_baby_all(:,ws,mst) = causality_vals_baby;
        causality_vals_mom_all(:,ws,mst) = causality_vals_mom;
        res_cause = [res_cause; mst ws mean(causality_vals_baby) std(causality_vals_baby) mean(causality_vals_mom) std(causality_vals_mom) mean(causality_vals_baby+causality_vals_mom) std(causality_vals_baby+causality_vals_mom) min(segements_counters) max(segements_counters) sum(segements_counters)];
 %       optimal_bin(mst, ws) = mean(causality_vals_baby+causality_vals_mom);
    end
    save(['done-' num2str(mst) '.mat'],'ws');
	save(fullfile('NewResults','causality_times_best_LAST.mat'),'causality_times','res_cause');
end
%save('all_granger_times.mat');