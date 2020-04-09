%clear; clc; close all;
colors = [255,245,240;254,224,210;252,187,161;252,146,114;251,106,74;239,59,44;203,24,29;165,15,21;103,0,13];
colors = colors ./255;
load('DTW_2SecondsResolution.mat');
[sim_diag,sim_diag_I] = sort(diag(sim_mat))
sim_mat_sorted=sim_mat(sim_diag_I,sim_diag_I);
imagesc(1./sim_mat_sorted,[0.005 0.035]);
colormap(colors);



  sim_mat(~eye(size(sim_mat)))
   
[h,p,ci,stats]= tttest2(diag(sim_mat),sim_mat(~eye(size(sim_mat))))

