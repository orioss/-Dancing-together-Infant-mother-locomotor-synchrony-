function PushGrangerCausalityBackToDatavyu(base_dir, granger_cause_file, dyad_numbers_file)
% PushGrangerCausalityBackToDatavyu gets the granger causality results from
% the algorithm and create CSV files to push them back to datavyu.
%
%% Syntax
% PushGrangerCausalityBackToDatavyu(base_dir, granger_cause_file, dyad_numbers_file)
%
%% Description
% PushGrangerCausalityBackToDatavyu gets a MAT file with all granger
% causality results and create CSV file per dyad to push granger results
% back to datavyu for manual inspection. 
%
% Required Input.
% base_dir: output directory to create CSV file per dyad.
% granger_cause_file: MAT file with the granger causality results.
% dyad_numbers_file: MAT file with the dyad IDs and their age group
% 

% loads the dyad numbers
load(dyad_numbers_file);
load(granger_cause_file);

% go over all dyads
for i=1:30
   
   % creates a CSV file with the results from the granger causality test
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