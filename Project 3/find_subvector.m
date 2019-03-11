function [index,numSpots] = find_subvector(mainVector,subVector)
%findSubarrays returns the indeces of the first element of the subvector,
%where it is contained in the main vector.

index = find(mainVector == subVector(1));
for ticker = 2:length(subVector)
    index = intersect(index + 1, find(mainVector == subVector(ticker)), 'stable');
end

index = index(:) - length(subVector) + 1;
numSpots = length(index);

end