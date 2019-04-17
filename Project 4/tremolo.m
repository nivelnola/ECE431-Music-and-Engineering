function [output] = tremolo(constants,inSound,LFO_type,LFO_rate,lag,depth)
%TREMOLO applies a stereo tremelo effect to inSound by multiplying the
%signal by a low frequency oscillator specified by LFO_type and LFO_rate. 
% depth determines the prevalence of the tremeloed signal in the output,
% and lag determines the delay between the left and right tracks. 

lenSound = length(inSound);

% Ensure LFO_rate is within range
assert(LFO_rate <= 5 && LFO_rate >= 0.05, 'ERROR: LFO rate must be between 0.05 Hz and 5 Hz.');

% Ensure that depth is within range
assert(depth <= 1 && depth >= 0, 'ERROR: Depth must be between 0 and 1.');

switch true
    case strcmpi(LFO_type, 'sin')
        modulator = depth * sin(2 * pi * LFO_rate * (lag + (0:1/constants.fs:(lenSound-1)/constants.fs))).';
    case strcmpi(LFO_type, 'triangle')
        modulator = depth * sawtooth(2 * pi * LFO_rate * (lag + (0:1/constants.fs:(lenSound-1)/constants.fs)), 0.5).';
    case strcmpi(LFO_type, 'square')
        modulator = depth * square(2 * pi * LFO_rate * (lag + (0:1/constants.fs:(lenSound-1)/constants.fs))).';
    otherwise
        error('ERROR: Improper LFO type selected: %s.\nMust be one of:\n\t"sin"\n\t"triangle"\n\t"square"', LFO_type);
end

% Modulate the input signal
output = modulator .* inSound;
end