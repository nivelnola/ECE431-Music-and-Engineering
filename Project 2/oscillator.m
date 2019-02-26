function soundVector = oscillator(WF, AMP, FREQ, PHASE, DUR, constants)
%oscillator models an oscillator unit generator, taking in amplitude,
%frequency, a waveform, and a phase offset as inputs.

%% Setup
soundVector = zeros(1,DUR);
PHASE = mod(PHASE, 2*pi);

% Interpolation function for a wraparound effect; i.e., the current bin is
% between 0 and 1.
interpWrap = @(vector, bin) bin*vector(1) + (1-bin)*vector(end);

%% Identify the carrier waveform
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
% elseif isvector(WF)
%     % Normalize the custom waveform
%     WF = WF/max(WF);
else
    error("Improper waveform specified.")
end

%% Accounting for Modulation
% Two possible parameters can be modulated:
%   Amplitude
%   Frequency
% However, we know that IF such a parameter is modulated, it will be a
% result of a different oscillator unit.
% Therefore, the parameter will already be configured to the sampling rate,
% AND will be the same duration (and therefore vector length) as the
% oscillator it is being fed to.
% 
% Amplitude:
%   Scalar:     if readFrom < 1
%                   period(spot) = AMP*interpWrap(WF, readFrom);
%               else
%                   period(spot) = AMP*interp1(1:numBins, WF, readFrom);
%               end
%   Vector:     if readFrom < 1
%                   period(spot) = AMP(spot)*interpWrap(WF, readFrom);
%               else
%                   period(spot) = AMP(spot)*interp1(1:numBins, WF, readFrom);
%               end
% 
% Frequency
%   Scalar:     sampIncrement = numBins*FREQ/constants.fs; <-- SCALAR
%               ...
%               for ticker = startBin:sampIncrement:(numBins+startBin)
%   Vector:     sampIncrement = numBins*FREQ/constants.fs; <-- VECTOR w/ same length as soundOut
%               ...
%               Periodicity no longer works - need to iterate over the
%               whole sound vector
%% Sample the waveform to generate a single period

% Find the length of the wave table
numBins = length(WF);

% Find the sampling increment and the starting bin of the wave table
sampIncrement = numBins*FREQ/constants.fs;
startBin = mod((PHASE/(2*pi) * numBins) + 1, numBins);

%% Scalar Frequency
switch isscalar(FREQ)
    case 1 % FREQ is a scalar
        % Build a single period, at the given frequency
        spot = 1;
        for ticker = startBin:sampIncrement:(numBins+startBin)
            % Find the location in the wave table
            readFrom = mod(ticker+1,numBins);
            % Interpolate the value based on the location
            if readFrom < 1
                period(spot) = interpWrap(WF, readFrom);
            else
                period(spot) = interp1(WF, readFrom);
            end
            % Increment
            spot = spot + 1;
        end

        % Repeat the period for the duration of the audio
        for ticker = 1:DUR
            switch isscalar(AMP)
                case 1 % AMP is a scalar
                    soundVector(ticker) = AMP*period(mod(ticker, length(period))+1);
                case 0 % AMP is a vector
                    soundVector(ticker) = AMP(ticker)*period(mod(ticker, length(period))+1);
            end
        end
%% Vector Frequency
    case 0 % FREQ is a vector
        tableTicker = startBin;
        
        for soundTicker = 1:DUR
            % Find the location in the wave table
            readFrom = mod(tableTicker+1,numBins);
            % Interpolate the value based on the location
            if readFrom < 1
                soundVector(soundTicker) = interpWrap(WF, readFrom);
            else
                soundVector(soundTicker) = interp1(WF, readFrom);
            end
            
            % Amplitude modulation
            switch isscalar(AMP)
                case 1 % AMP is a scalar
                    soundVector(soundTicker) = AMP*soundVector(soundTicker);
                case 0 % AMP is a vector
                    soundVector(soundTicker) = AMP(soundTicker)*soundVector(soundTicker);
            end
            
            % Increment the tableTicker by the instantaneous sampling increment
            tableTicker = tableTicker + sampIncrement(soundTicker);
        end
        
        % Amplitude modulation
        for ticker = 1:DUR
            switch isscalar(AMP)
                case 1 % AMP is a scalar
                    soundVector(ticker) = AMP*soundVector(mod(ticker, length(soundVector))+1);
                case 0 % AMP is a vector
                    soundVector(ticker) = AMP(ticker)*soundVector(mod(ticker, length(soundVector))+1);
            end
        end
end

end