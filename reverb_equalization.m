%for my electroacoustics class 2026
clc; clear; close all;


fs = 8000;%Sampling Frequency

%%  تسجيل الصوت
recObj = audiorecorder(fs,16,1);  % كل عينة صوت يتم تمثيلها بـ 16بت 
disp('Start speaking...')
recordblocking(recObj,5);
disp('Recording finished')

x = getaudiodata(recObj);

%% تحميل IR للغرفة
% load('room.mat');   % نفس الملف المعطى في مشروع AEC لإزالة أثر تعدد المسارات
% h = room(:);% 

%( أثر الغرفة( إضافة الريفيرب
% y = conv(x,h); %  y(n)=x(n)∗h(n)
% y = y(1:length(x));
%% room.mat طريقة2لإضافةأثر الغرفة صناعيا بدل
 %IR غرفة صنعية
t = 0:1/fs:0.5;
room = exp(-6*t)';
room(1) = 1;

%%reverb section إضافة ريفيرب
y = conv(x,room); % y(n)=x(n)∗h(n)

%% EQUALIZER SECTION يغيّر توزيع الطاقة على الترددات اي هو فلتر يغير السبكتروغرام
disp('Choose EQ mode:')
disp('1: Low-pass (تخميد العالي)')% ازالة المحتوى الترددي العالي من إشارة الكلام
disp('2: High-pass (تخميد المنخفض)')%إزالة المحتوى الترددي الباص من الكلام
disp('3: Peaking boost (تعزيز نطاق)')%تعزيز نطاق كلام ضمن ترددات الكلام الشائعة
disp('4: Flat (بدون تغيير)')% لاتفعل شيئا للترددات

mode = input('Enter mode: ');

y_eq = y;  % default

switch mode
    case 1  % Low-pass  1KHZتدريجيا  يخمد الترددات فوق  
        fc = 1000; % cutoff
        [b,a] = butter(4, fc/(fs/2), 'low');
        y_eq = filter(b,a,y);

    case 2  % High-pass%ستسمع اختفاء الباص   Hzحذف ما تحت 500 
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


%%  REMOVE PITCH (WHISPER EFFECT)إزالة التردد الاساسي من الكلام يكافئ ازالة الدورية

disp('Remove pitch? (1=yes, 0=no)')
remove_pitch = input('Enter: ');

y_final = y_eq;

if remove_pitch == 1
    % LPC analysis (إزالة الدورية)
    order = 12;
    a = lpc(y_eq, order);

    % استخراج الإثارة (residual)
    e = filter(a,1,y_eq);

    % استبدال الإثارة بضجيج (غير دوري)
    noise = randn(size(e));

    % إعادة التركيب
    y_final = filter(1,a,noise);

    disp('Pitch removed → whisper-like signal')
end


%%  PSD (Power Spectral Density)رسم التوزع الطيفي اي توزع الطاقة على الترددات في مجال الكلام


figure
subplot(3,1,1)
pwelch(x,[],[],[],fs)
title('PSD - Original (Dry)')

subplot(3,1,2)
pwelch(y,[],[],[],fs)
title('PSD - After Reverb')

subplot(3,1,3)
pwelch(y_eq,[],[],[],fs)
title('PSD - After EQ')


%%  SPECTROGRAMS تمثيل إشارات الطابع 
figure

subplot(4,1,1)
spectrogram(x,256,200,256,fs,'yaxis')
title('Dry')

subplot(4,1,2)
spectrogram(y,256,200,256,fs,'yaxis')
title('Reverb')

subplot(4,1,3)
spectrogram(y_eq,256,200,256,fs,'yaxis')
title('After EQ')

subplot(4,1,4)
spectrogram(y_final,256,200,256,fs,'yaxis')
title('After Pitch Removal')
figure

subplot(2,1,1)
plot(x)
title('Recorded Speech Signal')
xlabel('Samples')
ylabel('Amplitude')
grid on
subplot(2,1,2)
spectrogram(x,256,200,256,fs,'yaxis')
title('Speech Spectrogram')
%%  PLAY AUDIO
disp('Playing original...')
sound(x,fs)
pause(4)

disp('Playing with reverb...')
sound(y,fs)
pause(4)

disp('Playing after EQ...')
sound(y_eq,fs)
pause(4)

disp('Playing final...')
sound(y_final,fs)
