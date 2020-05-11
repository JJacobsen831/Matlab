function [Fname, MoName] = WOA_MonthFileName(Output)
%extract WOA data given month of output

if (Output.month == 1)
    Fname = 'WOA_Stat_01Jan.mat';
    MoName = 'January';
    
elseif (Output.month == 2)
    Fname = 'WOA_Stat_02Feb.mat';
    MoName = 'February';
    
elseif (Output.month == 3)
    Fname = 'WOA_Stat_03Mar.mat';
    MoName = 'March';
    
elseif (Output.month == 4)
    Fname = 'WOA_Stat_04Apr.mat';
    MoName = 'April';
    
elseif (Output.month == 5)
    Fname = 'WOA_Stat_05May.mat';
    MoName = 'May';
    
elseif (Output.month == 6)
    Fname = 'WOA_Stat_06Jun.mat';
    MoName = 'June';
    
elseif (Output.month == 7)
    Fname = 'WOA_Stat_07Jul.mat';
    MoName = 'July';
    
elseif (Output.month == 8)
    Fname = 'WOA_Stat_08Aug.mat';
    MoName = 'August';
    
elseif (Output.month == 9)
    Fname = 'WOA_Stat_09Sep.mat';
    MoName = 'Septempber';
    
elseif (Output.month == 10)
    Fname = 'WOA_Stat_10Oct.mat';
    MoName = 'October';
    
elseif (Output.month == 11)
    Fname = 'WOA_Stat_11Nov.mat';
    MoName = 'November';
    
elseif (Output.month == 12)
    Fname = 'WOA_Stat_12Dec.mat';
    MoName = 'December';
    
else
    disp('Output structure does not contain "month" variable')
end

