fSamp=5e6;
PRN=2;
nMilSec = 10;


N_Samp=ceil(fSamp*nMilSec/1000);

rxSig=read_complex_binary_short('B200_10MSPS_PapaBear_2018-06-22_16.40.44.bin',fSamp);
firstSamp = floor(fSamp/2)+floor(-8*fSamp/1000);
rxSig = rxSig (firstSamp:firstSamp+N_Samp-1);


%Output dopFreq nad baseband sig
[dopFreq,bBandSig]=dopAcq(rxSig,PRN,fSamp);

%Take baseband sig and output the circshifted code. now starts at 1:1023
[codeShift,cShiftSig]=codeAcq(bBandSig,dopFreq,PRN,fSamp);

%Take Baseband circshifted sig, output the transitions

repCode=cacode(PRN,fSamp/1.023e6)*2-1;
cShiftSig=repmat(repCode,1,10)'; % repeat for number of mSecs

data=cTransitions(cShiftSig,dopFreq,PRN,fSamp);
sumTrans=[];
