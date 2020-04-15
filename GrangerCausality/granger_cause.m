function [F_stats,c_v] = GrangerCausality(signal1,signal2,sig_level,max_lag)
% GrangerCausality runs the Granger Causality test for two signals
%
%% Syntax
% [F_stats,c_v] = GrangerCausality(signal1,signal2,sig_level,max_lag)
%
%% Description
% GrangerCausality runs the Granger Causality test and checks whether 
% signal2 Granger Cause signal1. The lag length selection is chosen using 
% the Bayesian information Criterion c. If F_stats > c_v the null hypothesis 
% that signal2 does not Granger Cause signal 1 is rejected
%
% Required Input.
% signal1: A column vector of data
% signal2: A column vector of data
% sig_level: the significance level specified by the user
% max_lag: the maximum number of lags to be considered
%
% Output.
% F_stats: The value of the F-statistic
% c_v: The critical value from the F-distribution

%Make sure x & y are the same length
if (length(signal1) ~= length(signal2))
    error('x and y must be the same length');
end

%Make sure x is a column vector
[a,b] = size(signal1);
if (b>a)
    %x is a row vector -- fix this
    signal1 = signal1';
end

%Make sure y is a column vector
[a,b] = size(signal2);
if (b>a)
    %y is a row vector -- fix this
    signal2 = signal2';
end



%Make sure max_lag is >= 1
if max_lag < 1
    error('max_lag must be greater than or equal to one');
end

%First find the proper model specification using the Bayesian Information
%Criterion for the number of lags of x

T = length(signal1);

BIC = zeros(max_lag,1);

%Specify a matrix for the restricted RSS
RSS_R = zeros(max_lag,1);

i = 1;
while i <= max_lag
    ystar = signal1(i+1:T,:);
    xstar = [ones(T-i,1) zeros(T-i,i)];
    %Populate the xstar matrix with the corresponding vectors of lags
    j = 1;
    while j <= i
        xstar(:,j+1) = signal1(i+1-j:T-j);
        j = j+1;
    end
    %Apply the regress function. b = betahat, bint corresponds to the 95%
    %confidence intervals for the regression coefficients and r = residuals
    [b,bint,r] = regress(ystar,xstar);
    
    %Find the bayesian information criterion
    BIC(i,:) = T*log(r'*r/T) + (i+1)*log(T);
    
    %Put the restricted residual sum of squares in the RSS_R vector
    RSS_R(i,:) = r'*r;
    
    i = i+1;
    
end

[dummy,x_lag] = min(BIC);

%First find the proper model specification using the Bayesian Information
%Criterion for the number of lags of y

BIC = zeros(max_lag,1);

%Specify a matrix for the unrestricted RSS
RSS_U = zeros(max_lag,1);

i = 1;
while i <= max_lag
    
    ystar = signal1(i+x_lag+1:T,:);
    xstar = [ones(T-(i+x_lag),1) zeros(T-(i+x_lag),x_lag+i)];
    %Populate the xstar matrix with the corresponding vectors of lags of x
    j = 1;
    while j <= x_lag
        xstar(:,j+1) = signal1(i+x_lag+1-j:T-j,:);
        j = j+1;
    end
    %Populate the xstar matrix with the corresponding vectors of lags of y
    j = 1;
    while j <= i
        xstar(:,x_lag+j+1) = signal2(i+x_lag+1-j:T-j,:);
        j = j+1;
    end
    %Apply the regress function. b = betahat, bint corresponds to the 95%
    %confidence intervals for the regression coefficients and r = residuals
    [b,bint,r] = regress(ystar,xstar);
    
    %Find the bayesian information criterion
    BIC(i,:) = T*log(r'*r/T) + (i+1)*log(T);
    
    RSS_U(i,:) = r'*r;
    
    i = i+1;
    
end

[dummy,y_lag] =min(BIC);

%The numerator of the F-statistic
F_num = ((RSS_R(x_lag,:) - RSS_U(y_lag,:))/y_lag);

%The denominator of the F-statistic
F_den = RSS_U(y_lag,:)/(T-(x_lag+y_lag+1));

%The F-Statistic
F_stats = F_num/F_den;

c_v = finv(1-sig_level,y_lag,(T-(x_lag+y_lag+1)));


    
    
    
    


