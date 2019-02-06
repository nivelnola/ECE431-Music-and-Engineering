function [freq] = note2freq(note)
%note2freq parses a string representing a note, and returns the
%corresponding Hz frequency on an equal-tempered scale, using A4 = 440 Hz. 
%This function is based on the  the database found on 
%http://pages.mtu.edu/~suits/notefreqs.html

%% Importing the Database
% Auto-generated by MATLAB

% Initialize variables.
filename = 'C:\Users\nivelnola\Documents\Cooper Union Files\Y3-S2\ECE-413 Music & Engineering\Project 1\Frequencies.csv';
delimiter = ',';

% Format for each line of text:
%   column1: text (%s)
%	column2: double (%f)
% For more information, see the TEXTSCAN documentation.
formatSpec = '%s%f%[^\n\r]';

% Open the text file.
fileID = fopen(filename,'r');

% Read columns of data according to the format.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string',  'ReturnOnError', false);

% Close the text file.
fclose(fileID);

% Create output variable
Frequencies = table(dataArray{1:end-1}, 'VariableNames', {'Note','Frequency'});

% Clear temporary variables
clearvars filename delimiter formatSpec fileID dataArray ans;

%% Getting the Note
if ~isstrprop(note(end),'digit')
    note = strcat(note, '4');
end
if ~sum(Frequencies.Note==note)
    error('Improper note: %s', note)
else
    index =  find(strcmp(note,table2array(Frequencies(:,1))));
    freq = table2array(Frequencies(index,2));
end
