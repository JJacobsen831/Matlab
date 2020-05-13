function []= jdate(txt)
% cdate: puts a date on the bottom corner of a graph, along with 
%	 an optional txt
%	 
%	 SYNTAX
%	 ------
%	 cdate(txt) 
%	 
%	 Chris Edwards			August 1997

ca = get(gcf,'CurrentAxes');

gh = axes('position',[0 .02 .1 .1],'visible','off');
txtinput = sprintf('JRJ:%s',date);
text(0.2,0.2,txtinput,'Fontsize',8)
if nargin == 1
    %gh = axes('position',[.8 .02 .1 .1],'visible','off');
    gh = axes('position',[.9 .02 .1 .1],'visible','off');
    txtinput = sprintf('%s', txt);
    text(0.2,0.2,txtinput,'Fontsize',8,'HorizontalAlignment','right');
end

set(gcf,'CurrentAxes',ca)

