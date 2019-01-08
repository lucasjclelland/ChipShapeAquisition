%Doppler Shift: 4452Hz
%CodePhase: 836 bits to the left --- 8163 samples
clear;
close all;

%%

  fEst = 4434;
%%

nMilSec = 10;
L1_ChipRate=1.023e6; %chips/sec
FSamp=10e6; %Sample rate Samples/sec
Frac_Samp= FSamp./L1_ChipRate; %9.7752 samples per chip
FSamp=10e6; %Sample rate Samples/sec
PRN=2;
SV1=cacode(PRN,Frac_Samp)*2-1;
SV1=repmat(SV1,1,nMilSec);
load('inputData');
t = [0:1:numel(inputData)-1]/FSamp;
SV1 = circshift(SV1,-98163,1);
inputData = inputData.* exp(-1i*2*pi*fEst*t.');
tmp = (SV1>0);
plot((inputData.*SV1.'.*tmp.'),'*');
hold
tmp = (SV1<0);
plot((inputData.*SV1.'.*tmp.'),'*');
