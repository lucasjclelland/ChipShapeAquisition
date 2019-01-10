clear;
simTime=20;
myFSamp = 1.023e6*4;
myFSamp = 5e6;
mySignal = cacode(2,5/1.023)*2-1;
mySignal = circshift(mySignal,1,50);
mySignal = repmat(mySignal,1,simTime);
t=[0:1:numel(mySignal)-1]/myFSamp;
mySignal = mySignal.*exp(1i*2*pi*353*t);



mySignal2 = cacode(5,5/1.023)*2-1;
mySignal2 = circshift(mySignal2,1,512);
mySignal2 = repmat(mySignal2,1,simTime);
t=[0:1:numel(mySignal)-1]/myFSamp;
mySignal2 = mySignal2.*exp(1i*2*pi*-530*t);
mySignal2 = mySignal2.*exp(1i*pi/4);

mySignal = mySignal+mySignal2;

% 
mySignal = awgn(mySignal,-20,'measured');
mySignal = mySignal./max(mySignal);

[estDoppler,bbSignal]=myEstimate(mySignal,2,myFSamp);

[dFreq,shiftSig]=dopAcq(mySignal,2,myFSamp);



