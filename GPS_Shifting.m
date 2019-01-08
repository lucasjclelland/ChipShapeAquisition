%GPS Frequency Shift
fSamp = 10e6;

rxSignal= read_complex_binary_int8('C:\Users\Drew\Documents\BetancesProjects\gpssim_2sec_10M.s8', floor(fSamp*1.99e-3));
shifts = -7000:5:7000;
localReplica = cacode(2,10/1.023)*2-1;
t=(0:1:numel(localReplica)-1)/fSamp;

for idx = 1:numel(shifts)
      corrVals(idx,:) = (abs(xcorr(localReplica.*exp(1i*2*pi*shifts(idx)*t),rxSignal)));
end

surf(corrVals)