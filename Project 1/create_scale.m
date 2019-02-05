function [soundOut] = create_scale( scaleType,temperament, root, constants )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%    [ soundOut ] = create_scale( scaleType,temperament, root, constants )
% 
% This function creates the sound output given the desired type of scale
%
% OUTPUTS
%   soundOut = The output sound vector
%
% INPUTS
%   scaleType = Must support 'Major' and 'Minor' at a minimum
%   temperament = may be 'just' or 'equal'
%   root = The Base frequeny (expressed as a letter followed by a number
%       where A4 = 440 (the A above middle C)
%       See http://en.wikipedia.org/wiki/Piano_key_frequencies for note
%       numbers and frequencies
%   constants = the constants structure
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Constants
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TODO: Add all relevant constants 

switch scaleType
    case {'Major','major','M','Maj','maj'}
        scaleID = [1 0 1 0 1 1 0 1 0 1 0 1 1];
        % TODO: Complete with interval pattern for the major scale
    case {'Minor','minor','m','Min','min'}
        scaleID = [1 0 1 1 0 1 0 1 1 0 1 0 1];
        % TODO: Complete with interval pattern for the minor scale
    case {'Harmonic', 'harmonic', 'Harm', 'harm'}
        scaleID = [1 0 1 1 0 1 0 1 1 0 0 1 1];
    case {'Melodic', 'melodic', 'Mel', 'mel'}
        scaleID = [1 0 1 1 0 1 0 1 0 1 0 1 1];
    otherwise
        error('Improper scale specified');
end

switch temperament
    case {'just','Just'}
	% TODO: Pull the Just tempered ratios based on the pattern from the scales
    case {'equal','Equal'}
	% TODO: Pull the equal tempered ratios based on the pattern from the scales
    otherwise
        error('Improper temperament specified')
end


% Create the vector based on the notes

end
