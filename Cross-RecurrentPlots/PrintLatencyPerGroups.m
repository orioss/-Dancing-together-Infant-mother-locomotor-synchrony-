clear; clc;
load(fullfile('NewResults','LatencyDistributionsPerDyad.mat'));

% 
low_activity_group = mom_baby_latency_first_movement(mom_baby_latency_first_movement(:,2)==1,3:6);
med_activity_group = mom_baby_latency_first_movement(mom_baby_latency_first_movement(:,2)==2,3:6);
high_activity_group = mom_baby_latency_first_movement(mom_baby_latency_first_movement(:,2)==3,3:6);

figure;
low_infant_mom_average = low_activity_group(:,1)./(low_activity_group(:,1)+low_activity_group(:,3));
med_infant_mom_average = med_activity_group(:,1)./(med_activity_group(:,1)+med_activity_group(:,3));
high_infant_mom_average = high_activity_group(:,1)./(high_activity_group(:,1)+high_activity_group(:,3));
p_group_diff=anova1([low_infant_mom_average; med_infant_mom_average; high_infant_mom_average], ...
                    [ones(length(low_infant_mom_average),1); 2*ones(length(med_infant_mom_average),1); ...
                    3*ones(length(high_infant_mom_average),1)]);
close all;
low_infant_mom_average = ([low_infant_mom_average 1-low_infant_mom_average]);
med_infant_mom_average = ([med_infant_mom_average 1-med_infant_mom_average]);
high_infant_mom_average = ([high_infant_mom_average 1-high_infant_mom_average]);
p_mom_baby_diff=anova1([low_infant_mom_average; med_infant_mom_average; high_infant_mom_average]);
bar([mean(low_infant_mom_average); mean(med_infant_mom_average); mean(high_infant_mom_average)],'stacked');
ylabel('Percent of total joint segments');
xticklabels({'low','med','high'});
legend({'baby','mom'});
title(['group differences: p=' num2str(p_group_diff) ' | mom baby difference across groups: p=' num2str(p_mom_baby_diff)],'fontsize',8);
print('-dpng', fullfile('NewResults','GroupLatencyDistributions','who_iniated_first,png'), '-r300');

figure;
low_infant_mom_average = [low_activity_group(:,2) low_activity_group(:,4)];
med_infant_mom_average = [med_activity_group(:,2) med_activity_group(:,4)];
high_infant_mom_average = [high_activity_group(:,2) high_activity_group(:,4)];

bar([mean(low_infant_mom_average) mean(med_infant_mom_average) mean(high_infant_mom_average)]);
hold on
errorbar([mean(low_infant_mom_average) mean(med_infant_mom_average) mean(high_infant_mom_average)], ...
         [std(low_infant_mom_average)./sqrt(size(low_infant_mom_average,1))...
          std(med_infant_mom_average)./sqrt(size(med_infant_mom_average,1)) ...
          std(high_infant_mom_average)./sqrt(size(high_infant_mom_average,1))],'k','LineStyle','none');
set(gca,'FontSize',5)
ylabel('Averaged Latency (ms)');
xticklabels({'low goup baby','low group mom','med group baby','med group mom','high group baby','high group mom'});


print('-dpng', fullfile('NewResults','GroupLatencyDistributions','latency_values_by_group.png'), '-r300');