function h_b = BaseSML_ObsTopRef(tem, salin, deps, DT)
%Locate base of Surface Mixed Layer from t, s, and depth
%adopted from Kara et al., 2000

%clean nan and zero from temperature and subset both fields
tem(tem == 0) = NaN;
igoodT = ~isnan(tem);
t = tem(igoodT);
d = deps(igoodT);
s = salin(igoodT);

%clean nan from salinity
igoodS = ~isnan(s);
tmp = t(igoodS);
dep = d(igoodS);
salt = s(igoodS);

%remove surface sample(s)
inosurf = find(dep >= 5);
temp = tmp(inosurf);
depth = dep(inosurf);
sal = salt(inosurf);


%compute pressure from depth
pres = sw_pres(depth, 30);
rho = sw_pden(sal,temp,pres,0);
    
%initial density at 10 m depth
chk = find(depth ==10);
if (isempty(chk) == 0)
    
    % check if 10 m level was sampled multiple times
    % if it is, select the first one to avoid errors from historesis 
    if (length(chk) == 1)
        Tref0 = temp(depth == 10);
        Sref0 = sal(depth == 10);
        Pref0 = pres(depth == 10);
    else
        Tref0 = temp(chk(1));
        Sref0 = sal(chk(1));
        Pref0 = pres(chk(1));
    end
else
    
    % check if shallowest obs is at 25 m or less, if so use that value
    if (depth(1) < 25)
        Tref0 = temp(1);
        Sref0 = sal(1);
        Pref0 = pres(1);
    else
        
        %if shallowest obs is deeper than 25 m, SML is N/D and return
        h_b = NaN;
        return
    end
end
    
%Drho computed from initial reference guess
Drho = sw_pden(Sref0, Tref0-DT,Pref0,0)-sw_pden(Sref0,Tref0,Pref0,0);

%locate temperature at 10 m
Ref = find(abs(depth - 10) == min(abs(depth - 10)));
if isempty(Ref)==0
    Dref = rho(Ref(1));
        
    %locate where in profile temperature exceeds difference from reference
    D_ids = find(abs(rho - Dref) > Drho);
    if isempty(D_ids) == 0
        D_id = D_ids(1);
    else
        %homogeneous layer, SML extends to bottom
        h_b = depth(end); 
        return
    end
        
    %check if first element deviates from treshold
    if (D_id == 1)
        h_b = NaN;
        return
    else
        
    %assume temp is decreasing
    D_b = Dref + Drho;

        
    %linear interpolation to find exact depth T = T_b
    slp = (depth(D_id-1)-depth(D_id))/(rho(D_id-1)-rho(D_id));
    int = depth(D_id-1)-slp*rho(D_id-1);
        
    %output depth of the base of the isothermal Layer
    h_b = int+slp*D_b;
    end
else
    % couldn't detect isopycnal layer so assume it has outcropped
    h_b = -5;
end

return