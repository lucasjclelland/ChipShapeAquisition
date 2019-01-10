function [dopplerShift,bbSignal] = myEstimate (rxSig, PRN,fSamp)
    rxSig = rxSig(:);
    mSecs=length(rxSig)/(fSamp/1000); %number of codes in rxSig
    repCode=cacode(PRN,fSamp/1.023e6)*2-1;
    repCode=repmat(repCode,1,mSecs); % repeat for number of mSecs
    % Filter
    [b,a]=butter(2,1e6/fSamp,'low'); %Wn=FilterBw3dBBHz/fSamp;
    rxSig=filtfilt(b,a,rxSig);
    freqs=[-7000:100:7000];
    
    t = [0:1:numel(rxSig)-1]/fSamp;
    for idx = 1:numel(freqs)      
        tmp = repCode.*exp(1i*2*pi*freqs(idx)*t);
       values(idx) = max(abs(xcorr(rxSig,tmp)));
    end
    [~,pos]=max(values);
    %values = values/max(values);
    plot(freqs,20*log10(values));
    
    freqs=[freqs(pos)-60:20:freqs(pos)+60];
    for idx = 1:numel(freqs)      
        tmp = repCode.*exp(1i*2*pi*freqs(idx)*t);
       values(idx) = max(abs(xcorr(rxSig,tmp)));
    end
    [~,pos]=max(values);
    
    
    
    freqs=[freqs(pos)-15:1:freqs(pos)+15];
    for idx = 1:numel(freqs)      
        tmp = repCode.*exp(1i*2*pi*freqs(idx)*t);
       values(idx) = max(abs(xcorr(rxSig,tmp)));
    end
    [~,pos]=max(values);
    dopplerShift = freqs(pos);
    
    bbSignal = rxSig.*exp(-1i*2*pi*dopplerShift*t.');
    
end