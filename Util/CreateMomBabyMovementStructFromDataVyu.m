clear;clc;
base_dir = 'NewData';
files=dir(base_dir);
moms_stats  = csvimport('NewData\MomStats.csv');
%load('mom_touch.mat');
moms_data = cell2mat(moms_stats(2:end,2));
%baby_times_data = csvimport('C:\Users\orios\Desktop\University\Post\StudiesCurrent\MomBaby\Analysis\NewData\CheckData\boutlevel.csv');
baby_times_data = csvimport(fullfile(base_dir, 'BabyBouts_Only_Elevations.csv'));
baby_times_data = baby_times_data(2:end,2:5);
baby_times_data = cell2mat(baby_times_data);
mom_times_data = csvimport(fullfile(base_dir, 'MomBouts_Only_Elevations.csv'));
mom_times_data = mom_times_data(2:end,2:5);
mom_times_data = cell2mat(mom_times_data );

for i=1:size(moms_data,1)
    dyad_id = moms_data(i);
    subj_baby_times_data = baby_times_data(baby_times_data(:,1)==dyad_id,3:4);
    subj_mom_times_data = mom_times_data(mom_times_data(:,1)==dyad_id,3:4);
    baby_movement =  [];
    mom_movement = [];
    for ii=1:size(subj_baby_times_data,1)
        baby_movement = [baby_movement subj_baby_times_data(ii,1):subj_baby_times_data(ii,2)]; 
    end
    for ii=1:size(subj_mom_times_data ,1)
        mom_movement = [mom_movement subj_mom_times_data(ii,1):subj_mom_times_data(ii,2)]; 
    end
    mom_baby_movements{i,1}=baby_movement;
    mom_baby_movements{i,2}=mom_movement ;
end

save('NewResults\mom_baby_movement_times_only_only_elevation.mat','mom_baby_movements');
    