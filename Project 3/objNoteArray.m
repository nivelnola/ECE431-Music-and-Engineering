classdef objNoteArray
    % Array of objNote objects to be passed to the audio player

    % Public, tunable properties
    properties
        arrayNotes = objNote.empty;
    end

    properties(DiscreteState)
        % N/A
    end

    % Pre-computed constants
    properties(Access = private)
        % N/A
    end

    methods
        % obj = objNote(noteNumber,temperament,key,startTime,endTime,amplitude)
        function obj = objNoteArray(noteMatrix)
            for ticker = 1:size(noteMatrix,1)
                obj.arrayNotes(ticker) = objNote(...
                    noteMatrix(ticker,1), ...   %noteNumber
                    noteMatrix(ticker,2), ...   %instrument
                    'equal', ...                %temperament - MIDI uses equal
                    'C', ...                    %key - C used, not relevant, but kept to maintain functionality
                    noteMatrix(ticker,3), ...   %startTime
                    noteMatrix(ticker,4), ...   %endTime
                    noteMatrix(ticker,5));      %amplitude
            end
        end
    end
end
