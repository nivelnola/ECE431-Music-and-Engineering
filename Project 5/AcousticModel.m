function [output] = AcousticModel(postFilterIn, fs)
%AcousticModel applies a basic psychoacoustic model to a post-polyphase
%filter input.

% Ensure that every set of 12 samples we take _actually_ has 12 samples
postFilterIn = [postFilterIn, zeros(32,12-mod(size(postFilterIn,2),12))]; 

% Pre-allocate the output
output = zeros(size(postFilterIn));

% Choose thresholds per subband, based on the threshold of hearing from the
% Fletcher-Munson curve
T = 1/fs;
f = ((1:32)*pi/(64*T))/1000;
thresholds = 3.64.*(f).^-0.8 - 6.5.*exp(-0.6.*(f - 3.3).^2) + (10e-3).*(f).^4;


% We look at 12 samples at time from the polyphase filter output, compute
% the power of the samples, and find the maximum within this range. We then
% consider the powers of each subband, with respect to the maximum power
% within a certain threshold. Anything falling below the threshold is
% discarded.
for ticker = 1:(length(postFilterIn)/12)
    for counter = 1:32
        currWindow_samples = postFilterIn(counter, (12*(ticker-1)+1):12*ticker);
        currWindow_power = 20*log10(abs(currWindow_samples));

        max_power = max(currWindow_power);                      %Find maximum power among the samples

        %Keep samples that are within the threshold of the max power.
        %Zero out if not within the threshold.
        mask = (currWindow_power > (max_power - thresholds(counter)));     
        output(counter, (12*(ticker-1)+1):12*ticker) = postFilterIn(counter,12*(ticker-1)+1:12*ticker).*mask;
    end
end


end