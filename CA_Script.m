clc; clear; close all;
%Generate SVcode1
%Frac_Samp= 10e6/L1_ChipRate;
L1_ChipRate=1.023e6; %chips/sec
FSamp=5e6; %Sample rate Samples/sec
Frac_Samp= FSamp./L1_ChipRate; %9.7752 samples per chip

%Visible PRNs 3,4,9,16,22,23,26,27,31
PRN=31;
SV1=cacode(PRN,Frac_Samp)*2-1;
% inputData = read_complex_binary_short('~/Desktop/clelland/Broadsim/broadsim-collections-60db/60db-radio1-20180212-155036',ceil(FSamp*.001));
N_Samp=ceil(FSamp*.001 );

%
inputData = read_complex_binary_short('D:\GPS RFDNA\broadsim-collections-60db\60db-radio1-20180212-155036',N_Samp);

inc_Shift=333;
%initial doppler shift
dbound=5000;
t = (0:length(inputData)-1)/FSamp; %time
dShift=-dbound:inc_Shift:dbound;




for irefine=1:1:3
    
    
    for idx=1:length(dShift)
        t = (0:length(inputData)-1)/FSamp; %time
        corrMatrix(idx,:)= abs(xcorr(SV1.*exp(1i*2*pi*dShift(idx)*t),inputData));
        max_corr(idx)=max(corrMatrix(idx,:));
    end
    figure(irefine);
    surf(corrMatrix,'edgecolor','none');
    x=size(corrMatrix);
    ylabel(['Doppler Shifts: ' num2str(x(1))])
    xlabel('Code Phase')
    zlabel('Correlation')
    title(['PRN ' num2str(PRN)])
    [~,index_Max]=max(corrMatrix(:));
    
    
    
    %Simultaneosly find the index of the Doppler shift max and Code phase
    [i_Dop,i_Code]=ind2sub(size(corrMatrix),index_Max);
    shift_Freq=dShift(i_Dop);
    
    figure(8*irefine);
    subplot(2,1,1)
    
    stem(dShift,max_corr(1:length(dShift)));
    xlim([dShift(1)-inc_Shift dShift(end)+inc_Shift])
    ylabel('Max Correlation')
    xlabel('Frequency (Hz)')
    title(['PRN ' num2str(PRN) ', Maximum Correlation at Each Doppler Shift Frequency'])
    subplot(2,1,2)
    plot(corrMatrix(i_Dop,:))
    ylabel('Correlation')
    xlabel('Time')
    title(['PRN ' num2str(PRN) ', Dopler Shift = ' num2str(shift_Freq) 'Hz'])
    
    %Refine based on honed in doppler
    inc_Shift=ceil(inc_Shift/10);
    dbound=dbound/10;
    dShift=shift_Freq-dbound:inc_Shift:shift_Freq+dbound;
end

%Find the Codephase

Code_shift=circshift(SV1,+i_Code);

Corr_Code=abs(xcorr(Code_shift.*exp(1i*2*pi*shift_Freq*t),inputData));
[~,code_Max_index]=max(Corr_Code);


Corr_Code_Center=ceil(length(Corr_Code)/2);
direction='right';
%If the i_Code shift direction is correct, the max correlation should be
%right in the center. Otherwise REVERSE the direction of the code shift
if ~((Corr_Code_Center-10<code_Max_index) && (code_Max_index<Corr_Code_Center+10))
    %Reverse Code Phase Direction
    Code_shift=circshift(SV1,-i_Code);
    
    Corr_Code=abs(xcorr(Code_shift.*exp(1i*2*pi*shift_Freq*t),inputData));
    [~,code_Max_index]=max(Corr_Code);
    direction='left';
    
end

Code_Phase=ceil(i_Code/Frac_Samp);


figure(irefine+2)
plot(Corr_Code)
    ylabel('Correlation')
    xlabel('Time')
    title(['PRN ' num2str(PRN) ', CodePhase: ' num2str(Code_Phase) ' bits to the ' direction])

disp(['Doppler Shift: ' num2str(shift_Freq) 'Hz']);
disp(['CodePhase: ' num2str(Code_Phase) ' bits to the ' direction]);
