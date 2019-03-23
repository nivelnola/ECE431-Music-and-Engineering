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
    deltaBytes = [];
    while trackBytes(streamTicker) >= 128            %% TEST THIS
        deltaBytes = [deltaBytes; trackBytes(streamTicker)];
        streamTicker = streamTicker + 1;
    end
    deltaBytes = [deltaBytes; trackBytes(streamTicker)];
    streamTicker = streamTicker + 1;
    
    % Convert the deltaTime from VLQ to decimal
    deltaTime = varlen2dec(deltaBytes);
    trackEvents(eventsTicker, 1) = deltaTime;
    
    %% There are three types of events we have to look out for, with different formats
    % Sysex (240 || 247)
    if trackBytes(streamTicker) == 240 || trackBytes(streamTicker) == 247
        eventStart = streamTicker;
        % Increment to start checking length of event
        streamTicker = streamTicker + 1;
        mesLenBytes = [];
        while trackBytes(streamTicker) >= 128            %% TEST THIS
            mesLenBytes = [mesLenBytes; trackBytes(streamTicker)];
            streamTicker = streamTicker + 1;
        end
        mesLenBytes = [mesLenBytes; trackBytes(streamTicker)]
        streamTicker = streamTicker + 1;
        mesLen = varlen2dec(mesLenBytes);
        
        totalLen = (streamTicker+mesLen) - eventStart;        
        trackEvents(eventsTicker:eventsTicker+totalLen-1, 2) = trackBytes(eventStart:streamTicker+mesLen-1);

        eventsTicker = eventsTicker + mesLen;
        streamTicker = streamTicker + mesLen;
        
    % Meta Event (255)
    elseif  trackBytes(streamTicker) == 255
        eventStart = streamTicker;
        
        % Increment to start checking length of event
        streamTicker = streamTicker + 2;
        mesLenBytes = [];
        while trackBytes(streamTicker) >= 128            %% TEST THIS
            mesLenBytes = [mesLenBytes; trackBytes(streamTicker)];
            streamTicker = streamTicker + 1;
        end
        mesLenBytes = [mesLenBytes; trackBytes(streamTicker)];
        streamTicker = streamTicker + 1;
        mesLen = varlen2dec(mesLenBytes);
        
        totalLen = (streamTicker+mesLen) - eventStart
        trackEvents(eventsTicker:eventsTicker+totalLen-1, 2) = trackBytes(eventStart:streamTicker+mesLen-1);
        trackEvents(eventsTicker+1:eventsTicker+totalLen-1, 1) = NaN(totalLen-1,1);
        
        eventsTicker = eventsTicker + totalLen
        streamTicker = streamTicker + mesLen
    end
    
end

%% Remove All Extra Rows
trackEvents = trackEvents(1:eventsTicker-1,:);

end

