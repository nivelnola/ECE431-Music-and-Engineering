function [soundOut,gain] = compressor(constants, inSound, threshold, slope, attack, avg_len)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%    [soundOut,gain] = compressor(constants,inSound,threshold,attack,avg_len)
%
%COMPRESSOR applies variable gain to the inSound vector by limiting the
% level of any audio sample of avg_length with rms power greater than
% threshold according to slope
%
% OUTPUTS
%   soundOut    = The soundOut sound vector
%   gain        = The vector of gain applied to inSound to create soundOut
%
% INPUTS
%   constants   = the constants structure
%   inSound     = The input audio vector
%   threshold   = The level setting to switch between the two gain settings
%   slope       = The ratio of input to gain to apply to the signal past
%   the threshold
%   attack      = time over which the gain changes
%   avg_len     = amount of time to average over for the power measurement

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Setup
lenSound = length(inSound);
avg_bins = floor(constants.fs * avg_len * 10^(-6));
gain = ones(lenSound, 1);

for ticker = 1:lenSound
    % Find the power in the current span
    startBin = max(ticker-avg_bins, 1);
    currPower = rms(inSound(startBin:ticker));

    % Compare power to threshold
    if currPower <= threshold
        gain(startBin:ticker) = gain(startBin:ticker) * 1;
    else
        currGain = max(0, 1 - slope*(currPower - threshold));
        gain(startBin:ticker) = currGain * gain(startBin:ticker);
    end
end

% Obtain the output sound by multiplying the input sound vector by the gain
soundOut = gain.*inSound;

end