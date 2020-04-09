clear; clc; close all;
load('NewResults\clustered_moms.mat');
distance_by_time_limits = 0:20:200;
distance_by_time_1 = zeros(5,length(distance_by_time_limits));
distance_by_time_2 = zeros(15,length(distance_by_time_limits));
distance_by_time_3 = zeros(10,length(distance_by_time_limits));
colors={'r','g','b'};
load(fullfile('NewResults','mom_baby_dist_changes_stats_only_floor.mat'));

%for cluster=1:3
mean_data = [];
    main_fig = figure('units','normalized','outerposition',[0 0 1 1])
    for floor_or_elev=1:2
        mean_floor_elev = [];
        if (floor_or_elev==1)
            load(fullfile('NewResults','mom_baby_dist_changes_stats_only_floor.mat'));
            ylabel_title = 'Floor time';
        else
            load(fullfile('NewResults','mom_baby_dist_changes_stats_only_elevation.mat'));
            ylabel_title = 'Elevation time';
        end
        cluster_data = dists;%(cl==cluster);
        cluster_dist = [];
        for i=1:length(cluster_data)
            cluster_data = dists;%(cl==cluster);
            sub_dist = cluster_data{i};
            mean_floor_elev = [mean_floor_elev sub_dist];
            N=histcounts(sub_dist,[0:10:700],'Normalization','probability');            
            cluster_dist = [cluster_dist; N];
        end
        h=subplot(1,2,floor_or_elev);
        h.Parent=main_fig;
        bar(mean(cluster_dist),'FaceColor',[0.4 0.4 0.4]);
        hold on
        errorbar(mean(cluster_dist),std(cluster_dist)/sqrt(size(mean(cluster_dist),2)),'linestyle','none','Color',[0 0 0]);
        xlim([0 70]);
        ylim([0 0.25]);
        xticks(1:10:70);
        xticklabels(1:100:700);
        ylabel(['% of ' ylabel_title]) ;
        xlabel('Distance (cm)');
        set(gcf,'color','w');
        hold on
        line([mean(mean_floor_elev)/10 mean(mean_floor_elev)/10],ylim,'color','black','linewidth',3);
    end
    print('-depsc', fullfile('NewResults','MomBabyDistances_Individuals',['mom_baby_distance_all_NormalAverage_10cm_bins.eps']));
    print('-dpng', fullfile('NewResults','MomBabyDistances_Individuals',['mom_baby_distance_all_NormalAverage_10cm_bins.png']));
%end
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
