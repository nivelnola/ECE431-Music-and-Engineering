function tracks = analyzeTracks(trackBytes)
%analyzeTracks takes accepts the tracks cell array (obtained through
%chunkify) and separates each into a timestamp-event matrix, storing these
%in a cell array once more.

tracks = cell(length(trackBytes),1);

for ticker = 1:length(trackBytes)
    tracks{ticker} = separateEvents(trackBytes{ticker});
end

end