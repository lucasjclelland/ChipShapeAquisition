
simTime=200;
myFSamp = 1.023e6*4;
mySignal = cacode(2,4)*2-1;
mySignal = circshift(mySignal,1,50);
mySignal = repmat(mySignal,1,simTime);
t=[0:1:numel(mySignal)-1]/myFSamp;
mySignal = mySignal.*exp(1i*2*pi*353*t);
mySignal = mySignal.*exp(1i*pi/4);




mySignal2 = cacode(5,4)*2-1;
mySignal2 = circshift(mySignal,1,512);
mySignal2 = repmat(mySignal,1,simTime);
t=[0:1:numel(mySignal)-1]/myFSamp;
mySignal2 = mySignal.*exp(1i*2*pi*-530*t);
mySignal2 = mySignal.*exp(1i*pi/4);

mySignal = mySignal+mySignal2;


mySignal2 = cacode(12,4)*2-1;
mySignal2 = circshift(mySignal,1,413);
mySignal2 = repmat(mySignal,1,simTime);
t=[0:1:numel(mySignal)-1]/myFSamp;
mySignal2 = mySignal.*exp(1i*2*pi*+3001*t);
mySignal2 = mySignal.*exp(1i*pi/4);


mySignal = mySignal+mySignal2;


mySignal = awgn(mySignal,-30,'measured');


