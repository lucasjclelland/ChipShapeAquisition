clc; clear; close all;
%Generate SVcode1
fSamp=5e6; %Sample rate Samples/sec
nMilSec = 10;
PRN=1;
L1_ChipRate=1.023e6;
Frac_Samp= 10e6/L1_ChipRate;
repCode=cacode(PRN,fSamp/1.023e6)*2-1; %Frac_Samp= 10e6/L1_ChipRate;
repCode=repmat(repCode,1,nMilSec);
N_Samp=ceil(fSamp*nMilSec/1000);

% svPresent = [2 3 6 12 17 19 28]
% Gears says 3   6  17  19  24
inputData = read_complex_binary_short('B200_10MSPS_PapaBear_2018-06-22_16.40.44.bin',fSamp);
firstSamp = floor(fSamp/2)+floor(-8*fSamp/1000);
inputData = inputData (firstSamp:firstSamp+N_Samp-1);

%% Filter
[b,a]=butter(2,1e6/fSamp,'low'); %Wn=FilterBw3dBBHz/fSamp;
% freqz(b,a)
inputData=filtfilt(b,a,inputData);

%% Set up Shift
incShift=333;
%initial doppler shift
dbound=5000;
t = (0:length(inputData)-1)/fSamp; %time
dShift=-dbound:incShift:dbound;

%%

for iRefine=1:1:3
    
    
    for idx=1:length(dShift)
        t = (0:length(inputData)-1)/fSamp; %time
        corrMatrix(idx,:)= abs(xcorr(repCode.*exp(1i*2*pi*dShift(idx)*t),inputData));
        max_corr(idx)=max(corrMatrix(idx,:));
    end
    [~,index_Max]=max(corrMatrix(:));
    %Simultaneosly find the index of the Doppler shift max and Code phase
    [iDop,iCode]=ind2sub(size(corrMatrix),index_Max);
    shift_Freq=dShift(iDop);
        
    %Refine based on honed in doppler
    incShift=ceil(incShift/10);
    dbound=dbound/10;
    dShift=shift_Freq-dbound:incShift:shift_Freq+dbound;
    
    %plot
    plotstuff(iRefine,corrMatrix,dShift,incShift,max_corr,iDop,PRN)

    
end

%% Find the Codephase

shiftCode=circshift(repCode,+iCode);

corrCode=abs(xcorr(shiftCode.*exp(1i*2*pi*shift_Freq*t),inputData));
[~,code_Max_index]=max(corrCode);

codeCenter=ceil(length(corrCode)/2);
direction='right';
%If the i_Code shift direction is correct, the max correlation should be
%right in the center. Otherwise REVERSE the direction of the code shift
if ~((codeCenter-10<code_Max_index) && (code_Max_index<codeCenter+10))
    %Reverse Code Phase Direction
    shiftCode=circshift(repCode,-iCode);
    
    corrCode=abs(xcorr(shiftCode.*exp(1i*2*pi*shift_Freq*t),inputData));
    [~,code_Max_index]=max(corrCode);
    direction='left';
    
end

Code_Phase=ceil(iCode/Frac_Samp);

disp(['Doppler Shift: ' num2str(shift_Freq) 'Hz']);
disp(['CodePhase: ' num2str(Code_Phase) ' chips to the ' direction]);
figure(1);


function    plotstuff(ii,corrMatrix,dShift,inc_Shift,max_corr,iDop,PRN)
    figure(ii);
%     surf(corrMatrix,'edgecolor','none');
   plot(corrMatrix(iDop,:))
%     x=size(corrMatrix);
%     ylabel(['Doppler Shifts: ' num2str(x(1))])
    xlabel('Code Phase')
%     zlabel('Correlation')
    title(['PRN ' num2str(PRN)])

end
