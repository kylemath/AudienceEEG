%% Analyses of EEG signals collected with MUSE during real events with GOPRO
% 
clear all
close all
clc

addpath('functions')

%% import EEG data

datapath = '/Users/kyle/Downloads/drive-download-20180620T215529Z-001/';
eegfilename = 'improbotics_closing2min_june16_2018.csv';
videofilename = 'improbotics_closing2min_june16_2018_trimmed.mp4';

rawdata = importfile_eeg101([datapath eegfilename]); %in functions

%% import video
%matlab audiovideo toolbox
% I used quicktime to truncate the movie to the start and end of eeg
% recording
% The movie is also now roughly 57 seconds long

xyloObj = VideoReader([datapath, videofilename]);
segment_start = 1;
segment_end = xyloObj.NumberOfFrames;
step  = 1000/xyloObj.FrameRate;

%% gets a specific frame and plots it
frame_num = 200;
vidFrames = read(xyloObj,frame_num);
vidFrames = permute(vidFrames,[1,2,3,4]);
figure; image(vidFrames); 
       axis image; axis off;
       
       
%% load audio from video
   [audiodata,Fs] = audioread([datapath videofilename]);
   audiotime = 1/Fs:1/Fs:length(y)*1/Fs;
figure; plot(audiotime,audiodata);
         
xlabel('Time (s)');
ylabel('Amplitude (dB)');
title('Audio Track');
axis tight;


%% Setup eeg time
data.Timestamp = (rawdata.Timestampms - rawdata.Timestampms(1))/1000;
srate = 256; 
period = 1/srate;
eegtime = period:period:period*length(data.Timestamp);


%% plot raw data
electrode_names = {'TP9', 'Fp1', 'Fp2', 'TP10'};
nchan = length(electrode_names);
figure; plot(eegtime,rawdata.(2),eegtime,rawdata.(3),eegtime,rawdata.(4),eegtime,rawdata.(5));
         
xlabel('Time (s)');
ylabel('Voltage (uV)');
legend(electrode_names);
title('Muse raw EEG data');
axis tight;


%% plot eeg and audio together

figure; plot(audiotime,100*audiodata+800,eegtime,rawdata.(2));



%% filtering the eeg data (bandpass, low-pass, high-pass)

% high_pass = 6; %lower cutoff
% low_pass = 14; %upper cutoff
% order = 2; %order of polynomial used in the filter, can be increased to sharpen the dropoff of the filter
% type = 'band'; %type of filter
% [filt_data] = illini_filter(data',srate,high_pass,low_pass,order,'band'); %run the filter (which plots a graph)


%% Wavelet EEG transform
% Assign Frequencies of interest
% F = .01:.1:srate/2;
F = (2^(1/4)).^(-.1:.5:25); %Log 

% width of the wavelet
width = 3; 

%reset variables
power_wavelet = [];

% Compute Wavelet Analsis
win_hamming = hamming(length(data.Timestamp));

for i_chan = 1:nchan
    temp_data = rawdata.(i_chan+1);
    temp_data = win_hamming.*temp_data;
    power_wavelet(i_chan,:,:) = BOSC_tf(temp_data,F,srate,width);
end


% plot the original data and a single epoch spectrogram

i_chan = 2;
figure;
subplot(3,1,1);  plot(data.Timestamp,rawdata.(i_chan+1));
    xlabel('Time (sec)');
    ylabel('Voltage (uV)');
    title('Single Channel Data');
    axis tight;
subplot(3,1,2); imagesc(data.Timestamp,F,squeeze(power_wavelet(i_chan,:,:)));
    set(gca,'YDir','normal');
   xlabel('Frequency (Hz)');
    ylabel('Power (uV^2)');
    title('Individual channel Power Spectrogram wavelet');
    axis tight;
%     c=colorbar;
%     ylabel(c,'Log Power (dB)')
    


%% Find movie relevant frame points (laughs, jokes, etc.)


%% Time locked analysis













