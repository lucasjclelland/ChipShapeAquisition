%TheJackofAllTrades
close all
clear all
%%Transmitter
fs = 5e6;
fc = 1e6;
numBursts = 1000;
preamble = de2bi(hex2dec('C8B8DE7C23C54000')).';

%Create bits
for idx1 = 1:1:numBursts
   counter = (de2bi(idx1,16,'left-msb'))';
   num = randi([0 1],1024,1);
   comb = [preamble; counter; num]';

   for idx2 = 2:2:1024
      if     comb(idx2-1) == 0 && comb(idx2) == 0
            %combsym(idx2/2) = 0;
            %combcon(idx2/2) = 0.707 + 0.707j;
      elseif comb(idx2-1) == 0 && comb(idx2) == 1
            %combsym(idx2/2) = 1;
            %combcon(idx2/2) = -0.707 + 0.707j;
      elseif comb(idx2-1) == 1 && comb(idx2) == 0
            %combsym(idx2/2) = 2;
            %combcon(idx2/2) = -0.707 - 0.707j;
      elseif comb(idx2-1) == 1 && comb(idx2) == 1
            %combsym(idx2/2) = 3;
            %combcon(idx2/2) = 0.707 - 0.707j;
      end
   end
   
   txBits(:,idx1) = comb;
   %txSymbols(:,idx1) = combsym;
   %txConstProj(:,idx1) = combcon;
   
end

%Hamming(7,4) Encode
for idx3 = 1:1:numBursts
    Encoded = encode(txBits(:,idx3), 7, 4, 'hamming/binary');
    for idx4 = 1:1:length(Encoded)
       EncBits(idx3,idx4) = Encoded(idx4); 
    end
end

EncBits = EncBits';

[symbols, txConstProj] = convert2Sym(EncBits);

upSampSym = upSampFilt(txConstProj(:,1));
t = (0:1:length(upSampSym)-1)/fs;
Tx = upSampSym.*exp(1j*2*pi*fc*t.');
periodogram(Tx, [], [], fs, 'centered');

%%Channel simulation
Tx_noise = awgn(Tx, 40);
Tx_noise_rotatedConst = Tx_noise.*exp(1i*rand*pi);
Rx = Tx_noise_rotatedConst;

%%Receiver
Remove_carrier = Rx.*exp(1j*2*pi*-fc*t.'); 
dnSampSym = dnSampFilt(Remove_carrier);
Derotated = deroteConst(dnSampSym);

rxBits = convert2Bits(Derotated);
DecBits = decode(rxBits,7,4,'hamming/binary');
 
function [symbols, const] = convert2Sym(bits)

symbols = zeros(length(bits)/2, 1);
const = zeros(length(bits)/2, 1);

    for idx1 = 2:2:length(bits)

      if     bits(idx1-1) == 0 && bits(idx1) == 0
            symbols(idx1/2) = 0;
            const(idx1/2) = 0.707 + 0.707j;
      elseif bits(idx1-1) == 0 && bits(idx1) == 1
            symbols(idx1/2) = 1;
            const(idx1/2) = -0.707 + 0.707j;
      elseif bits(idx1-1) == 1 && bits(idx1) == 1
            symbols(idx1/2) = 3;
            const(idx1/2) = -0.707 - 0.707j;
      elseif bits(idx1-1) == 1 && bits(idx1) == 0
            symbols(idx1/2) = 2;
            const(idx1/2) = 0.707 - 0.707j;
      end 
    end
    scatterplot(const)
end

function [upSampSym] = upSampFilt(const)
    h = rcosdesign(0.5, 6, 4);
    upSampSym = upfirdn(const, h, 4);
end

function [dnSampSym] = dnSampFilt(Rx)
    h = rcosdesign(0.5, 6, 4);
    dnSampSym = upfirdn(Rx, h, 1, 4);
    scatterplot(dnSampSym);
    title('Received Signal');
end

function [rxBits] = convert2Bits(dnSampSym)

    for idx1 = 1:1:length(dnSampSym) 
        if     real(dnSampSym(idx1)) > 0 && imag(dnSampSym(idx1)) > 0
            rxBits(idx1*2-1) = 0;
            rxBits(idx1*2) = 0;
        elseif real(dnSampSym(idx1)) < 0 && imag(dnSampSym(idx1)) > 0
            rxBits(idx1*2-1) = 0;
            rxBits(idx1*2) = 1;
        elseif real(dnSampSym(idx1)) > 0 && imag(dnSampSym(idx1)) < 0
            rxBits(idx1*2-1) = 1;
            rxBits(idx1*2) = 0;
        elseif real(dnSampSym(idx1)) < 0 && imag(dnSampSym(idx1)) < 0
            rxBits(idx1*2-1) = 1;
            rxBits(idx1*2) = 1;
        end
    end
    rxBits = ~rxBits';
end