function soundVector = oscillator(AMP, FREQ, WF, PHASE, constants)
%oscillator models an oscillator unit generator, taking in amplitude,
%frequency, a waveform, and a phase offset as inputs.

%% Setup
numPeriods = constants.durationChord*FREQ;
PHASE = mod(PHASE, 2*pi);

% Interpolation function for a wraparound effect; i.e., the current bin is
% between 0 and 1.
interpWrap = @(vector, bin) bin*vector(1) + (1-bin)*vector(end);

%% Identify the waveform
% Four waveforms were generated, with 1024 sample points.
if (isstring(WF) || ischar(WF))
    switch WF
        case 'sine'
            WF = constants.Waveforms(:,1)';
        case "square"
            WF = constants.Waveforms(:,2)';
        case "sawtooth"
            WF = constants.Waveforms(:,3)';
        case "triangle"
            WF = constants.Waveforms(:,4)';
        otherwise
            error("Improper waveform specified.")
    end
elseif isvector(WF)
    % Normalize the custom waveform
    WF = WF/max(WF);
else
    error("Improper waveform specified.")
end

%% Sample the waveform to generate a single period

% Find the length of the wave table
numBins = length(WF);

% Find the sampling increment and the starting bin of the wave table
sampIncrement = numBins*FREQ/constants.fs;
startBin = mod((PHASE/(2*pi) * numBins) + 1, numBins);

% Build a single period, at the given frequency
spot = 1;
for ticker = startBin:sampIncrement:(numBins+startBin)
    % Find the location in the wave table
    readFrom = mod(ticker+1,numBins);
    % Interpolate the value based on the location
    if readFrom < 1
        period(spot) = AMP*interpWrap(WF, readFrom);
    else
        period(spot) = AMP*interp1(1:numBins, WF, readFrom);
    end
    % Increment
    spot = spot + 1;
end

%% Repeat the period for the duration of the audio
soundVector = [repmat(period, 1, floor(numPeriods)), period(1:floor(mod(numPeriods, floor(numPeriods))*length(WF)))];

end