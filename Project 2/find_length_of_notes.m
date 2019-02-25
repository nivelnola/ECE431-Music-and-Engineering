function [totalLength] = find_length_of_notes(notes)
%find_length_of_notes returns the sum duration of all notes

% Find the start and end times of each note
totalLength = 0;
for ticker = 1:length(notes)
    totalLength = max(totalLength, notes{ticker}.start + notes{ticker}.duration);
    disp(totalLength);
end

end

