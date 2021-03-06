%% MPEG-1 Audio Layer 1 Encoder/Decoder
% Alon S. Levin
% ECE-413: Music & Engineering
clear;
clc;
close all;

%% Setup
createCandD;
[sound_sax, fs_sax] = audioread('sax_riff.wav');
[sound_bach, fs_bach] = audioread('violin_bach.wav');
[sound_jimi, fs_jimi] = audioread('gtr-dist-jimi.wav');
[sound_panther, fs_panther] = audioread('PinkPanther30.wav');
[sound_cantina, fs_cantina] = audioread('CantinaBand60.wav');
[sound_latin, fs_latin] = audioread('Latin.wav');
[sound_taunt, fs_taunt] = audioread('taunt.wav');

%% Individual Instruments
encoded_sax = AcousticModel(PolyphaseFilterBank(sound_sax, C), fs_sax);
decoded_sax = Decode(encoded_sax, D);
encoded_bach_l = AcousticModel(PolyphaseFilterBank(sound_bach(:,1), C), fs_bach);
encoded_bach_r = AcousticModel(PolyphaseFilterBank(sound_bach(:,2), C), fs_bach);
decoded_bach = [Decode(encoded_bach_l, D); Decode(encoded_bach_r, D)]; 
encoded_jimi_l = AcousticModel(PolyphaseFilterBank(sound_jimi(:,1), C), fs_jimi);
encoded_jimi_r = AcousticModel(PolyphaseFilterBank(sound_jimi(:,2), C), fs_jimi);
decoded_jimi = [Decode(encoded_jimi_l, D); Decode(encoded_jimi_r, D)];

%% Some Songs
encoded_panther = AcousticModel(PolyphaseFilterBank(sound_panther, C), fs_panther);
decoded_panther = Decode(encoded_panther, D);
encoded_cantina = AcousticModel(PolyphaseFilterBank(sound_cantina, C), fs_cantina);
decoded_cantina = Decode(encoded_cantina, D);
encoded_latin_l = AcousticModel(PolyphaseFilterBank(sound_latin(:,1), C), fs_latin);
encoded_latin_r = AcousticModel(PolyphaseFilterBank(sound_latin(:,2), C), fs_latin);
decoded_latin = [Decode(encoded_latin_l, D); Decode(encoded_latin_r, D)];

%% And, for fun, speech
encoded_taunt = AcousticModel(PolyphaseFilterBank(sound_taunt, C), fs_taunt);
decoded_taunt = Decode(encoded_taunt, D);

%% Play time
disp('Playing Sax Riff Original');
player = audioplayer(sound_sax, fs_sax);
playblocking(player);
disp('Playing Sax Riff Compressed');
player = audioplayer(decoded_sax, fs_sax);
playblocking(player);
disp('Playing Bach Original');
player = audioplayer(sound_bach, fs_bach);
playblocking(player);
disp('Playing Bach Compressed');
player = audioplayer(decoded_bach, fs_bach);
playblocking(player);
disp('Playing Jimi Original');
player = audioplayer(sound_jimi, fs_jimi);
playblocking(player);
disp('Playing Jimi Compressed');
player = audioplayer(decoded_jimi, fs_jimi);
playblocking(player);
disp('Playing Panther Original');
player = audioplayer(sound_panther, fs_panther);
playblocking(player);
disp('Playing Panther Compressed');
player = audioplayer(decoded_panther, fs_panther);
playblocking(player);
disp('Playing Cantina Original');
player = audioplayer(sound_cantina, fs_cantina);
playblocking(player);
disp('Playing Cantina Compressed');
player = audioplayer(decoded_cantina, fs_cantina);
playblocking(player);
disp('Playing Latin Original');
player = audioplayer(sound_latin, fs_latin);
playblocking(player);
disp('Playing Latin Compressed');
player = audioplayer(decoded_latin, fs_latin);
playblocking(player);
disp('Playing Taunt Original');
player = audioplayer(sound_taunt, fs_taunt);
playblocking(player);
disp('Playing Taunt Compressed');
player = audioplayer(decoded_taunt, fs_taunt);
playblocking(player);

%% Spectrograms for Mono Sound Samples
figure('name', "Sax Riff")
subplot(1,2,1)
spectrogram(sound_sax, 512, 'yaxis')
title('Original')
subplot(1,2,2)
spectrogram(decoded_sax, 512, 'yaxis')
title('Post-Compression')

figure('name', "Pink Panther")
subplot(1,2,1)
spectrogram(sound_panther, 512, 'yaxis')
title('Original')
subplot(1,2,2)
spectrogram(decoded_panther, 512, 'yaxis')
title('Post-Compression')

figure('name', "Cantina")
subplot(1,2,1)
spectrogram(sound_cantina, 512, 'yaxis')
title('Original')
subplot(1,2,2)
spectrogram(decoded_cantina, 512, 'yaxis')
title('Post-Compression')

figure('name', "Taunting Speech")
subplot(1,2,1)
spectrogram(sound_taunt, 512, 'yaxis')
title('Original')
subplot(1,2,2)
spectrogram(decoded_taunt, 512, 'yaxis')
title('Post-Compression')
