function [Nute, Rho] = BC_Mx1(ProcBC, NuteNum)
%extract, reshape, remove NaN for boundary condition output

%check if variable can be selected
if (NuteNum > 4)
    disp('Please enter NuteNum: 1 = NO3, 2 = PO4, 3 = SiO4, 4 = DO');
    return
end

%select Variables
NuteNorth = squeeze(ProcBC.NorthNute(:,:,:,NuteNum));
NuteWest = squeeze(ProcBC.WestNute(:,:,:,NuteNum));
NuteSouth = squeeze(ProcBC.SouthNute(:,:,:,NuteNum));
RhoNorth = squeeze(ProcBC.NorthRho(:,:,:,NuteNum));
RhoWest = squeeze(ProcBC.WestRho(:,:,:,NuteNum));
RhoSouth = squeeze(ProcBC.SouthRho(:,:,:,NuteNum));

%resize to m x 1
NuteNorthM1 = reshape(NuteNorth,...
    [size(NuteNorth,1)*size(NuteNorth,2)*size(NuteNorth,3), 1]);
NuteWestM1 = reshape(NuteWest,...
    [size(NuteWest,1)*size(NuteWest,2)*size(NuteWest,3), 1]);
NuteSouthM1 = reshape(NuteSouth,...
    [size(NuteSouth,1)*size(NuteSouth,2)*size(NuteSouth,3), 1]);

RhoNorthM1 = reshape(RhoNorth,...
    [size(RhoNorth,1)*size(RhoNorth,2)*size(RhoNorth,3), 1]);
RhoWestM1 = reshape(RhoWest,...
    [size(RhoWest,1)*size(RhoWest,2)*size(RhoWest,3), 1]);
RhoSouthM1 = reshape(RhoSouth,...
    [size(RhoSouth,1)*size(RhoSouth,2)*size(RhoSouth,3), 1]);

%concatonate to row vector
Nute0 = [NuteNorthM1; NuteWestM1; NuteSouthM1];
Rho0 = [RhoNorthM1; RhoWestM1; RhoSouthM1];

[Nute, Rho] = Clean2Var(Nute0, Rho0);

return