function trackEvents = separateEvents(trackBytes)
% separateEvents accepts a decimal column vector representing the bytes of
% the track, with chunk type and length removed, and breaks this into an
% n-by-2 matrix:
%
%   [ <delta-time_1> <event_1_b1> ]
%   | NaN            <event_1_b2> |
%   | NaN            <event_1_b3> |
%   | <delta-time_2> <event_2_b1> |
%   | NaN            <event_2_b2> |
%   | <delta-time_3> <event_3_b1> |
%   [ NaN            <event_3_b2> ]
%
% As <events> are multiple bytes long, the delta-time column has NaN for
% the subsequent bytes in a single event.

% Pre-allocate an events matrix; this matrix is intentionally larger than
% needed, as there are many more bytes than events; all empty rows will be
% removed once the algorithm is run.
trackEvents = zeros(length(trackBytes), 2);

% Begin iterating through the raw bytes of the tracks, separating the
% matrix into events
streamTicker = 1;   % ticker that goes through the existing stream
eventsTicker = 1;   % ticker that goes through the new events vector

while streamTicker <= length(trackBytes)
    % Identify the current delta-time
    startByte = streamTicker;
    while trackBytes(streamTicker) >= 128
        streamTicker = streamTicker + 1;
    end
    deltaBytes = trackBytes(startByte:streamTicker);
    
    % Convert the deltaTime from VLQ to decimal and store it
    deltaTime = varlen2dec(deltaBytes);
    trackEvents(eventsTicker, 1) = deltaTime;
    
    % Go to the message definition
    streamTicker = streamTicker + 1;
    
    %% There are three types of events we have to look out for, with different formats
    % Meta Event (255) (FF <type=1byte> <length> <data>)
    if  trackBytes(streamTicker) == 255
        eventStart = streamTicker;
        
        % Increment to start checking length of event
        streamTicker = streamTicker + 2;
        
        % Find the event length
        startLenByte = streamTicker;
        while trackBytes(streamTicker) >= 128
            streamTicker = streamTicker + 1;
        end
        mesLenBytes = trackBytes(startLenByte:streamTicker);
        mesLen = varlen2dec(mesLenBytes);
        
        % Find total event length
        streamTicker = streamTicker + 1;
        totalLen = (streamTicker+mesLen) - eventStart;
        
        % Copy over the event, add the NaN timestamps
        trackEvents(eventsTicker:eventsTicker+totalLen-1, 2) = trackBytes(eventStart:streamTicker+mesLen-1);
        trackEvents(eventsTicker+1:eventsTicker+totalLen-1, 1) = NaN(totalLen-1,1);
        
        % Move to the next delta-time
        eventsTicker = eventsTicker + totalLen;
        streamTicker = streamTicker + mesLen;
    
    % Sysex (240 || 247) (F0 <length> <sysex_data> || F7 <length> <any_data>)
    elseif trackBytes(streamTicker) == 240 || trackBytes(streamTicker) == 247
        eventStart = streamTicker;
        
        % Increment to start checking length of event
        streamTicker = streamTicker + 1;
        
        % Find the event length
        startLenByte = streamTicker;
        while trackBytes(streamTicker) >= 128
            streamTicker = streamTicker + 1;
        end
        mesLenBytes = trackBytes(startLenByte:streamTicker);
        mesLen = varlen2dec(mesLenBytes);
        
        % Find total event length
        streamTicker = streamTicker + 1;
        totalLen = (streamTicker+mesLen) - eventStart;
        
        % Copy over the event, add the NaN timestamps
        trackEvents(eventsTicker:eventsTicker+totalLen-1, 2) = trackBytes(eventStart:streamTicker+mesLen-1);
        trackEvents(eventsTicker+1:eventsTicker+totalLen-1, 1) = NaN(totalLen-1,1);
        
        % Move to the next delta-time
        eventsTicker = eventsTicker + totalLen;
        streamTicker = streamTicker + mesLen;

    % MIDI Channel Voice Messages - 8n-En
    else
        switch true
            % 8n kk vv
            case ismember(trackBytes(streamTicker), 128:143)
                
            % 9n kk vv
            case ismember(trackBytes(streamTicker), 144:159)
                
            % An kk ww
            case ismember(trackBytes(streamTicker), 128:143)
                
            % Bn cc nn
            case ismember(trackBytes(streamTicker), 128:143)
                
            % Cn pp
            case ismember(trackBytes(streamTicker), 128:143)
                
            % Dn ww
            case ismember(trackBytes(streamTicker), 128:143)
                
            % En lsb msb
            case ismember(trackBytes(streamTicker), 128:143)
                
        end
    end
    
end

%% Remove All Extra Rows
trackEvents = trackEvents(1:eventsTicker-1,:);

end

