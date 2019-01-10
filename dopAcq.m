function [dFreq,shiftSig]=dopAcq(rxSig,PRN,fSamp)
rxSig = rxSig(:);
mSecs=length(rxSig)/(fSamp/1000); %number of codes in rxSig

% CA Code
repCode=cacode(PRN,fSamp/1.023e6)*2-1;
repCode=repmat(repCode,1,mSecs); % repeat for number of mSecs

% Filter
[b,a]=butter(2,1e6/fSamp,'low'); %Wn=FilterBw3dBBHz/fSamp;
% freqz(b,a)
rxSig=filtfilt(b,a,rxSig);

%Doppler Bins
dBin=333;
dBound=5000;
t = (0:length(rxSig)-1)/fSamp; %time
dShift=-dBound:dBin:dBound;

for ii = 1:1:4 %refine
    
    for jj = 1:length(dShift)
        corrMatrix(jj,:)= abs(xcorr(repCode.*exp(1i*2*pi*dShift(jj)*t),rxSig));
        maxCorr(jj)=max(corrMatrix(jj,:));
        
        
    end
    [maxPeak,peakBin]=max(maxCorr);
    peakFreq=dShift(peakBin);
    
    if ii==3
        tmp=10*log10(abs(corrMatrix.^2));
        maxPeak = max(tmp);
        maxDiff = maxPeak-mean(tmp(:));
        %maxDiff=maxPeak-(mean(corrMatrix(:)))
        %plotstuff(ii,corrMatrix,dShift,peakBin,PRN)
        %plotstuff(ii,tmp,dShift,peakBin,PRN)
        surf((tmp));
    end
    
    
    % Queue next bounds to zoom in
    dBin=ceil(dBin/10);
    dBound=dBound/10;
    dShift=peakFreq-dBound:dBin:peakFreq+dBound;
    
    plotdata(ii,:)={corrMatrix  peakFreq};
end

dFreq=peakFreq;
shiftSig=rxSig.*exp(-1i*2*pi*dFreq*t.');

end