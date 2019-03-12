function num = bytes2dec(bytes)
%bytes2dec converts a column vector of left-msb decimal bytes into a single decimal value.

num = bi2de(reshape(de2bi(bytes, 8, 'left-msb')', 1, 8*length(bytes)), 'left-msb');

end

