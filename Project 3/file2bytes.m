function [stream, numBytes] = file2bytes(filename)
%file2bytes opens a file and reads the raw data into a decimal array, each
%byte represented by a cell; the size is also received

if ~strcmp(filename(end-3:end), '.mid')
    error("IMPROPER FILE - File extension does not match (.mid)");
end
fileID = fopen(filename, 'r');
stream = fread(fileID);
numBytes = length(stream);
fclose(fileID);

end