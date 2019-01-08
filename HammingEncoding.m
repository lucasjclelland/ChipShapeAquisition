%Hamming Encoding

%Transmitter
numBits = 8;

TxBits = randi([0 1], 1, numBits);
EncBits = encode(TxBits, 7, 4, 'hamming/binary');

disp(TxBits);
disp(EncBits);

%Channel
errorBit = randi([1 numBits]);
EncBits(errorBit) = ~EncBits(errorBit);

disp(EncBits);

%Receiver
DecBits = decode(EncBits, 7, 4, 'hamming/binary');

disp(DecBits);

isequal(TxBits, DecBits)