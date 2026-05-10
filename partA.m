
% Adaptive acoustic echo canceller



close all
clear all       % clears all variables

load room.mat;  % loads the room model

figure
subplot(211)
plot(room)
xlabel('i');
axis tight
title('Impulse response');
grid
subplot(212)
[H,F]=freqz(room,1,512,8000);
plot(F,20*log10(abs(H)));
xlabel('Hz')
ylabel('dB')
title('Frequency response')
grid;

