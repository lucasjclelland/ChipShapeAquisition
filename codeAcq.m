function [cPhase,cShiftSig]=codeAcq(rxSig,dFreq,PRN,fSamp)
%signal is filtered, and the dop frequency has been found
mSecs=length(rxSig)/(fSamp/1000); %number of codes in rxSig
t = (0:length(rxSig)-1)/fSamp; %time

% CA Code
repCode=cacode(PRN,fSamp/1.023e6)*2-1;
repCode=repmat(repCode,1,mSecs); % repeat for number of mSecs

t = (0:length(rxSig)-1)/fSamp; %time

%Correlate
[r,lags]=xcorr(repCode.*exp(1i*2*pi*t),rxSig);
[~,cMax]=max(abs(r));

cPhase=lags(cMax); 

cShiftSig=circshift(rxSig,cPhase);
end


