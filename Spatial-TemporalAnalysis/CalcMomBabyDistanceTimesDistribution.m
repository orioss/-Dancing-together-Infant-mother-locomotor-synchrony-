function CalcMomBabyDistanceTimesDistribution(figures_dir, distances_file_floor, distances_file_elevation)
% CalcMomBabyDistanceTimesDistribution calculates the disribution of the distance
% between mom and baby throughout the session
%
%% Syntax
% CalcMomBabyDistanceTimesDistribution(figures_dir, distances_file_floor, distances_file_elevation)
%
%% Description
% CalcMomBabyDistanceTimesDistribution gets the distance between the mom
% and the baby at each moment and calculates the distance distribution 
% at the dataset level ("pooled")
%
% Required Input.
% figures_dir: directory for saving the figures
% distances_file_floor: MAT file that includes the mom-baby distance at each moment on floor
% distances_file_elevation: MAT file that includes the mom-baby
% distrance at each moment on elevation 
%

% generates main figure
main_fig = figure('units','normalized','outerposition',[0 0 1 1])

% go over both floor and elevation
for floor_or_elev=1:2
    mean_floor_elev = [];
    
    % select the relevant distance file whether this is a floor
    % trajectories or elevation trajectories
    if (floor_or_elev==1)
        load(distances_file_floor);
        ylabel_title = 'Floor time';
    else
        load(distances_file_elevation);
        ylabel_title = 'Elevation time';
    end
    dyads_dist = [];
    
    % go over dyads and calculate distance distribution
    for i=1:length(dists)
        sub_dist = dists{i};
        mean_floor_elev = [mean_floor_elev sub_dist];
        N=histcounts(sub_dist,[0:10:700],'Normalization','probability');            
        dyads_dist = [dyads_dist; N];
    end
    
    % plots the distance distribution 
    h=subplot(1,2,floor_or_elev);
    h.Parent=main_fig;
    bar(mean(dyads_dist),'FaceColor',[0.4 0.4 0.4]);
    hold on
    errorbar(mean(dyads_dist),std(dyads_dist)/sqrt(size(mean(dyads_dist),2)),'linestyle','none','Color',[0 0 0]);
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

% savest the figure in two formats 
print('-depsc', fullfile(figures_dir,'mom_baby_distance_all_NormalAverage_10cm_bins.eps'));
print('-dpng', fullfile(figures_dir,'mom_baby_distance_all_NormalAverage_10cm_bins.png'));
