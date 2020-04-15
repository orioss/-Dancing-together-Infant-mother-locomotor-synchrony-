function [dist_cl]=ClusteringAccordingToDistanceChange(data_file)
% ClusteringAccordingToDistanceChange is the main script to group dyads
% into clusters based on the change in distance between them throughout the
% session
%
%% Syntax
% ClusteringAccordingToDistanceChange(data_file)
%
%% Description
% ClusteringAccordingToDistanceChange gets a data file with the changes
% between partners, calculates the similarity between all dyads according
% to the change in distance between the partners and performs density-peak
% clustering to cluster the dyads to groups
%
% Required Input.
% data_file: data_file with the changes in distance between the mom and
% the baby.
%
% Output.
% dist_cl: array with all the clusters according to the change in distance
load(data_file)

% calculates the percentage of distance change to use for similarity (how
% much the mom and baby got closer and further and in which condition).
% Data file should already include all the conditions according to the
% order: distance closter-baby move | distance closer-mom move | distance
% closer both move| distance further-baby move | distance further-mom move | distance
% further both move| 
subject_time_patterns = [mom_baby_dist_by_stats_segmants_closer./(sum(mom_baby_dist_by_stats_segmants_closer,2)) ...
                         mom_baby_dist_by_stats_segmants_further./(sum(mom_baby_dist_by_stats_segmants_further,2))];

clear mom_baby_dist_by_stats_getting_closer mom_baby_dist_by_stats_getting_further mom_baby_dist_by_stats_segmants_closer mom_baby_dist_by_stats_segmants_further

% Cluster subject based on similarity between them
[dist_cl]=ClusterSubjectsPeakDensity(pdist(subject_time_patterns),3);