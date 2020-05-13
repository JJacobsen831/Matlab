clear;
addpath('/home/jjacob2/matlab/CCS_ObsData/THLFigures/')
addpath('/home/jjacob2/matlab/Evaluation/Subroutines/')
addpath('/home/jjacob2/matlab/GSW/')
addpath('/home/jjacob2/matlab/GSW/library/')
File = 'thlCTDData.nc';

%load variables
T = datetime((ncread(File, 'Time')./86400 + datenum(1970,1,1,0,0,0)),...
    'ConvertFrom','datenum');

%after 2014
[TIME, I] = sort(T(1,:),2);
I(TIME < datetime(2014, 01, 01)) = [];
TIME(TIME < datetime(2014, 01, 01)) = [];
JdatePost = day(datetime(TIME, 'ConvertFrom','datenum'),'dayofyear');
TdatePost = find(JdatePost > 181 & JdatePost < 304);
depth = double(ncread(File, 'depth'));
tem = squeeze(ncread(File, 'temperature',[4, 1, 1], [1, Inf, Inf]));
salin = squeeze(ncread(File, 'salinity', [4, 1, 1], [1, Inf, Inf]));
RhoPost = sw_pden(salin(:,I), tem(:,I), sw_pres(depth, 41), 0);
SalPost = salin(:,I);
TemPost = tem(:,I);
%spice
SA_post = gsw_SA_from_SP(SalPost,sw_pres(depth, 41),-125,41);
CT_post = gsw_CT_from_pt(SA_post,gsw_pt0_from_t(SA_post, TemPost,sw_pres(depth,41)));
PI_Post = gsw_spiciness0(SA_post, CT_post);


%subset prior to 2014
[TIME, I] = sort(T(1,:),2);
I(TIME > datetime(2014, 01, 01)) = [];
TIME(TIME > datetime(2014, 01, 01)) = [];
Jdate = day(datetime(TIME, 'ConvertFrom','datenum'),'dayofyear');
Tdate = find(Jdate > 181 & Jdate < 304);

depth = double(ncread(File, 'depth'));
tem = squeeze(ncread(File, 'temperature',[4, 1, 1], [1, Inf, Inf]));
TH04.temp = tem(:,I);
salin = squeeze(ncread(File, 'salinity', [4, 1, 1], [1, Inf, Inf]));
TH04.sal = salin(:,I);
TH04.rho = sw_pden(TH04.sal, TH04.temp, sw_pres(depth, 41), 0);
%spice
SA_pre = gsw_SA_from_SP(TH04.sal,sw_pres(depth, 41),-125,41);
CT_pre = gsw_CT_from_pt(SA_pre,gsw_pt0_from_t(SA_pre, TH04.temp,sw_pres(depth,41)));
PI_Pre = gsw_spiciness0(SA_pre, CT_pre);


%compute depth of 26.0
RefRho = 1026.25; RefRhoLow = 1026.5;
Dep04 = NaN([size(TH04.temp,2), 1]);  Dep04Low = Dep04; DZ = Dep04; SpicePre = Dep04;
for n = 1:size(TIME,2)
    D04 = depth(abs(TH04.rho(:,n)-RefRho) == min(abs(TH04.rho(:,n)-RefRho)));
    D04L = depth(abs(TH04.rho(:,n)-RefRhoLow) == min(abs(TH04.rho(:,n)-RefRhoLow)));
    if (isempty(D04) == 0)
        Dep04(n) = D04;
        Dep04Low(n) = D04L;
        DZ(n) = abs(D04L - D04);
        SpicePre(n) = PI_Pre(abs(TH04.rho(:,n)-RefRhoLow) == min(abs(TH04.rho(:,n)-RefRhoLow)));
    end
end
Dep04Post = NaN([size(JdatePost,2), 1]); Dep04PostLow = Dep04Post; DZpost = Dep04Post;
SpicePost = Dep04Post;
for n = 1:size(JdatePost,2)
    D04Post = depth(abs(RhoPost(:,n)-RefRho) == min(abs(RhoPost(:,n)-RefRho)));
    D04L = depth(abs(RhoPost(:,n)-RefRhoLow) == min(abs(RhoPost(:,n)-RefRhoLow)));
    if(isempty(D04Post) == 0)
        Dep04Post(n) = D04Post;
        Dep04PostLow(n) = D04L;
        DZpost(n) = abs(D04L - D04Post);
        SpicePost(n) = PI_Post(abs(RhoPost(:,n)-RefRhoLow) == min(abs(RhoPost(:,n)-RefRhoLow)));
    end
end

%PV
f= 2*7.2921150e-5*sind(41.03);
g= 9.80665;
m1 = nanmean(reshape(TH04.rho,[600*87, 1])); m2 = nanmean(reshape(RhoPost, [600*60,1]));
Rho0 = mean([m1, m2]);
Drho = 0.25;
PV_Post = f*(g/Rho0).*(Drho./(DZpost));
PV_Pre = f*(g/Rho0).*(Drho./(DZ));

[idate, idep] = Clean2Var(Jdate(Tdate), Dep04(Tdate));
Trend = [ones(length(idate), 1) idate']\idep;
Line = [ones(length(idate), 1) idate']*Trend;

[idatePost, idepPost] = Clean2Var(JdatePost(TdatePost), Dep04Post(TdatePost));
TrendPost = [ones(length(idatePost), 1) idatePost']\idepPost;
LinePost = [ones(length(idatePost), 1) idatePost']*TrendPost;


figure(2)
set(gca,'Position',[0.13, 0.709, 0.775, 0.216])
subplot(3,1,1)
scatter(JdatePost, Dep04Post,'r','filled')
axis ij
datetick('x','mmm')
hold on
plot(idatePost, LinePost,'r')
scatter(Jdate, Dep04,'b','filled')
plot(idate, Line,'b')
legend({'2014 - 2019','Trend -1.05 m d^{-1} Int 124 m',...
    '2006 - 2013','Trend -0.87 m d^{-1} Int 118 m'})
title('TH04 depth of 26.25 \sigma_{\theta}')
ylabel('Depth (m)')

subplot(3,1,2)
scatter(JdatePost, PV_Post, 'r','filled')
datetick('x','mmm')
hold on
scatter(Jdate, PV_Pre,'b','filled')
ylim([0 1.5e-8])
ylabel('Background PV')

subplot(3,1,3)
scatter(JdatePost, SpicePost, 'r','filled')
datetick('x','mmm')
hold on
scatter(Jdate, SpicePre,'b','filled')
