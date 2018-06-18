
% Now that we have covered wavelet and fft analysis, we can compare the two
% directly and check what happens as we change the settings. To do this we
% will make new fake data with simulated oscillations at different
% frequencies as see how well we can resolve those frequencies in our
% analyses


%random normal data
noise_level = 0;
data = randn(1,2000)*noise_level;
t = 0:1:length(data)-1;% Time Samples
fs = 1000;% Sampling Frequency

% Create sine wave
f1 = 100;% Input Signal Frequency
d1 = sin(2*pi*(f1/fs)*t)*2;% Generate Sine Wave  

data = data+(d1);

% Compute FFT Analysis
[pow, phs, freq] = kyle_fft(data,fs,fs/2);

% Plot Data
figure;

%Plot Original Time Series
subplot(1,2,1); plot(t,data); axis tight; title('Raw Time Series');
xlabel('Time[s]');
ylabel('Voltage[uV]');

%plot the FFT spectra
subplot(1,2,2);
plot(freq,pow); title('FFT Spectra');
ylabel('Power');
xlabel('Frequency [Hz]');
set(gca,'XDir','normal');
axis tight;
