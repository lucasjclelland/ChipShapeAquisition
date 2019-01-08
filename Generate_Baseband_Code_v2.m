%Generate BaseBand Code
clc; clear; close all;
%Generate SVcode1
%Frac_Samp= 10e6/L1_ChipRate;
L1_ChipRate=1.023e6; %chips/sec
fSamp=5e6; %Sample rate Samples/sec
fracSamp= fSamp./L1_ChipRate; % samples per chip

%Visible PRNs 3,4,9,16,22,23,26,27,31
PRN=31;
rxSig=cacode(PRN,fracSamp)*2-1;
localReplica=cacode(PRN,fracSamp)*2-1;


%1 to 1 Mapping
SV121=cacode(PRN)*2-1;

%Fractional Sampling
frac=1/fracSamp:1/fracSamp:1023;
for iFrac=1:1:length(frac)
    %Shows how many samples per individual chip
    chipSamps(iFrac)=ceil(frac(iFrac));
    
end

%Map samples to chips
for jj=1:1:1023
    chipBins(jj)=sum(chipSamps==jj);
end


%Select # of Chips to correlate to

chips=2;
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



figure(1)
plot(rxSig,'.')
hold on
plot(rxSig)
ylim([-3 3])









