function soundVector = oscillator(AMP, FREQ, WF, PHASE, constants)
%oscillator models an oscillator unit generator, taking in amplitude,
%frequency, a waveform, and a phase offset as inputs.

numPeriods = constants.durationScale*FREQ;

%interpolate = @(vector, bin) (bin-fix(bin))*vector(ceil(bin)) + (1-(bin-fix(bin)))*vector(floor(bin));

if isvector(WF) && ~(isstring(WF) || ischar(WF))
    WF = WF/max(WF);
    numBins = size(WF);
    sampIncrement = numBins*FREQ/constants.fs;
    startBin = (PHASE/(2*pi))*numBins;
    
    spot = 1;
    for ticker = startBin:sampIncrement:(numBins+startBin)
        readFrom = mod(ticker,numBins)+1;
        %period(spot) = AMP*interpolate(WF', readFrom);
        period = AMP*WF(ceil(readFrom));
        spot = spot + 1;
    end
    
else
    numBins = size(constants.Waveforms,1);
    sampIncrement = numBins*FREQ/constants.fs;
    startBin = (PHASE/(2*pi))*numBins;
    
    spot = 1;
    for ticker = startBin:sampIncrement:(numBins+startBin)
        readFrom = mod(ticker+1,numBins);
        %disp(spot);
        %disp(ticker);
        %disp(readFrom);
        switch WF
            case "sine"
                %period(spot) = AMP*interpolate(constants.Waveforms(:,1), readFrom);
                period(spot) = AMP*constants.Waveforms(ceil(readFrom),1);
            case "square"
                %period(spot) = AMP*interpolate(constants.Waveforms(:,2), readFrom);
                period(spot) = AMP*constants.Waveforms(ceil(readFrom),2);
            case "sawtooth"
                %period(spot) = AMP*interpolate(constants.Waveforms(:,3), readFrom);
                period(spot) = AMP*constants.Waveforms(ceil(readFrom),3);
            case "triangle"
                %period(spot) = AMP*interpolate(constants.Waveforms(:,4), readFrom);
                period(spot) = AMP*constants.Waveforms(ceil(readFrom),4);
            otherwise
                error("Improper waveform specified.")
        end
        spot = spot + 1;
    end
end

soundVector = [repmat(period, 1, floor(numPeriods)), period(1:floor(mod(numPeriods, floor(numPeriods))*length(WF)))];
%soundVector = period;
end