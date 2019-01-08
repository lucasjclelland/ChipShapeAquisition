%test

preamble = de2bi(hex2dec('C8B8DE7C23C54000')).';
counter = randi([0,1],16,1);
bits   = (randi([0,1],1024,1));
txMessage = [preamble; counter; bits];
unkBits = [zeros(randi([100,500]),1);txMessage;zeros(randi([100,500]),1)];

rxMessage = PreambleFinder(unkBits*2-1, preamble*2-1, length(txMessage));

isequal((rxMessage+1)/2, txMessage)