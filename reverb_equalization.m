% IR صناعية (غرفة)
t = 0:1/fs:0.5;
room = exp(-6*t)';
room(1) = 1;

%%reverb section إضافة ريفيرب
y = conv(x,room); % y(n)=x(n)∗h(n)


% رسم
figure
subplot(2,1,1)
spectrogram(x,128,120,128,fs,'yaxis')
title('Dry')

subplot(2,1,2)
spectrogram(y,128,120,128,fs,'yaxis')
title('Reverb')

% استماع
sound(x,fs)
pause(4)
sound(y,fs)
%%
%  EQUALIZER SECTION
%% =========================

disp('Choose EQ mode:')
disp('1: Low-pass (تخميد العالي)')
disp('2: High-pass (تخميد المنخفض)')
disp('3: Peaking boost (تعزيز نطاق)')
disp('4: Flat (بدون تغيير)')

mode = input('Enter mode: ');

y_eq = y;  % default

switch mode
    case 1  % Low-pass
        fc = 1000; % cutoff
        [b,a] = butter(4, fc/(fs/2), 'low');
        y_eq = filter(b,a,y);

    case 2  % High-pass
        fc = 500;
        [b,a] = butter(4, fc/(fs/2), 'high');
        y_eq = filter(b,a,y);

    case 3  % Peaking (Band boost)
        f0 = 1000;  % center frequency
        Q = 2;      % quality factor
        gain_dB = 10;

        w0 = f0/(fs/2);
        BW = w0/Q;

        [b,a] = iirpeak(w0,BW);
        y_eq = filter(b,a,y) * 10^(gain_dB/20);

    case 4
        disp('No EQ applied')

    otherwise
        disp('Invalid choice')
end