function dec = varlen2dec(VLQ)
%varlen2dec accepts a string representing a VLQ representation of a
%hexadecimal number, and outputs its decimal representation

bin = hexToBinaryVector(VLQ,32);
bin(1:8:end) = [];
dec = bi2de(bin,'left-msb');

end

