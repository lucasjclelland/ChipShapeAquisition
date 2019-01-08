% 
% 
% fSamp=5e6; %Sample rate Samples/sec
% PRN=31;

function data=findTransitions(fSamp,PRN,chips)
L1_ChipRate=1.023e6; %chips/sec
fracSamp= fSamp./L1_ChipRate; % samples per chip
%% 1 to 1 Mapping
SV121=cacode(PRN)*2-1;
%%
%Fractional Sampling
frac=1/fracSamp:1/fracSamp:1023;
for iFrac=1:1:length(frac)
    %Shows how many samples per individual chip
    chipSamps(iFrac)=ceil(frac(iFrac));
    
end
%% Map samples to chips
for jj=1:1:1023
    chipBins(jj)=sum(chipSamps==jj);
end


%% Select # of Chips to correlate to
trans=[-1 -1; -1 1; 1 -1; 1 1];

for iCh=1:2^chips
    [exCorr(iCh,:),lags]=xcorr(SV121,trans(iCh,:));
    tmp=find(lags==0);
    exCorrALL(iCh,:)=exCorr(iCh,tmp:end);
    
end

for ii=1:2^chips
    index=0;
    for jj=1:length(exCorrALL(ii,:))
        if exCorrALL(ii,jj)>1
            if jj>1
                index=index+1;
                sampPosition=sum(chipBins(1:jj)); %find position in scaled matrix
                lChip=sampPosition-chipBins(jj-1)+1;
                rChip=sampPosition+chipBins(jj+1);
                shapeBounds(index,:)=[lChip rChip];
                if jj==1
                    index=index+1;
                    rChip=sampPosition+chipBins(jj+1);
                    shapeBounds(index,:)=[0 rChip];
                end

                
            end
        end
        
    end
    data(ii).shapeBounds=shapeBounds;
end


end







