function [soundOut]=flanger(constants,inSound,depth,delay,width,LFO_rate,LFO_type)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%    [soundOut]=flanger(constants,inSound,depth,delay,width,LFO_rate)
%
% This function creates the sound output from the flanger effect
%
% OUTPUTS
%   soundOut = The output sound vector
%
% INPUTS
%   constants   = the constants structure
%   inSound     = The input audio vector
%   depth       = depth setting delayed_Signal seconds
%   delay       = minimum time delay delayed_Signal seconds
%   width       = total variation of the time delay from the minimum to the maximum
%   LFO_rate    = The frequency of the Low Frequency oscillator delayed_Signal Hz
%   LFO_Type    = Sine or Triangle
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ensure proper delay time
assert(delay <= 10e-3 && delay >= 100e-6, 'ERROR: Delay time must be between 100us and 10ms.');
% Ensure that depth is within range
assert(depth <= 1 && depth >= 0, 'ERROR: Depth must be between 0 and 1.');

% Setup
lenSound = length(inSound);
delayed_Signal = zeros(lenSound,1);

% Choose an LFO
switch true
    case strcmpi(LFO_type, 'sin')
        LFO = width * sin(2 * pi * LFO_rate * (0:1/constants.fs:(lenSound-1)/constants.fs)).';
    case strcmpi(LFO_type, 'triangle')
        LFO = width * sawtooth(2 * pi * LFO_rate * (0:1/constants.fs:(lenSound-1)/constants.fs), 0.5).';
end

% Implement the delay, based on the LFO
time_delay = LFO + (delay + .5*width);
sample_delay = round(time_delay * constants.fs);
for ticker = max(sample_delay):lenSound-1
    delayed_Signal(ticker) = inSound(ticker - sample_delay(ticker) + 1);
end

% Add the depth-modified delayed signal to the input sound
soundOut = depth*delayed_Signal + inSound;
end
