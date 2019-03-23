function dec = varlen2dec(VLQ)
%varlen2dec accepts a column vector of decimal bytes (up to 4) representing
%a VLQ number, and outputs its actual decimal representation

% Get the binary values of each byte, one byte per column, MSB@1 --> LSB@8
old_bi = de2bi(VLQ,8,'left-msb');

% Remove the MSB (indicator for VLQ!), and rearrange all bytes into a
% single row vector, MSB@1 --> LSB@end
new_bi = reshape(old_bi(1:length(VLQ), 2:8)', 1, 7*length(VLQ));

% Convert back to the proper decimal
dec = bi2de(new_bi,'left-msb');

end

