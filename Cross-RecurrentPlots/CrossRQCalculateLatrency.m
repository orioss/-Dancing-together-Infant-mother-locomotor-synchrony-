
clear;clc;close all;
load('NewResults\mom_baby_movement_raster_plot.mat');
load('NewResults\clustered_moms.mat');
baby_colors = [255,245,235;254,230,206;253,208,162;253,174,107;253,141,60;241,105,19;;217,72,1;166,54,3;127,39,4];
baby_colors = baby_colors ./255;
mom_colors = [255,255,229;247,252,185;217,240,163;173,221,142;120,198,121;65,171,93;35,132,67;0,104,55;0,69,41];
mom_colors = mom_colors ./255;
colors = [1 1 1; 0.6 0.6 0.6; 0 0 0];
latencies = [];
latencies_for_ANOVA=[];
latencies_CHECK=[];
who_initiated_for_ANOVA=zeros(size(mom_baby_all,1),2);
for subj=1:size(mom_baby_all,1)
   infant_latencies=[];
   mother_latencies=[];
   diags_to_check = {};
   disp(['Analyzing subject:  ' num2str(subj)]);
   baby_data = mom_baby_all{subj,1};
   baby_data = downsample(baby_data, 100);
   mom_data = mom_baby_all{subj,2};
   mom_data = downsample(mom_data, 100);
   shared_movements=mom_data'*baby_data;
   CC = bwconncomp(shared_movements);
   shared_movements_diag = shared_movements;
   size_shared = size(shared_movements);
   cluser_nums = [];
   Is = [];
   for c = 1:CC.NumObjects  
       
       % get the cluster indices
       cluster_idx = CC.PixelIdxList{c};
       [I1,I2] = ind2sub(size_shared,cluster_idx(:));
       if (~(length(cluster_idx)<10 || length(find([I2-I1]==0))==0))
            Is=[Is; I1(1) I2(1)];
       end
   end

   plot(Is(:,2),Is(:,1),'bx');
   hold on;
   shifts = [-250:50:250];
  for shift_ix=1:length(shifts)-1
      first_shift = shifts(shift_ix);
      second_shift = shifts(shift_ix+1);
      if (second_shift <=0)
        polygonx = [0 size_shared(1)-abs(first_shift) size_shared(1)-abs(second_shift) 0];
        polygony = [abs(first_shift) size_shared(1) size_shared(1) abs(second_shift)];
      else
        polygonx = [abs(first_shift) size_shared(1) size_shared(1) abs(second_shift)];
        polygony = [0 size_shared(1)-abs(first_shift) size_shared(1)-abs(second_shift) 0];
      end
      k = convhull(polygonx,polygony); 
      plot(polygonx(k),polygony(k),'linewidth',0.1)
      in = inpolygon(Is(:,2),Is(:,1),polygonx(k),polygony(k)); 
      plot(Is(in,2),Is(in,1),'ro') 
      latency = Is(in,1)-Is(in,2);
      latencies = [latencies; latency];
      for l_ix=1:length(latency)
          curr_latency = latency(l_ix);
          if (curr_latency>0)
              mother_latencies = [mother_latencies; curr_latency];
              who_initiated_for_ANOVA(subj,2)=who_initiated_for_ANOVA(subj,2)+1;
          elseif (curr_latency<0)
              infant_latencies = [infant_latencies; abs(curr_latency)];
              who_initiated_for_ANOVA(subj,1)=who_initiated_for_ANOVA(subj,1)+1;
          end
      end
       % check if the cluster indices intersect with the diagonal, AND
       % this cluster was not taken previously 
  end
  latencies_for_ANOVA = [latencies_for_ANOVA; subj cl(subj) mean(infant_latencies) mean(mother_latencies)];
  latencies_CHECK=[infant_latencies; mother_latencies];
end
figure;
[N,X] = hist(latencies,200);
Bh = bar(X,N,'facecolor',[1 0 0]);
xlim([-250 250]);
ylim([0 70]);