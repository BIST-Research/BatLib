%
% Author: Ben Westcott
% Date created: 2/10/24
%

clc;
commandwindow;


M = 256;
noverlap = 0.75 * M;
NDFT = 512;
fs = 1E6;
gspec = hann(M, "periodic");

%plot(data)

data_prune = data(140500 : 155800);
%tvec_prune = tvec(140500 : 155800);

N = length(data_prune);
frange_div = 6;
freq = 0:fs/N:fs/frange_div;
%gtime = hann(size(data_prune, 1), "periodic")';

%plot(tvec_prune, data_prune)
%140986
%155773

%[sp, fp, tp] = spectrogram(data_prune, gspec, noverlap, NDFT, fs, 'yaxis');

%[s, f, t] = stft(data_prune, fs);
nexttile
xdft = fft(data_prune);
xdft = xdft(1:N/frange_div + 1);
psdx = (1/(fs*N)) * abs(xdft).^2;
psdx(2:end-1) = 2*psdx(2:end-1);

plot(freq, pow2db(psdx))
grid on

nexttile
spectrogram(data_prune, gspec, noverlap, NDFT, fs, 'yaxis');
ylim([0, 100]);
%cwt(data_prune, fs)

