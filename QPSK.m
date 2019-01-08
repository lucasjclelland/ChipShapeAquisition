%QPSK
close all;
FSamp=1e6;
%txBits = randi([0,1],10000,1);
bits   = (randi([0,1],64,1))*2-1;
%good1 = [1;1;-1;1;1;-1;-1;-1;-1;1;-1;-1;-1;-1;1;-1;1;-1;1;-1;-1;-1;1;1;1;1;-1;-1;-1;1;-1;-1;-1;-1;1;1;1;1;1;-1;-1;1;1;1;1;-1;1;1;-1;-1;-1;1;1;1;-1;1;-1;-1;-1;1;-1;-1;1;1];
%preamble = de2bi(hex2dec('CD9BFF0E16D2AB98')).'; %From NASA
preamble = de2bi(hex2dec('C8B8DE7C23C54000')).';

% plot(xcorr(preamble))
% figure(gcf)
   combsym = zeros(512,1);
   combcon = zeros(512,1);
   
for idx1 = 1:1:1000
   counter = (de2bi(idx1,16,'left-msb'))';
   num = randi([0 1],1024,1);
   comb = [preamble; counter; num]';

   for idx2 = 2:2:1024
      if     comb(idx2-1) == 0 && comb(idx2) == 0
            combsym(idx2/2) = 0;
            combcon(idx2/2) = 0.707 + 0.707j;
      elseif comb(idx2-1) == 0 && comb(idx2) == 1
            combsym(idx2/2) = 1;
            combcon(idx2/2) = -0.707 + 0.707j;
      elseif comb(idx2-1) == 1 && comb(idx2) == 0
            combsym(idx2/2) = 2;
            combcon(idx2/2) = -0.707 - 0.707j;
      elseif comb(idx2-1) == 1 && comb(idx2) == 1
            combsym(idx2/2) = 3;
            combcon(idx2/2) = 0.707 - 0.707j;
      end
   end
   
   txBits(:,idx1) = comb;
   txSymbols(:,idx1) = combsym;
   txConstProj(:,idx1) = combcon;
   
end

hPSKMod = comm.PSKModulator('ModulationOrder',4,...
                            'BitInput',true,...
                            'PhaseOffset',pi/4);
                        
Burst =  hPSKMod(txBits(:,1));

scatterplot(Burst);
hFilter = comm.RaisedCosineTransmitFilter('RolloffFactor',.5,'FilterSpanInSymbols',6,'OutputSamplesPerSymbol',4);

txSignal=hFilter(Burst);
scatterplot(txSignal);

hPFO = comm.PhaseFrequencyOffset('FrequencyOffset',300,'SampleRate',FSamp);
rxSignal  = hPFO(txSignal);
hSA = dsp.SpectrumAnalyzer('SampleRate',FSamp);
hSA(rxSignal);
plot(linspace(-FSamp/2,FSamp/2,2^24),fftshift(abs(fft(rxSignal.^4,2^24))));

rotatedConst=combcon.*exp(1i*rand*pi);
scatterplot(rotatedConst);
scatterplot(abs(real(rotatedConst))+1i*abs(imag(rotatedConst)));

numRotations = 100;

deroteConst(rotatedConst)