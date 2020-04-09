moms_stats = csvimport('NewData\MomStats.csv');
mom_baby_data = csvimport('NewData\ResampledData.csv');

moms_data = cell2mat(moms_stats(2:end,[2 24]));
num_of_clusters = max(moms_data (:,2));
mom_baby_num_data = cell2mat(mom_baby_data(2:end,2:end));
counter=1;
for md=1:size(moms_data,1)
    sub_data = mom_baby_num_data(mom_baby_num_data(:,1)==moms_data(md,1),:);
    baby_sub_data = sub_data(:,4:5);
    mom_sub_data = sub_data(:,6:7);
    time = sub_data(:,3);
    mom_baby_dist=[];
    for step=1:size(mom_sub_data)
        mom_baby_dist(step) = calcdist([baby_sub_data(step,:); mom_sub_data(step,:)]);
    end
    dists{counter} = mom_baby_dist;
    counter=counter+1;
end

for sub1=1:length(dists)
    for sub2=sub1:length(dists)
        try
        disp (['calc dtw for subj1: ' num2str(sub1) ' and subj2: ' num2str(sub2)]);
        sub1_step_length_data = dists{sub1}; 
        sub2_step_length_data = dists{sub2}; 
        [Dist,D,k,w,sub1_warped,sub2_warped]=dtw(sub1_step_length_data, sub2_step_length_data, 0);
        dist_length(sub1,sub2)=Dist;
        k_length(sub1,sub2)=k;
        save('mom_baby_cluster_dtw.mat','dist_length','k_length');
        catch ex
            ex
        end
    end
end
