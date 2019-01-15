function samples=read_texbat(duration,start_time,filepath)
% usage: samples=read_texbat(duration,start_time,filepath)
% 
% Inputs:
% duration      Amount of data to load (seconds)
% start_time    Start time at which to load data (seconds)
% filename      TEXBAT File name to be loaded
%
% Outputs:
% samples       Output TEXBAT I/Q output samples
%
% Routine to read in binary data TEXBAT scenario 3, Logan Scott
% Modified by Phil Corbell

if nargin<3
    [filename, pathname, filterindex] = ...
        uigetfile('*.bin', 'Pick a TEXBAT Datafile to Load');
    if isequal(filename,0) || isequal(pathname,0)
       disp('User pressed cancel')
    else
       disp(['User selected ', fullfile(pathname, filename)])
       filepath = fullfile(pathname, filename);
    end
end

if nargin <2
    start_time = 0;
end

if nargin <1
    duration = 1; % Defaults to a second of data
    disp('Duration not specififed, grabbing a second of data');
end

sample_rate=25000000; %Hz
number_samples=ceil(duration*sample_rate);%number of samples to read (I & Q are interleaved)
starting_byte=4*round(start_time*sample_rate);%pointer to first value x2 for bytes
fid=fopen(filepath,'r'); % open the file
disp(['read_texbat: Opening file: ' filepath]);
fseek(fid, starting_byte, 'bof');% position the start
fprintf('read_texbat: File pointer moved %d seconds, %d Bytes\n',start_time,starting_byte);
strtByte = ftell(fid);
fprintf('read_texbat starting read at Byte %d\n',strtByte)
%samples=fread(fid,[2,number_samples],'int16=>int32');% read in Is and Qs
samples=fread(fid,[2,number_samples],'int16');% read in Is and Qs
fclose(fid);
samples=complex(samples(1,:),samples(2,:)); % Convert and return complex form
