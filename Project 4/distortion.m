function [output]=distortion(constants,inSound,gain,tone)
%DISTORTION applies the specified gain to inSound, then applies clipping
%according to internal parameters and filtering according to the specified
%tone parameter

% Ensure proper tone
assert(tone <= 1 && tone >= 0, 'ERROR: Tone must be between 0 and 1.');

% Setup
threshold = 2;
passbandSize = .5;

% Amplify the input signal
ampedSound = gain * inSound;

% Apply clipping
ampedSound(ampedSound > threshold) = threshold;
ampedSound(ampedSound < -threshold) = -threshold;
clippedSound = ampedSound;

% Apply a Butterworth (max-flat) bandpass filter to the band of choice, as determined by tone
cornerFreq = tone*(1-passbandSize);
[b,a] = butter(1,[cornerFreq cornerFreq+passbandSize],'bandpass');
output = filter(b,a,clippedSound);

end