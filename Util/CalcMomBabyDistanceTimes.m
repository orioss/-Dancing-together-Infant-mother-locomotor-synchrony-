clear; clc;
load(fullfile('NewResults','mom_baby_dist_changes_stats_only_elevation.mat'));
load('NewResults\clustered_moms.mat');
distance_by_time_limits = 0:20:200;
distance_by_time_1 = zeros(5,length(distance_by_time_limits));
distance_by_time_2 = zeros(15,length(distance_by_time_limits));
distance_by_time_3 = zeros(10,length(distance_by_time_limits));
distances_for_ANOVA=[];
for floor_or_elev=1:2
    if (floor_or_elev==1)
        load(fullfile('NewResults','mom_baby_dist_changes_stats_only_floor.mat'));
    else
        load(fullfile('NewResults','mom_baby_dist_changes_stats_only_elevation.mat'));
    end
    for cluster=1:3
        cluster_data = dists(cl==cluster);
        for i=1:length(cluster_data)
            sub_dist = cluster_data{i};
            for d=1:length(sub_dist)
               for dl=1:length(distance_by_time_limits)-1
                   if (dl==length(distance_by_time_limits))
                       if (sub_dist(d)>distance_by_time_limits(dl))
                        eval(['distance_by_time_' num2str(cluster) '(i,dl) = distance_by_time_' num2str(cluster) '(i,dl)+1;']);
                       end
                   else
                     if (sub_dist(d)<distance_by_time_limits(dl+1) & sub_dist(d)>distance_by_time_limits(dl))
                         eval(['distance_by_time_' num2str(cluster) '(i,dl) = distance_by_time_' num2str(cluster) '(i,dl)+1;']);
                    end
                   end
               end
            end
            distances_for_ANOVA=[distances_for_ANOVA; subject_counter floor_or_elev cluster mean(sub_dist)];
        end
    end
%     distance_by_time_1_percent=distance_by_time_1./sum(distance_by_time_1,2)*100;
%     distance_by_time_2_percent=distance_by_time_2./sum(distance_by_time_2,2)*100;
%     distance_by_time_3_percent=distance_by_time_3./sum(distance_by_time_3,2)*100;
% 
%     % Graphs:
%     f1=figure;
%     x = linspace(0,1,11);
%     y1 = mean(distance_by_time_1_percent);
%     z1 = std(distance_by_time_1_percent)./size(distance_by_time_1_percent,1);
%     confplot(x,y1,z1,z1,'Color',[1 0 0],'LineWidth',2,[255 225 225]./255);
%     xticklabels([0:20:200]);
%     xticklabels([0:20:200]);
%     ylim([0 30]);
%     print(f1,['C:\Users\orios\Desktop\MomBaby\Figures_v4\Figure4\DistanceFigures\low_activity_only_' num2str(floor_or_elev) '.eps'],'-depsc');
% 
%     f2=figure;
%     y2 = mean(distance_by_time_2_percent);
%     z2 = std(distance_by_time_2_percent)./size(distance_by_time_2_percent,1);
%     confplot(x,y2,z2,z2,'Color',[0 1 0],'LineWidth',2,[212 255 226]./255);
%     xticklabels([0:20:200]);
%     ylim([0 30]);
%     print(f2,['C:\Users\orios\Desktop\MomBaby\Figures_v4\Figure4\DistanceFigures\med_activity_only_' num2str(floor_or_elev) '.eps'],'-depsc');
% 
%     f3=figure;
%     y3 = mean(distance_by_time_3_percent);
%     z3 = std(distance_by_time_3_percent)./size(distance_by_time_3_percent,1);
%     confplot(x,y3,z3,z3,'Color',[0 0 1],'LineWidth',2,[210 224 255]./255);
%     xticklabels([0:20:200]);
%     ylim([0 30]);
%     print(f3,['C:\Users\orios\Desktop\MomBaby\Figures_v4\Figure4\DistanceFigures\high_activity_only_' num2str(floor_or_elev) '.eps'],'-depsc');
end

%% OLD CODE:
% distance_by_time(1,:) = distance_by_time(1,:,1)./sum(distance_by_time(1,:,1));
% distance_by_time(2,:) = distance_by_time(2,:)./sum(distance_by_time(2,:));
% distance_by_time(3,:) = distance_by_time(3,:)./sum(distance_by_time(3,:));
% distance_by_time_all = distance_by_time(1,:)+ distance_by_time(2,:)+ distance_by_time(3,:);
% [p1,~,mu1] = polyfit(1:length(distance_by_time_limits)-1, distance_by_time(1,:), 10);
% [p2,~,mu2] = polyfit(1:length(distance_by_time_limits)-1, distance_by_time(2,:), 10);
% [p3,~,mu3] = polyfit(1:length(distance_by_time_limits)-1, distance_by_time(3,:), 10);
% f1 = polyval(p1,1:length(distance_by_time_limits)-1,[],mu1);
% f2 = polyval(p2,1:length(distance_by_time_limits)-1,[],mu2);
% f3 = polyval(p3,1:length(distance_by_time_limits)-1,[],mu3);
% [p,~,mu] = polyfit(1:length(distance_by_time_limits)-1, distance_by_time_all, 15);
% f = polyval(p,1:length(distance_by_time_limits)-1,[],mu);
% 
% % plot(1:length(distance_by_time_limits)-1,f,'linewidth',4)
% %hold on
% %plot(1:length(distance_by_time_limits)-1,distance_by_time_all ,'k.', 'markersize', 20);
% 
% 
%  figure;
%  
%  plot(1:length(distance_by_time_limits)-1,distance_by_time(1,:),'r.', 'markersize', 35);
% hold on
%  plot(1:length(distance_by_time_limits)-1,f1,'linewidth',3,'color','r')
%  plot(1:length(distance_by_time_limits)-1,distance_by_time(2,:),'g.', 'markersize', 35);
%  plot(1:length(distance_by_time_limits)-1,f2,'linewidth',3,'color','g')
%  plot(1:length(distance_by_time_limits)-1,distance_by_time(3,:),'b.','markersize', 35);
%  plot(1:length(distance_by_time_limits)-1,f3,'linewidth',3,'color','b')
%  ylim([0 0.25])
% %close all;
