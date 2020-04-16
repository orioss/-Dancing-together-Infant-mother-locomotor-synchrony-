function [mom_baby_movement_times]=ImportMomBabyMovementTimesFromDatavyu(dyad_stats_file, baby_bouts_csv_file, mom_bouts_csv_file)
% ImportMomBabyMovementTimesFromDatavyu creates a MATLAB mom-baby movement
% structure from the datavyu output. The function should run on floor
% only, elevation only or both. Depends on the required analysis.
%
%% Syntax
% [mom_baby_movement_times]=ImportMomBabyMovementTimesFromDatavyu(base_dir, dyad_stats_file, baby_bouts_csv_file, mom_bouts_csv_file)
%
%% Description
% ImportMomBabyMovementTimesFromDatavyu gets a CSV file with the dyad statistics
% from datavyu and a CSV with details about the mom and baby bouts (times) and
% create a MATLAB structure with the times of movement that will be used by
% the rest of the functions. This function should be run SEPERATELY on
% floor-only data, elevation-only data, and both. The created structure
% will be used by other functions in the Spatial-Temporal Analysis and
% Cross-Recurrent plots.
%
% Required Input.
% base_dir: output directory to create MAT file per dyad.
% dyad_stats_file: CSV file from datavyu with session level stats per dyad
% baby_bouts_csv_file: CSV file from datavyu with bout level details per baby
% mom_bouts_csv_file: CSV file from datavyu with bout level details per mother
%
% Output.
% mom_baby_movement_times: a MATLAB structure with mom and baby moveemnt times
% 

% import mother and baby data from CSV files
moms_stats  = csvimport(dyad_stats_file);
moms_data = cell2mat(moms_stats(2:end,2));
baby_times_data = csvimport(baby_bouts_csv_file);
baby_times_data = baby_times_data(2:end,2:5);
baby_times_data = cell2mat(baby_times_data);
mom_times_data = csvimport(mom_bouts_csv_file);
mom_times_data = mom_times_data(2:end,2:5);
mom_times_data = cell2mat(mom_times_data );

% go over all dyads
for i=1:size(moms_data,1)
    
    % gets the dyad movement data
    dyad_id = moms_data(i);
    subj_baby_times_data = baby_times_data(baby_times_data(:,1)==dyad_id,3:4);
    subj_mom_times_data = mom_times_data(mom_times_data(:,1)==dyad_id,3:4);
    baby_movement =  [];
    mom_movement = [];
    
    % construct a serial array with the times of baby movement and mother
    % movement
    for ii=1:size(subj_baby_times_data,1)
        baby_movement = [baby_movement subj_baby_times_data(ii,1):subj_baby_times_data(ii,2)]; 
    end
    for ii=1:size(subj_mom_times_data ,1)
        mom_movement = [mom_movement subj_mom_times_data(ii,1):subj_mom_times_data(ii,2)]; 
    end
    mom_baby_movement_times{i,1}=baby_movement;
    mom_baby_movement_times{i,2}=mom_movement ;
end
