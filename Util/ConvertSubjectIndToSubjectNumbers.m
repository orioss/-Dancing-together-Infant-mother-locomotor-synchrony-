load('NewResults\subjectsNums.mat');
load('NewResults\causality_times.mat');
base_dir = 'C:\Users\orios\Desktop\University\Post\StudiesCurrent\MomBaby\Analysis\NewResults\GrangerCausalitySegmentsBackToDatavyu';
for i=1:30
   real_subject_number=subject_order_s(i);
   real_subject_age=subject_ages(i);
   causality_times_sub =  causality_times(causality_times(:,1)==real_subject_number,3:4);
   data_to_csv = [real_subject_number*ones(size(causality_times_sub,1),1) causality_times_sub];
   if (real_subject_number<10)
      file_name = [base_dir '\SOMNYS#000' num2str(real_subject_number) '_' num2str(real_subject_age) '_causalityTimes.csv'];
   else
       file_name = [base_dir '\SOMNYS#00' num2str(real_subject_number) '_' num2str(real_subject_age) '_causalityTimes.csv'];
   end
   fid = fopen(file_name, 'w') ;
   fprintf(fid,'%i, %i, %i\n',data_to_csv')
   fclose(fid) ;
end