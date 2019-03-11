function hex = varlen2hex(VLQ)
% varlen2hex DEPRECATED - DO NOT USE
% accepts a string representing a VLQ representation (up to 4
% bytes) of a hexadecimal number, and outputs a string representing the
% decoded hexadecimal value.

bin = hexToBinaryVector(VLQ,32);
bin(1:8:end) = [];
hex = binaryVectorToHex(bin,'MSBFirst');
hex = strcat(repmat('0', 1, 8-length(hex)), hex);

clear bin

end

