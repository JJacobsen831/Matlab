function TS = AppGodin(EastTime,EastVar, WestTime, WestVar)

%equilize time
WestVar=WestVar(1:find(WestTime == max(EastTime)));
WestTime=WestTime(1:find(WestTime == max(EastTime)));

%subsample 5 min -> 1 hour
EastVar_hr = EastVar(1:12:length(EastVar));
WestVar_hr = WestVar(1:12:length(WestVar));
WestVar_T = WestTime(1:12:length(WestTime));

%apply godin filter
EastVar_godin = godinfilt(EastVar_hr,0);
WestVar_godin = godinfilt(WestVar_hr,0);

%remove godin filter mean from signal
EastVarRes = EastVar_hr - EastVar_godin;
WestVarRes = WestVar_hr - WestVar_godin;

%remove Gibbs 
EastVarRes = EastVarRes(30:end-30);
WestVarRes = WestVarRes(30:end-30);

%time
TS.time = WestVar_T(30:end-30);

%cross channel difference
TS.VarDiff = EastVarRes - WestVarRes;

TS.EastVar_Godin = EastVar_godin(30:end-30);
TS.WestVar_Godin = WestVar_godin(30:end-30);

TS.EastVarRes = EastVarRes;
TS.WestVarRes = WestVarRes;

return