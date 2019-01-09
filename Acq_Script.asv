fSamp=5e6;
fSamp = myFSamp;
PRN=5;
nMilSec = 10;
close all;

N_Samp=ceil(fSamp*nMilSec/1000);

rxSig=read_complex_binary_short('B200_10MSPS_PapaBear_2018-06-22_16.40.44.bin',fSamp);
firstSamp = floor(fSamp/2)+floor(-8*fSamp/1000);
rxSig = rxSig (firstSamp:firstSamp+N_Samp-1);
rxSig = mySignal.';
%Make Ideal Signal
%codeShift=230;
%dopplerShift=-500;
%repCode=cacode(PRN,fSamp/1.023e6)*2-1;
%repCode=repmat(repCode,1,nMilSec)'; % repeat for number of mSecs
%t = (0:length(repCode)-1)/fSamp; %time
%  rxSig=circshift(repCode,codeShift).*exp(-1i*2*pi*dopplerShift*t.');


%Output dopFreq nad baseband sig
[dopFreq,bBandSig]=dopAcq(rxSig,PRN,fSamp);

%Take baseband sig and output the circshifted code. now starts at 1:1023
[codeShift,cShiftSig]=codeAcq(bBandSig,dopFreq,PRN,fSamp);

%Take Baseband circshifted sig, output the transitions

%repCode=cacode(PRN,fSamp/1.023e6)*2-1;

%cShiftSig = cShiftSig.*repCode;
data=cTransitions(cShiftSig.*exp(1i*pi/8),dopFreq,PRN,fSamp);
sumTrans=[];
for idx3=1:90
    data=cTransitions(cShiftSig.*exp(1i*pi*idx3/90),dopFreq,PRN,fSamp);
    for idx2=1:4
        tmp=0;
        for idx=1:30000
            tmp=tmp+((data(idx2).bounds{idx}));    
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