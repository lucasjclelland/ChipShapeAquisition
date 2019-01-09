function tran=cTransitions(rxSig,dFreq,PRN,fSamp)
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
    tran(ii).idx=strfind(refCode,trans(ii,:)); 
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
        leadChip=tran(aa).idx(bb)-1;
        lBound=sum(cBins(1:leadChip))+1; %find position in scaled matrix
        rBound=sum(cBins(1:leadChip+2));
        %cut off
        if cBins(leadChip+1)==5
            lBound=lBound+1;   
        end
        if cBins(leadChip+2)==5
            rBound=rBound-1;
        end
        tran(aa).bounds(bb,:)= rxSig(lBound:rBound);
    end
end




%%



