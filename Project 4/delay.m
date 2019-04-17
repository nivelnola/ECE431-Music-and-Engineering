function [output]=delay(constants,inSound,depth,delay_time,feedback)
%DELAY applies a delay effect to inSound which is delayed by delay_time 
% then added to the original signal according to depth and passed back as
% feedback with the feedback gain specified

% Ensure proper delay time
assert(delay_time < 8 && delay_time > 100e-6, 'ERROR: Delay time must be between 100us and 8s.');

% Setup
lenSound = length(inSound);
delayBins = delay_time * constants.fs;

% Allocate additional pad-room at end of clip
paddedSound = [inSound; zeros(delayBins,1)];
echo = zeros(lenSound+delayBins,1);

% Iterate through the echo vector, adding a feedback-gained echo to the
% input sound
for ticker = 1:lenSound
    echo(ticker + delayBins) = inSound(ticker) + (feedback * echo(ticker)); 
end

% Add the full echo vector to the input signal
output = paddedSound + depth*echo;

end