function [Scell HKcell OKGO] = RobustSAP(Lon,Qon,Ron,Loff,Qoff,Roff)
clc, close all


%-------------------------------%
% Parameters
%-------------------------------%
NSteps = 5001;
dT = .01;
PSDsz = 8;
PSAsz = 4;
SYNsz = PSDsz+PSAsz;
%---
doAMPARs = 0;
AMPARN = 2;
amparate = 50;
G1RT = .2;
%-------------------------------%
% Presets
%-------------------------------%
hkMask=[0 1 0; 1 0 1; 0 1 0];
S=padarray(ones(PSDsz),[PSAsz PSAsz], 0);

SmxT10    = S.*0;
SmxT100   = S.*0;
SmxT1000  = S.*0;
SmxT5000  = S.*0;
ShkT10    = S.*0;
ShkT100   = S.*0;
ShkT1000  = S.*0;
ShkT5000  = S.*0;

tic1=0;tic100=0;tic1000=0;tic5000=0;
%===============================================%
for stepN = 1:NSteps
%-----------------------------------------------%

Pmx = rand(size(S));
Soc = (S>0);
Sno = ~Soc;
hk = convn(Soc,hkMask,'same');

Lhon = hk-Lon;
Pon = 1 ./ (1+exp((-1*Qon)*Lhon));
Pkon = Sno .* ( Ron * dT * Pon );
Son = (Pkon>Pmx);

Lhoff = (-hk)+Loff;
Poff = 1 ./ (1+exp((-1*Qoff)*+Lhoff));
Pkoff = Soc .* ( Roff * dT * Poff );
Soff = (Pkoff>Pmx);

%====================================%
if doAMPARs
if mod(stepN, amparate) == 0
%-------------------------------%
SG1oc = S .* 0.0;
%-------------------------------%
RPOS=randi([4 12],1,AMPARN);CPOS=randi([4 12],1,AMPARN);
SG1oc(RPOS,CPOS)=1;
SG1oc(RPOS,CPOS+1)=1;
SG1oc(RPOS+1,CPOS)=1;
SG1oc(RPOS+1,CPOS+1)=1;
%-------------------------------%
Gex = Sno .* SG1oc .* G1RT + Pkon;
Gp = 1 ./ (1+exp((-1*1)*hk)) + .001;
Gpex = Gex .* Gp;
%---

Son = (Gpex>Pmx);
%-------------------------------%
end; end;
%====================================%

S = (Soc-Soff) + Son;
%-------------------------%

% if mod(stepN, viewTime) == 0
% PlotClusFun1(S);
% pause(pauseTime);
% end

if stepN == 10
	tic1 = tic1+1;
	SmxT10 = S;
	ShkT10 = hk;
end

if stepN == 100
	tic100 = tic100+1;
	SmxT100 = S;
	ShkT100 = hk;
end

if stepN == 1000
	tic1000 = tic1000+1;
	SmxT1000 = S;
	ShkT1000 = hk;
end

if stepN == 5000
	tic5000 = tic5000+1;
	SmxT5000 = S;
	ShkT5000 = hk;
end

if mod(stepN,5)==0
Ssum = sum(sum(S));

if (Ssum <= 6) 
Scell = {SmxT10 SmxT100 SmxT1000 SmxT5000};
HKcell = {ShkT10 ShkT100 ShkT1000 ShkT5000};
OKGO = 0;
return;
end

Sf1 = numel(find(S(1,1:end)));
Sf2 = numel(find(S(1:end,1)));
if (Sf1+Sf2) > 10 || (Ssum >= 190)
	SmxT5000 = ones(SYNsz);SmxT5000(1,1)=0;
Scell = {SmxT10 SmxT100 SmxT1000 SmxT5000};
HKcell = {ShkT10 ShkT100 ShkT1000 ShkT5000};
OKGO = 0;
return;
end
end


%-----------------------------------------------%
end % end main loop
%===============================================%

Scell = {SmxT10 SmxT100 SmxT1000 SmxT5000};
HKcell = {ShkT10 ShkT100 ShkT1000 ShkT5000};
OKGO = 1;
%---------------------------------------%
end % end main function
%---------------------------------------%



function [] = PlotClusFun1(S)
%-------------------------------------------%
	figure(1);
	imagesc(S);
    colormap('bone')
    title('2D Particle Map');
    title('PSD1');
end


function [] = PlotCsave(Csave,datarate,dT,stepN,NSteps)
%-------------------------------------------%
	figure(2); hold on;
	plot(Csave)
	set(get(gca,'XLabel'),'String','Steps')
	set(get(gca,'YLabel'),'String','SAP')
	set(gca,'YLim',[0 (max(Csave)+10)])
	xt = (get(gca,'XTick'))*datarate;
	set(gca,'XTickLabel', sprintf('%.0f|',xt));
	SAPtitle = title(['    Cluster Size Over Time '...
	'    Total Steps: ' num2str(NSteps)...
	'  \bullet  Time-Step: ' num2str(dT)]);
	set(SAPtitle, 'FontSize', 12);
	
	
disp(['This cluster lasted for ' num2str(stepN) ' steps'])
disp(['of the ' num2str(NSteps) ' requested steps'])
disp(' ')

end


function [] = Nenex(NSteps,stepN,S0,S,CSen,CSex,NoffN,Soffs,Sons,doNoff)



OnPerStep = sum(CSex)/(stepN);
OffPerStep = sum(CSen)/(stepN);

OffStepRate = 1 / OffPerStep;
Offmins = OffStepRate/60;

ClusMins = stepN/60;

ClusMins / Offmins;

Sstart = sum(sum(S0));
Send = sum(sum(S));
Spct = (Send / Sstart)*100;

PperMin = 1/Offmins;
PperHr = PperMin*60;

PctClusPHr = PperHr / Sstart * 100;
NumClusPHr = PctClusPHr/100*Sstart;





disp([' The Cluster to Particle lifetime ratio (in minutes): '])
disp([' (cluster) ' num2str(ClusMins) ' : ' num2str(Offmins) ' (particle)'  ])

disp([' ' ])
disp(['with...' ])
disp([' ' num2str(OnPerStep) ' on-events per step (on average)' ])
disp([' ' num2str(OffPerStep) ' off-events per step (on average)' ])

disp(['if step = 1 second...' ])
disp([' ' num2str(OffStepRate) ' seconds between off events (on average)' ])
disp([' ' num2str(OffStepRate) ' seconds = ' num2str(Offmins) ' minutes'])

disp([' ' ])
disp(['The starting cluster size was ' num2str(Sstart) ' particles,' ])
disp(['with ' num2str(NumClusPHr) ' particles dissociating per hour.' ])
% disp([' equivalent to ' num2str(PctClusPHr) '% of the starting cluster.'])
disp(['The ending cluster size was ' num2str(Send) ' particles, '])
disp([' which is ' num2str(Spct) '%. of the starting cluster size.'])

%-------------------------------------------%
% Noffs,Soffs,Sons


Soffon = (Sons+Soffs)./2;

%----------------------------%
% figure(3);
% subplot(2,1,1),imagesc(Soffs);
% colormap('bone')
% title('OFF Activity Map');
% colorbar
% %----------------------------%
% figure(3);
% subplot(2,1,2),imagesc(Sons);
% colormap('bone')
% title('ON Activity Map');
% colorbar
%----------------------------%
figure(4);
imagesc(Soffon);
colormap('bone')
title('Activity Map : (ON + OFF) / 2 ');
colorbar
%----------------------------%
if doNoff
Noffs = sum(NoffN);
No123 = sum(Noffs(1:3));
No4 = sum(Noffs(4));
N1234pct = (No123)/(No123+No4)*100;
disp([' Of the off events, ' num2str(N1234pct) '% was along an edge'])
end
%-------------------------------------------%


end


