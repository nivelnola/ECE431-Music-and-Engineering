%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SCRIPT
%    hw4
%
% NAME: Alon S. Levin
%
% This script runs questions 1 through 7 of the HW4 from ECE313:Music and
% Engineering.
%
% This script was adapted from hw1 recevied in 2012
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Setup
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all
clear variables
clc
dbstop if error

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Constants
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
constants.fs=44100;                     % Sampling rate in samples per second
STDOUT=1;                               % Define the standard output stream
STDERR=2;                               % Define the standard error stream

%% Sound Samples
% claims to be guitar
% source: http://www.traditionalmusic.co.uk/scales/musical-scales.htm
[guitarSound, fsg] = audioread('guitar_C_major.wav');

% sax riff - should be good for compressor
% source: http://www.freesound.org/people/simondsouza/sounds/763
[saxSound, fss] = audioread('sax_riff.wav');

% a fairly clean guitar riff
% http://www.freesound.org/people/ERH/sounds/69949/
[cleanGuitarSound, fsag] = audioread('guitar_riff_acoustic.wav');

% Harmony central drums (just use the first half)
[drumSound, fsd] = audioread('drums.wav');
L = size(drumSound,1);
drumSound = drumSound(1:round(L/2), :);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Common Values 
% may work for some examples, but not all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
depth=75;
LFO_type='sin';
LFO_rate=0.5;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Question 1 - Compressor
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
threshold = 0.1; 
attack = 0.2;
slope = 0.4;
avg_len = 5000;
[output,gain]=compressor(constants,saxSound,threshold,slope,attack,avg_len);

player = audioplayer(saxSound,constants.fs);
disp('Playing the Compressor input')
playblocking(player);
player = audioplayer(output,constants.fs);
disp('Playing the Compressor Output');
playblocking(player);
audiowrite('output_compressor.wav',output,fss);

figure('Name', 'Compressor Behavior')
subplot(2,1,1)
hold on
plot(saxSound, 'r')
plot(output, 'b')
title('Compressor Input and Output')
xlabel('Time');
ylabel('Magnitude')
legend('Input', 'Output')

subplot(2,1,2)
plot(gain)
title('Signal Gain vs Time')
xlabel('Time');
ylabel('Gain');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Question 2 - Ring Modulator
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
constants.fs = fsg;
% the input frequency is fairly arbitrary, but should be about an order of
% magnitude higher than the input frequencies to produce a
% consistent-sounding effect
inputFreq = 2500;
depth = 0.5;
[output]=ringmod(constants,guitarSound,inputFreq,depth);

player = audioplayer(guitarSound,constants.fs);
disp('Playing the RingMod input')
playblocking(player);
player = audioplayer(output,constants.fs);
disp('Playing the RingMod Output');
playblocking(player); 
audiowrite('output_ringmod.wav',output,fsg);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Question 3 - Stereo Tremolo
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
LFO_type = 'sin';
LFO_rate = 5;
% lag is specified in number of samples
% the lag becomes very noticeable one the difference is about 1/10 sec
lag = constants.fs/4;
depth = 0.9;
[output]=tremolo(constants,guitarSound,LFO_type,LFO_rate,lag,depth);

player = audioplayer(guitarSound,constants.fs);
disp('Playing the Tremolo input')
playblocking(player); 
player = audioplayer(output,constants.fs);
disp('Playing the Tremolo Output');
playblocking(player); 
audiowrite('output_tremelo.wav',output,fsg);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Question 4 - Distortion
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
gain = 20;
inSound = cleanGuitarSound(:,1);
tone = 0.75;
[output]=distortion(constants,inSound,gain,tone);

player = audioplayer(inSound,constants.fs);
disp('Playing the Distortion input')
playblocking(player); 
player = audioplayer(output,constants.fs);
disp('Playing the Distortion Output');
playblocking(player);
audiowrite('output_distortion.wav',output,fsag);

figure('Name', 'Distortion Behavior')
hold on
plot(inSound, 'r')
plot(output, 'b')
title('Distortion Input and Output')
xlabel('Time');
ylabel('Magnitude')
legend('Input', 'Output')


% look at what distortion does to the spectrum
L = 10000;
n = 1:L;
sinSound = sin(2*pi*440*(n/fsag)).';
[output]=distortion(constants,sinSound,gain,tone);

figure('Name', 'Distortion Spectrogram')
spectrogram(output, 'yaxis');

% Discussion:
% For my distortion algorithm, I added gain to the signal, clipped it at
% +-2, and then applied a passband butterworth filter about the tone to
% focus the spectrum on one end or the other. The parameters were chosen
% semi-randomly; after a bit of trial and error, I found a sound that
% sounded nice to me, and this is the one heard here. The spectrogram shows
% that many odd harmonics are present in the output signal, with less
% harmonic representation in the even harmonies. 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Question 5 - Delay
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% slapback settings
inSound = saxSound(:,1);
delay_time = 0.08; % in seconds
depth = 0.8;
feedback = 0;
[output]=delay(constants,inSound,depth,delay_time,feedback);

player = audioplayer(inSound,constants.fs);
disp('Playing the Slapback input')
playblocking(player); 
player = audioplayer(output,constants.fs);
disp('Playing the Slapback Output');
playblocking(player); 
audiowrite('output_slapback.wav',output,fsag);


% cavern echo settings
load('handel.mat');
inSound = y;
handel.fs = Fs;
delay_time = 0.3;
depth = 0.8;
feedback = 0.5;
[output]=delay(handel,inSound,depth,delay_time,feedback);

player = audioplayer(inSound,handel.fs);
disp('Playing the cavern input')
playblocking(player); 
player = audioplayer(output,handel.fs);
disp('Playing the cavern Output');
playblocking(player); 
audiowrite('output_cave.wav',output,handel.fs);


% delay (to the beat) settings
inSound = guitarSound(:,1);
delay_time = 0.18;
depth = 1;
feedback = .75;
[output]=delay(constants,inSound,depth,delay_time,feedback);

player = audioplayer(inSound,constants.fs);
disp('Playing the delayed on the beat input')
playblocking(player); 
player = audioplayer(output,constants.fs);
disp('Playing the delayed on the beat Output');
playblocking(player); 
audiowrite('output_beatdelay.wav',output,fsg);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Question 6 - Flanger
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
inSound = drumSound;
constants.fs = fsd;
depth = 0.8;
delay = .001;   
width = .002;   
LFO_Rate = 0.5;
LFO_type = 'sin';
[output]=flanger(constants,inSound,depth,delay,width,LFO_Rate,LFO_type);

player = audioplayer(inSound,constants.fs);
disp('Playing the Flanger input')
playblocking(player); 
player = audioplayer(output,constants.fs);
disp('Playing the Flanger Output');
playblocking(player); 
audiowrite('output_flanger.wav',output,fsd);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Question 7 - Chorus
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
inSound = guitarSound(:,1);
constants.fs = fsg;
depth = 0.9;
delay = .009;   
width = 0.01;   
LFO_Rate = 0.5; % irrelevant if width = 0
LFO_type = 'sin';
% Either a sine wave or a triangle wave can be chosen; I found the sine
% wave to sound nicer, personally.

[output]=flanger(constants,inSound,depth,delay,width,LFO_Rate,LFO_type);

player = audioplayer(inSound,constants.fs);
disp('Playing the Chorus input')
playblocking(player); 
player = audioplayer(output,constants.fs);
disp('Playing the Chorus Output');
playblocking(player); 
audiowrite('output_chorus.wav',output,fsg);


