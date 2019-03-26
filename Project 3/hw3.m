%% MIDI Decoder and Player
% Alon S. Levin
% ECE-413: Music & Engineering

clear;
clc;
close all;

%% Choose a file
d = dir('MIDI Samples/');
fn = {d.name};
[indx,~] = listdlg('PromptString','Select a MIDI file:',...
                           'SelectionMode','single',...
                           'ListString',fn(3:end));
filename = fn{indx+2};

clear d fn indx tf

%% Preparing the file for reading
stream = file2bytes(strcat('MIDI Samples/', filename));
[h, t] = chunkify(stream);
header = analyzeHeader(h);
tracks = analyzeTracks(t);

%% Parsing the tracks for events
for tracker = 1:length(tracks)
    currTrack = tracks{tracker};
    
    ticker = 1;
    runningStatus = NaN;
    while ticker < length(currTrack)
        % Find the length (in bytes) of current event
        % An event begins when the timestamp is not NaN, and runs until the
        % next non-NaN timestamp
        eventStart = ticker;
        while isnan(currTrack(ticker+1, 1))
            eventEnd = ticker + 1;
            ticker = ticker + 1;
            if ticker == length(currTrack)
                break
            end
        end
        
        ticker = ticker + 1;
        
        % Prepare bytes, timestamp, running status for event analysis
        eventBytes = currTrack(eventStart:eventEnd, 2);
        eventTime = currTrack(eventStart,1);
        if eventBytes(1) >= 128 && eventBytes(1) < 240
            runningStatus = eventBytes(1);
        elseif ismember(eventBytes(1), [240, 247, 255])
            runningStatus = NaN;
        end
        
        %% Event analysis
        % Meta-Events
        if eventBytes(1) == 255
            if eventBytes(2:3) == [47;00]   % End of track
                continue;                   % Functions already take care of this automatically.

            elseif eventBytes(2:3) == [81; 03]  % Set tempo
                header.MicrosecondsPerBeat = bytes2dec(eventBytes(4:6));
                if ~isnan(header.TicksPerBeat)
                    header.MicrosecondsPerTick = header.MicrosecondsPerBeat/header.TicksPerBeat;
                end
                
            else % Other meta-events, not critical to playing a song, to be added.
                continue;
            end
            
        % Sysex Events
        elseif ismember(eventBytes(1), [240, 247])
            continue;                   % Sysex events not critical to playing a song, to be added.
        
        % MIDI Channel Events
        elseif eventBytes(1) < 240
            % Account for running status
            if eventBytes(1) < 128
                eventBytes = [runningStatus; eventBytes];
            end
            
        end
    end
end