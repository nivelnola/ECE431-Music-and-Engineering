%% MIDI Decoder and Player
% Alon S. Levin
% ECE-413: Music & Engineering
clear;
%clc;
close all;

%% Program Constants (from testscript.m)
constants                              = confConstants;
constants.BufferSize                   = 882;                                                    % Samples
constants.SamplingRate                 = 44100;                                                  % Samples per Second
constants.QueueDuration                = 0.1;                                                    % Seconds - Sets the latency in the objects
constants.TimePerBuffer                = constants.BufferSize / constants.SamplingRate;          % Seconds;

oscParams                              =confOsc;
oscParams.oscType                      = 'sine';
oscParams.oscAmpEnv.StartPoint         = 0;
oscParams.oscAmpEnv.ReleasePoint       = Inf;   % Time to release the note
oscParams.oscAmpEnv.AttackTime         = .02;  %Attack time in seconds
oscParams.oscAmpEnv.DecayTime          = .01;  %Decay time in seconds
oscParams.oscAmpEnv.SustainLevel       = 0.7;  % Sustain level
oscParams.oscAmpEnv.ReleaseTime        = .05;  % Time to release from sustain to zero

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

%% Preparing a note matrix
% Format:
%   [NoteID, Instrument, StartTime, EndTime, Amplitude, Channel, Track]
% We do not yet know how many notes we have, but we know we can have a
% maximum of the number of events in all tracks. We will shred off the
% extra notes at the end
totalEvents = 0;
for ticker = 1:length(tracks)
    totalEvents = totalEvents + length(tracks{ticker});
end
noteMatrix = NaN(totalEvents, 7);
numNotes = 0;

clear ticker totalEvents

%% Parsing the tracks for events
for tracker = 1:length(tracks)
    currTrack = tracks{tracker};
    
    ticker = 1; % Byte parser
    clock = 0;  % Clock for calculating global time based on deltas
    runningStatus = NaN;
    currInstrument = ones(16,1);
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
        
        % Prepare ticker for next byte
        ticker = ticker + 1;
        
        % Update clock
        clock = clock + currTrack(eventStart,1)*header.MicrosecondsPerTick;
        
        % Prepare bytes, running status for event analysis
        eventBytes = currTrack(eventStart:eventEnd, 2);
        eventTime = currTrack(eventStart,1);
        if eventBytes(1) >= 128 && eventBytes(1) < 240
            runningStatus = eventBytes(1);
        elseif ismember(eventBytes(1), [240, 247, 255])
            runningStatus = NaN;
        end
        
        %% Event analysis
        %% Meta-Events
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
            
        %% Sysex Events
        elseif ismember(eventBytes(1), [240, 247])
            continue;                   % Sysex events not critical to playing a song, to be added.
        
        %% MIDI Channel Events
        elseif eventBytes(1) < 240
            % Account for running status
            if eventBytes(1) < 128
                eventBytes = [runningStatus; eventBytes];
            end
            
            % Find the channel we're on
            currChannel = mod(eventBytes(1), 16) + 1;
            
            % All possible MIDI commands
            switch true
                % 8n kk vv      - NOTE OFF
                case ismember(eventBytes(1), 128:143)
                    note = eventBytes(2);
                    velocity = eventBytes(3); % This is currently unused when turning the note off.
                    
                    % Find the note to be turned off, set EndTime (sec)
                    noteLocation = find((noteMatrix(:,1) == note)&(noteMatrix(:,6) == currChannel), 1, 'last');
                    noteMatrix(noteLocation, 4) = clock*1e-6;
                    
                % 9n kk vv      - NOTE ON
                case ismember(eventBytes(1), 144:159)
                    note = eventBytes(2);
                    velocity = eventBytes(3);
                    
                    % If velocity is not 0, note on; else, note off
                    % As we do not yet know the time that the note starts
                    % playing, we set EndTime to inf.
                    if velocity
                        % Add note
                        numNotes = numNotes + 1;
                        noteMatrix(numNotes,:) = [note, currInstrument(currChannel), clock*1e-6, inf, .2*velocity/127, currChannel, tracker];
                    else
                        % Velocity is 0 - we need to update the noteMatrix
                        % with the EndTime
                        % Find the note to be turned off, set EndTime
                        noteLocation = find((noteMatrix(:,1) == note)&(noteMatrix(:,6) == currChannel), 1, 'last');
                        noteMatrix(noteLocation, 4) = clock*1e-6;
                    end
                    
                % An kk ww      - POLYPHONIC KEY PRESSURE
                case ismember(eventBytes(1), 160:175)
                    % To be added
                % Bn cc nn      - CONTROLLER CHANGE
                case ismember(eventBytes(1), 176:191)
                    % To be added
                % Cn pp         - PROGRAM CHANGE
                case ismember(eventBytes(1), 192:207)
                    currInstrument(currChannel) = mod(eventBytes(2), 2)+1;
                % Dn ww         - CHANNEL KEY PRESSURE
                case ismember(eventBytes(1), 208:223)
                    % To be added
                % En lsb msb    - PITCH BEND
                case ismember(eventBytes(1), 224:239)
                    % To be added
            end
        end
    end
end

%% Convert noteMatrix to array of Note Objects
% Remove extra rows at end of matrix
noteMatrix = noteMatrix(1:numNotes, :);
noteObjArray = objNoteArray(noteMatrix);

% Kill off any lasting notes
noteMatrix(noteMatrix == inf) = -1;
noteMatrix(noteMatrix(:,5) == -1) = max(noteMatrix(:,4));

%% Play the audio!
fprintf('File: %s\n', filename);
fprintf('Duration: %f seconds\n', max(noteMatrix(:,4)) - min(noteMatrix(:,5)));
fprintf('Microseconds per tick: %d\n', header.MicrosecondsPerTick);
playAudio(noteObjArray, oscParams, constants);