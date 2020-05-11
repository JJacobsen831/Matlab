function Output = VarSubSet(Mod, VarName, tstep)

%subset variables and store in Output structure
Output.lon = Mod.Output.lon;
Output.lat = Mod.Output.lat;
Output.depth= -1*Mod.Output.depth;
Output.(VarName) = Mod.Output.(VarName)(:,:,:,tstep);
Output.month = month(datestr(Mod.Output.time(tstep)/86400+datenum(1900,1,1)));

return