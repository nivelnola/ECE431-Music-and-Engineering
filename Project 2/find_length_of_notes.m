function [totalLength] = find_length_of_notes(notes)
%find_length_of_notes returns the sum duration of all notes

% Find the start and end times of each note
times = zeros(2, length(notes));
for ticker = 1:length(notes)
   times(ticker,1) = notes{ticker}.start;
   times(ticker,2) = times(ticker,1) + notes{ticker}.duration;
end

% The total duration is the difference between the last end time and the
% first start time
totalLength = max(times(2,:)) - min(times(1,:));

end

