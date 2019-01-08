%Preamble Finder
% Goal:Using preamble, signal, number of samples find bit string 
 function [message] = PreambleFinder(inputSig, preamble, numSamp)

%     preamble = de2bi(hex2dec('C8B8DE7C23C54000')).';
%     counter = randi([0,1],16,1);
%     bits   = (randi([0,1],1024,1));
%     txMessage = [preamble; counter; bits];
%     unkBits = [zeros(randi([100,500]),1);txMessage;zeros(randi([100,500]),1)];

    plot(xcorr(preamble,inputSig));
    [~,pos]=max(xcorr(preamble,inputSig));
    %loc = pos-length(message)+1
    location = (length(inputSig) - pos) + 1;

    message = inputSig(location:location+numSamp-1);
    
 end    
