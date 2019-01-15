fSamp=5e6;
PRN=2;
nMilSec = 20;
close all;

N_Samp=ceil(fSamp*nMilSec/1000);

rxSig=read_complex_binary_short('cleanDynamic.bin',fSamp);
firstSamp = floor(fSamp/2)+floor(-8*fSamp/1000);
firstSamp = 1;
rxSig = rxSig (firstSamp:firstSamp+N_Samp-1);

[dFreq,dShiftSig]=dopAcq(rxSig,PRN,fSamp);
[codeShift,cShiftSig]=codeAcq(dShiftSig,dFreq,PRN,fSamp);

data=cTransitions(cShiftSig,PRN,fSamp);

figure()
plot(mean(real(data(1).bounds)))
hold on
plot(mean(imag(data(2).bounds)))
plot(mean(imag(data(3).bounds)))
plot(mean(imag(data(4).bounds)))
hold off


data=cTransitions(cShiftSig.*exp(1i*pi/8),PRN,fSamp);
sumTrans=[];
for idx3=1:45
    data=cTransitions(cShiftSig.*exp(1i*pi*idx3/90),PRN,fSamp);
    for idx2=1:4
        tmp=0;
        for idx=1:2000
            tmp=tmp+((data(idx2).bounds(idx,:)));    
        end
        figure(1)
        subplot(2,2,idx2)
        plot(real(tmp))
        grid('on');
        title(sprintf('Type: %d',idx2))
        hold('on');
        plot(imag(tmp));
        hold('off');
    end
    pause(.01);
end