%%idea 2
close all
rng('default');
rng(10);

bits   = (randi([0,1],1024,1));
signal=[zeros(randi([5000,25000]),1);bits; rand(1000,1)-.5+1i*(rand(1000,1)-.5);zeros(randi([5000,25000]),1)];
signal=[signal; zeros(randi([5000,25000]),1);bits;rand(1000,1)-.5+1i*(rand(1000,1)-.5);zeros(randi([5000,25000]),1)];
signal=[signal; zeros(randi([5000,25000]),1);bits;rand(1000,1)-.5+1i*(rand(1000,1)-.5);zeros(randi([5000,25000]),1)];
signal=awgn(signal,20,'measured');
plot(abs(signal))
figure

highestpower = 0;
signalfound = false;
detected = 1;
threshold = 60;

movingAvg = (abs(filter(ones(400,1),1,signal)));
plot(movingAvg)

for indx1 = 11:10:length(signal)
    power = mean(movingAvg(indx1-10:indx1));
    %power = mean(abs(20*log10(signal(indx1-10:indx1).^2)));
    %power = mean(abs((signal(indx1-10:indx1))));
    %avgPower = mean(abs(signal(indx1-50:indx1)));
    
    if power > threshold && ~signalfound 
        signalstart(detected) = indx1;
        signalfound = true;
        disp(['Signal ' num2str(detected) ' detected at sample ' num2str(indx1)])
    end
    if power < threshold && signalfound
        signalend(detected) = indx1;
        signalfound = false;
        detected = detected + 1;
    end
    if power > highestpower
        highestpower = power;
    end
end

%Assume 5% error in detecting signals
for indx2 = 1:1:length(signalstart)
    startErr(indx2) = floor(signalstart(indx2)*0.95);
    endErr(indx2) = floor(signalend(indx2)*1.05);
    disp(['Signal ' num2str(indx2) ' approximately between sample ' num2str(startErr(indx2)) ' and ' num2str(endErr(indx2))])
end