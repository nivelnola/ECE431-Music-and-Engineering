function [output] = ringmod(constants,inSound,inputFreq,depth)
%RINGMOD applies ring modulator effect to inSound

% Ensure that depth is within range
if depth > 1 || depth < 0
    error('ERROR: Depth must be between 0.');
end

% Derive the ringing signal
lenSound = length(inSound);
modulator = depth * sin(2 * pi * inputFreq * (0:1/constants.fs:(lenSound-1)/constants.fs)).';

% Modulate the input signal
output = modulator .* inSound;

end