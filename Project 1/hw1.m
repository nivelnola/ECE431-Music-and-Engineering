%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ECE-413: Music & Engineering
% Homework 1
% Alon S. Levin
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Setup
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all
clear functions
clear variables
dbstop if error


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Constants
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
constants.fs=44100;                 % Sampling rate in samples per second
constants.durationScale=0.5;        % Duration of notes in a scale
constants.durationChord=3;          % Duration of chords

constants.equalHalfTone = 2^(1/12);     % 100 cents equivalent on a Hertz scale
constants.equalScale = constants.equalHalfTone .^ (0:12);
% Written explicitly:
%     1.0000    Root
%     1.0595    Semitone (Minor second)
%     1.1225    Whole tone (Major second)
%     1.1892    Minor third
%     1.2599    Major third
%     1.3348    Perfect fourth
%     1.4142    Augmented fourth (Diminished Fifth)
%     1.4983    Perfect fifth
%     1.5874    Minor sixth
%     1.6818    Major sixth
%     1.7818    Minor seventh
%     1.8877    Major seventh
%     2.0000    Octave

constants.justScale = [ ...
    1 ...       % Unison
    16/15 ...   % Semitone
    10/9 ...    % Minor tone
    9/8 ...     % Major tone
    6/5 ...     % Minor third
    5/4 ...     % Major third
    4/3 ...     % Perfect fourth
    45/32 ...   % Augmented fourth
    64/45 ...   % Diminished fifth
    3/2 ...     % Perfect fifth
    8/5 ...     % Minor sixth
    5/3 ...     % Major sixth
    7/4 ...     % Harmonic minor seventh
    16/9 ...    % Grave minor seventh
    9/5 ...     % Minor seventh
    15/8 ...    % Major seventh
    2];         % Octave

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Question 2 - scales
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[soundMajorScaleJust]=create_scale('Major','Just','A',constants);
[soundMajorScaleEqual]=create_scale('Major','Equal','A',constants);
[soundMinorScaleJust]=create_scale('Minor','Just','A',constants);
[soundMinorScaleEqual]=create_scale('Minor','Equal','A',constants);

disp('Playing the Just Tempered Major Scale');
player = audioplayer(soundMajorScaleJust,constants.fs);
playblocking(player);
disp('Playing the Equal Tempered Major Scale');
player = audioplayer(soundMajorScaleEqual,constants.fs);
playblocking(player);
disp('Playing the Just Tempered Minor Scale');
player = audioplayer(soundMinorScaleJust,constants.fs);
playblocking(player);
disp('Playing the Equal Tempered Minor Scale');
player = audioplayer(soundMinorScaleEqual,constants.fs);
playblocking(player);
fprintf('\n');

% EXTRA CREDIT - Melodic and Harmonic scales
[soundHarmScaleJust]=create_scale('Harmonic','Just','A',constants);
[soundHarmScaleEqual]=create_scale('Harmonic','Equal','A',constants);
[soundMelScaleJust]=create_scale('Melodic','Just','A',constants);
[soundMelScaleEqual]=create_scale('Melodic','Equal','A',constants);

disp('Playing the Just Tempered Harmonic Scale');
player = audioplayer(soundHarmScaleJust,constants.fs);
playblocking(player);
disp('Playing the Equal Tempered Harmonic Scale');
player = audioplayer(soundHarmScaleEqual,constants.fs);
playblocking(player);
disp('Playing the Just Tempered Melodic Scale');
player = audioplayer(soundMelScaleJust,constants.fs);
playblocking(player);
disp('Playing the Equal Tempered Melodic Scale');
player = audioplayer(soundMelScaleEqual,constants.fs);
playblocking(player);
fprintf('\n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Question 3 - chords
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fund = 'A';

% major and minor chords
[soundMajorChordJust]=create_chord('Major','Just',fund,constants);
[soundMajorChordEqual]=create_chord('Major','Equal',fund,constants);
[soundMinorChordJust]=create_chord('Minor','Just',fund,constants);
[soundMinorChordEqual]=create_chord('Minor','Equal',fund,constants);

disp('Playing the Just Tempered Major Chord');
player = audioplayer(soundMajorChordJust,constants.fs);
playblocking(player);
disp('Playing the Equal Tempered Major Chord');
player = audioplayer(soundMajorChordEqual,constants.fs);
playblocking(player);
disp('Playing the Just Tempered Minor Chord');
player = audioplayer(soundMinorChordJust,constants.fs);
playblocking(player);
disp('Playing the Equal Tempered Minor Chord');
player = audioplayer(soundMinorChordEqual,constants.fs);
playblocking(player);
fprintf('\n');

% assorted other chords
[soundPowerChordJust]=create_chord('Power','Just',fund,constants);
[soundPowerChordEqual]=create_chord('Power','Equal',fund,constants);
[soundSus2ChordJust]=create_chord('Sus2','Just',fund,constants);
[soundSus2ChordEqual]=create_chord('Sus2','Equal',fund,constants);
[soundSus4ChordJust]=create_chord('Sus4','Just',fund,constants);
[soundSus4ChordEqual]=create_chord('Sus4','Equal',fund,constants);
[soundDom7ChordJust]=create_chord('Dom7','Just',fund,constants);
[soundDom7ChordEqual]=create_chord('Dom7','Equal',fund,constants);
[soundMin7ChordJust]=create_chord('Min7','Just',fund,constants);
[soundMin7ChordEqual]=create_chord('Min7','Equal',fund,constants);


disp('Playing the Just Tempered Power Chord');
player = audioplayer(soundPowerChordJust,constants.fs);
playblocking(player);
disp('Playing the Equal Tempered Power Chord');
player = audioplayer(soundPowerChordEqual,constants.fs);
playblocking(player);
disp('Playing the Just Tempered Sus2 Chord');
player = audioplayer(soundSus2ChordJust,constants.fs);
playblocking(player);
disp('Playing the Equal Tempered Sus2 Chord');
player = audioplayer(soundSus2ChordEqual,constants.fs);
playblocking(player);
disp('Playing the Just Tempered Sus4 Chord');
player = audioplayer(soundSus2ChordJust,constants.fs);
playblocking(player);
disp('Playing the Equal Tempered Sus4 Chord');
player = audioplayer(soundSus2ChordEqual,constants.fs);
playblocking(player);
disp('Playing the Just Tempered Dom7 Chord');
player = audioplayer(soundDom7ChordJust,constants.fs);
playblocking(player);
disp('Playing the Equal Tempered Dom7 Chord');
player = audioplayer(soundDom7ChordEqual,constants.fs);
playblocking(player);
disp('Playing the Just Tempered Min7 Chord');
player = audioplayer(soundMin7ChordJust,constants.fs);
playblocking(player);
disp('Playing the Equal Tempered Min7 Chord');
player = audioplayer(soundMin7ChordEqual,constants.fs);
playblocking(player);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Question 4 - plots
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
period = 1/note2freq(fund);
wavelength = 0:1/constants.fs:period;
wavelength10 = 0:1/constants.fs:10*period;

figure('name', 'Major Chord Comparisons')
subplot(2,1,1)
hold on
grid on
plot(wavelength, soundMajorChordEqual(1:length(wavelength)));
plot(wavelength, soundMajorChordJust(1:length(wavelength)));
title('Major Chord, Single Wavelength')
axis([0 period -0.4 0.4])
xlabel('Time (sec)')
ylabel('Amplitude')
legend('Equally Tempered', 'Just Tempered')

subplot(2,1,2)
hold on
grid on
plot(wavelength10, soundMajorChordEqual(1:length(wavelength10)));
plot(wavelength10, soundMajorChordJust(1:length(wavelength10)));
title('Major Chord, Ten Wavelengths')
axis([0 10*period -0.4 0.4])
xlabel('Time (sec)')
ylabel('Amplitude')
legend('Equally Tempered', 'Just Tempered')

figure('name', 'Minor Chord Comparisons')
subplot(2,1,1)
hold on
grid on
plot(wavelength, soundMinorChordEqual(1:length(wavelength)));
plot(wavelength, soundMinorChordJust(1:length(wavelength)));
title('Minor Chord, Single Wavelength')
axis([0 period -0.4 0.4])
xlabel('Time (sec)')
ylabel('Amplitude')
legend('Equally Tempered', 'Just Tempered')

subplot(2,1,2)
hold on
grid on
plot(wavelength10, soundMinorChordEqual(1:length(wavelength10)));
plot(wavelength10, soundMinorChordJust(1:length(wavelength10)));
title('Minor Chord, Ten Wavelengths')
axis([0 10*period -0.4 0.4])
xlabel('Time (sec)')
ylabel('Amplitude')
legend('Equally Tempered', 'Just Tempered')