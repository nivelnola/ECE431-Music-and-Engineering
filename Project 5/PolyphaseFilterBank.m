function [output] = PolyphaseFilterBank(audio, CMATRIX)
%PolyphaseFilterBank applies the time to frequency mapping as the first
%stage in MPEG encoding, based on Eq. 1 from Davis Pan's tutorial.

% Pad soundIn vector to ensure it is a multiple of 512
audio = [audio', zeros(1, 32-(mod(length(audio), 32)))];
lenSound = length(audio);

% Construct the M matrix
k_grid = 0:63;
i_grid = (0:31)';
M = cos(pi*(2*i_grid+1)*(k_grid-16)/64);

% Pre-allocate buffer, output matrix
buffer = zeros(1,512);
output = nan(32, lenSound/32);

% Perform the filtering
for audioLoader = 0:(lenSound/32 - 1)
    % Push 32 samples into the FIFO buffer
    buffer = [fliplr(audio(audioLoader*32+1:audioLoader*32+32)), buffer(1:end-32)];
    
    % Window the samples
    Z = buffer .* CMATRIX;
    
    % Perform calculation using M matrix, push to output
    Y = zeros(1,64);
    for counter = 0:7
        Y = Y + Z((counter*64 + 1):(counter*64 + 64));
    end
    output(:,audioLoader+1) = M * Y.';
end