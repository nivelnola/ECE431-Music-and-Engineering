function headerStruct = analyzeHeader(headerBytes)
%analyzeHeader accepts the data stream associated with the header, and
%analyzes its components to "specify some basic information about the data
%in the file."

%% Import the format and number of tracks directly from the header
headerStruct.format = bytes2dec(headerBytes(1:2));
headerStruct.ntrks = bytes2dec(headerBytes(3:4));

%% Define the delta-time, based on the <division> word (headerBytes(5:6))
division = de2bi(headerBytes(5:6),8,'left-msb');

% Bit 15 (MSB) represents how to interpret the delta-times
headerStruct.timeMode = division(1,1);

if ~headerStruct.timeMode   % If bit 15 (MSB) is 0
    % Ticks per beat == Ticks per quarter note == Pulses per quarter note
        % 1 Tick = [microseconds per beat]/TicksPerBeat = n microseconds
        % Microseconds per beat defined by [set tempo meta message]
    headerStruct.TicksPerBeat = bytes2dec(headerBytes(5:6));
    
    % Ensure that other mode parameters are not used
    headerStruct.FPS = NaN;
    headerStruct.TicksPerFrame = NaN;
else
    % 1 tick = 1,000,000/(FPS*TicksPerFrame) = n microseconds
    % FPS should be 24, 25, 29, or 30; it is stored in 2s-complement
    headerStruct.FPS = -1*(bi2de(division(1,2:8),'left-msb') - 128);
    if headerStruct.FPS == 29
        headerStruct.FPS = 29.97;
    end
    
    % Ticks per frame are listed directly
    headerStruct.TicksPerFrame = bi2de(division(2,:),'left-msb'); 
    
    % Ensure that other mode parameters are not used
    headerStruct.TicksPerBeat = NaN;
end

%% Add the raw bytes, just in case
headerStruct.raw = headerBytes;

end

