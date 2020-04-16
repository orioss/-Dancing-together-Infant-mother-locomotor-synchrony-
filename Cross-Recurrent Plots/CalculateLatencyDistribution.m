function CalculateLatencyDistribution(dyad_movement_file)
% CalculateLatencyDistribution calculates the distibution of latencies in
% movement between mom and baby (joint segments only)
%
%% Syntax
% CrossRQCalculateLatrency(dyad_movement_file)
%
%% Description
% CalculateLatencyDistribution calculates the time difference between the
% onset of the baby movement and the onset of the mom movement. Positive
% latencies mean infant started and mom followed, negative latencies mean
% mothers started and infants followed. The function plots a figure and prints the
% distribution of latencies 
%
% Required Input.
% dyad_movement_file: the path to the MAT file with dyad movements
%


% loads baby and mom movements
load(dyad_movement_file);

% initialize array for SPSS analysis
latencies = [];
latencies_for_SPSS=[];
who_initiated_for_SPSS=zeros(size(mom_baby_all,1),2);

% go over all dyads
for dyad=1:size(mom_baby_all,1)
   
   % create Cross Recurrent plot for each dyad
   figure;
   
   % initialize the dyad's mnother and infant structures
   infant_latencies=[];
   mother_latencies=[];
   disp(['Analyzing subject:  ' num2str(dyad)]);
   
   % gets the dyad data 
   baby_data = mom_baby_all{dyad,1};
   baby_data = downsample(baby_data, 100);
   mom_data = mom_baby_all{dyad,2};
   mom_data = downsample(mom_data, 100);
   
   % creates an Cross recureent plot and find all the boxes 
   shared_movements=mom_data'*baby_data;
   CC = bwconncomp(shared_movements);
   size_shared = size(shared_movements);
   Is = [];
   for c = 1:CC.NumObjects  
       
       % get only joint movements (boxes that are on the diagonal)
       cluster_idx = CC.PixelIdxList{c};
       [I1,I2] = ind2sub(size_shared,cluster_idx(:));
       if (length(find([I2-I1]==0))==0))
            Is=[Is; I1(1) I2(1)];
       end
   end

   % plots the recurrent plot with the boxes
   plot(Is(:,2),Is(:,1),'bx');
   hold on;
   
   % check 50ms shifts
   shifts = [-250:50:250];
   for shift_ix=1:length(shifts)-1
       
       % gets shift boundaries
      first_shift = shifts(shift_ix);
      second_shift = shifts(shift_ix+1);
      
      % gets the boxes that are relevant to the shift line
      if (second_shift <=0)
        polygonx = [0 size_shared(1)-abs(first_shift) size_shared(1)-abs(second_shift) 0];
        polygony = [abs(first_shift) size_shared(1) size_shared(1) abs(second_shift)];
      else
        polygonx = [abs(first_shift) size_shared(1) size_shared(1) abs(second_shift)];
        polygony = [0 size_shared(1)-abs(first_shift) size_shared(1)-abs(second_shift) 0];
      end
      k = convhull(polygonx,polygony); 
      
      % plot the shift line and the boxes 
      plot(polygonx(k),polygony(k),'linewidth',0.1)
      in = inpolygon(Is(:,2),Is(:,1),polygonx(k),polygony(k)); 
      plot(Is(in,2),Is(in,1),'ro') 
      latency = Is(in,1)-Is(in,2);
      
      % adds the latency to the latencies structure
      latencies = [latencies; latency];
      for l_ix=1:length(latency)
          curr_latency = latency(l_ix);
          if (curr_latency>0)
              mother_latencies = [mother_latencies; curr_latency];
              who_initiated_for_SPSS(dyad,2)=who_initiated_for_SPSS(dyad,2)+1;
          elseif (curr_latency<0)
              infant_latencies = [infant_latencies; abs(curr_latency)];
              who_initiated_for_SPSS(dyad,1)=who_initiated_for_SPSS(dyad,1)+1;
          end
      end
   end
   
   % adds it the SPSS structure for statstical analysis
   latencies_for_SPSS = [latencies_for_SPSS; dyad cl(dyad) mean(infant_latencies) mean(mother_latencies)];
end

% plots the latency histogram
figure;
[N,X] = hist(latencies,200);
Bh = bar(X,N,'facecolor',[1 0 0]);
xlim([-250 250]);
ylim([0 70]);