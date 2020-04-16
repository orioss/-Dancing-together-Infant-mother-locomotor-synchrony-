function PlotSimilairtyMatrix(DTW_result_file)
% PlotSimilairtyMatrixprints the similarity matrix between babies and moms
%
%% Syntax
% PlotSimilairtyMatrix(DTW_result_file)
%
%% Description
% PlotSimilairtyMatrix gets the MAT file with the DTW results and prints
% the similarity matrix
%
% Required Input.
% DTW_result_file: MAT file including the DTW results (distance between
% each pair of mother-infant
% 

% sets color for the matrix
colors = [255,245,240;254,224,210;252,187,161;252,146,114;251,106,74;239,59,44;203,24,29;165,15,21;103,0,13];
colors = colors ./255;

% loads the DTW results
load(DTW_result_file);

% print the DTW matrix
[sim_diag,sim_diag_I] = sort(diag(sim_mat))
sim_mat_sorted=sim_mat(sim_diag_I,sim_diag_I);
imagesc(1./sim_mat_sorted,[0.005 0.035]);
colormap(colors);

% calculate ttest between similarity between baby and mom within dyad and
% baby with other moms
sim_mat(~eye(size(sim_mat)))  
[h,p,ci,stats]= tttest2(diag(sim_mat),sim_mat(~eye(size(sim_mat))))

