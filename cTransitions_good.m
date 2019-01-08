function [tran]=cTransitions(rxSig,dFreq,PRN,fSamp)
%Define Variables
mSecs=length(rxSig)/(fSamp/1000); %number of codes in rxSig
t = (0:length(rxSig)-1)/fSamp; %time
fracSamp= fSamp./1.023e6;

% 1023 Reference Code
refCode=cacode(PRN)*2-1; % 1023 reference
refCode=repmat(refCode,1,mSecs); % repeat for number of mSecs

%Sampled Code
sampCode=cacode(PRN,fSamp/1.023e6)*2-1;
sampCode=repmat(sampCode,1,mSecs); % repeat for number of mSecs

%% Transitions of refrence Code
trans=[-1 -1 ; -1 1; 1 -1; 1 1];
for ii=1:length(trans)
    tranii).idx=strfind(refCode,trans(ii,:));
    jj=2;
    while jj<=length(tran(ii).idx) %while because tran changes size
        %if idx goes 14,15,16,17 then its a bunch of 1 1 1 1 1 so just take one
        if tran(ii).idx(jj-1) ==  tran(ii).idx(jj)-1 
                tran(ii).idx(jj)=[]; %delete overlap.....13,14,15,16,17>>13,15,17
        end
        jj=jj+1;

    end
end


%% Shows how many samples per individual chip
frac=1/fracSamp:1/fracSamp:1023;
for kk=1:1:length(frac)
    cSamps(kk)=ceil(frac(kk));
end

for zz=1:1:1023
    cBins(zz)=sum(cSamps==zz);
end

cBins=repmat(cBins,1,mSecs); % # samps per chip in mSecs

%% Create Bounds for each chip
for aa=1:length(tran)
    
    for bb = 1:length(tran(aa).idx)-1
        sampPos=sum(cBins(1:bb)); %find position in scaled matrix
        sampPos1=sum(cBins(1:bb+1));
%         tran(aa).bounds(bb,:)= [sampPos sampPos1+cBins(tran(aa).idx(bb+1))];
        tran(aa).bounds(bb,:)= rxSig(sampPos:(sampPos1+cBins(tran(aa).idx(bb+1))));
    end
end




%%



