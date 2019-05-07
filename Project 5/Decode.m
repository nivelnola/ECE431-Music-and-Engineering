function [output] = Decode(postPsychIn,DMATRIX)
% Reconstructs a sound file after psychoacoustic compression

%postPsychIn = [postPsychIn, zeros(32,15)];    %To preserve input and output lengths

% Setup & Pre-allocation
lenInput = length(postPsychIn);
V = zeros(1, 1024);
U = zeros(1, 512);
output = zeros(1,32*lenInput);

% Calculate M-inverse
k_grid = (0:63)';
i_grid = 0:31;
M_inv = cos(pi*(k_grid+16)*(2*i_grid+1)/64);

for input_ticker = 1:lenInput
    V(1,65:end) = V(1,1:960);
    V(1:64) =(M_inv*postPsychIn(:,input_ticker)).';

    for ticker = 0:7
        for counter = 0:31
            U(counter + 64*ticker + 1) = V(counter + 128*ticker + 1);
            U(counter + 64*ticker + 33) = V(counter + 128*ticker + 97);
        end
    end

    W = U .* DMATRIX;

    output_temp = zeros(1,32);        %32 output samples corresponding to subband snapshot
    for ticker = 0:31
        for counter = 0:15
            output_temp(ticker+1) = output_temp(ticker+1) + W(ticker+32*counter+1);
        end
    end

    output(32*(input_ticker-1) + 1:(32*input_ticker)) = output_temp;     %Output
end

end

