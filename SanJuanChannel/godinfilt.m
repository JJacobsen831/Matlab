function xfilt = godinfilt(xin, skip_ind)
%-------------------------------------------------
% function that runs filter:
%     'godin': running averages of 24,24,25 hrs applied successively
%
% ***note time series must be hourly and only a vector or matrix of column
% vectors
% 
% xfilt = godinfilt(xin);
%         xin = time series to be filtered
%           (if matrix, each column must be time series)
%
% make skip_ind == 1 to not filter at all, default is to filter 
%
% DAS, Oct. 2010
%-------------------------------------------------
nanend = 0; % to make ends NaN's

if ~iscolumn(xin) % transpose
    xin=xin';
end

if(nargin<2);
    skip_ind = 0;
end

if(skip_ind~=1)
 [nrows,ncols] = size(xin);
 xnew = zeros(nrows,ncols);
 
 % build 24 hr filter
 filter24 = ones(24,1); 
 filter24 = filter24 ./ sum(filter24);
 
 % build 25 hr filter 
 filter25 = ones(25,1); 
 filter25 = filter25 ./ sum(filter25);
 
 % covolve filters together, works because conv is associative
 temp_filter = conv(filter24, filter24);
 filter = conv(temp_filter, filter25);
 
 a = round(length(filter)/2);
 n = length(filter);
 %
 for i=1:ncols
     temp = conv(xin(:,i), filter);
     xnew(:,i) = temp(a:a+nrows-1);
         if nanend  %make ends NaN's
               xnew(1:n,i) = nan*ones(n,1);
               xnew(nrows-n+1:nrows,i) = nan*ones(n,1);
         end
 end
 
 xfilt = xnew;
elseif(skip_ind==1)
 xfilt = xin;   
end %end skip_ind
 
%----------------------------------------------------------
%----------------------------------------------------------
