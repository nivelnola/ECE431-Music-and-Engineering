function [header, tracks] = chunkify(stream)
%chunkify splits a decimal-byte array representing a MIDI file into MIDI
%chunks, as per the specifications

%% Check for existence of a header ([77;84;104;100])
if (stream(1:4) ~= [77;84;104;100])
    error("IMPROPER FILE - No header found.")
end
%% Remove the header
% Find the length of the header, in bytes
lengthHeader = bi2de(reshape(de2bi(stream(5:8),8, 'left-msb')', 1, 32), 'left-msb');

% Remove the header (byte 9 --> byte 9+lengthHeader-1
header = stream(9:9+lengthHeader-1);

%% Find the starting positions of each track ([77;84;114;107]), list their sizes, and then separate the tracks into cells
[trackStart, numTracks] = find_subvector(stream, [77;84;114;107]);
trackSizes = zeros(numTracks, 1);
disp(trackStart)
tracks = cell(numTracks, 1);
for ticker = 1:numTracks
    trackSizes(ticker) = bi2de(reshape(de2bi(stream(trackStart(ticker)+4:trackStart(ticker)+7),8, 'left-msb')', 1, 32), 'left-msb');
    disp(trackSizes)
    tracks{ticker} = stream(trackStart(ticker)+8:trackStart(ticker)+8+trackSizes(ticker)-1);
end

end

