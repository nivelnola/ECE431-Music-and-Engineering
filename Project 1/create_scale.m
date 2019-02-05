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
root_freq = note2freq(root, temperament);

switch temperament
    case {'just','Just'}
        switch scaleType
            case {'Major','major','M','Maj','maj'}
                scaleID = [1 0 0 1 0 1 1 0 0 1 0 1 0 0 0 1 1];
            case {'Minor','minor','m','Min','min'}
                scaleID = [1 0 0 1 1 0 1 0 0 1 1 0 0 0 1 0 1]; 
            case {'Harmonic', 'harmonic', 'Harm', 'harm'}
                scaleID = [1 0 0 1 1 0 1 0 0 1 1 0 0 0 0 1 1];
            case {'Melodic', 'melodic', 'Mel', 'mel'}
                scaleID = [1 0 0 1 1 0 1 0 0 1 0 1 0 0 0 1 1];
            otherwise
                error('Improper scale specified.');
        end
        
        frontFreqs = constants.justScale .* scaleID * root_freq;
        frontFreqs = frontFreqs(frontFreqs ~= 0);
        
        switch scaleType
            case {'Melodic', 'melodic', 'Mel', 'mel'}
                backFreqs = constants.justScale .* [1 0 0 1 1 0 1 0 0 1 1 0 0 0 1 0 1] * root_freq;
                backFreqs = backFreqs(backFreqs ~= 0);
                backFreqs = fliplr(backFreqs(1:end-1));
            otherwise
                backFreqs = fliplr(frontFreqs(1:end-1));
        end
        
        outputFreqs = [frontFreqs backFreqs];
        
    case {'equal','Equal'}
        switch scaleType
            case {'Major','major','M','Maj','maj'}
                scaleID = [1 0 1 0 1 1 0 1 0 1 0 1 1];
            case {'Minor','minor','m','Min','min'}
                scaleID = [1 0 1 1 0 1 0 1 1 0 1 0 1]; 
            case {'Harmonic', 'harmonic', 'Harm', 'harm'}
                scaleID = [1 0 1 1 0 1 0 1 1 0 0 1 1];
            case {'Melodic', 'melodic', 'Mel', 'mel'}
                scaleID = [1 0 1 1 0 1 0 1 0 1 0 1 1];
            otherwise
                error('Improper scale specified.');
        end
        
        frontFreqs = constants.equalScale .* scaleID * root_freq;
        frontFreqs = frontFreqs(frontFreqs ~= 0);
        
        switch scaleType
            case {'Melodic', 'melodic', 'Mel', 'mel'}
                backFreqs = constants.equalScale .* [1 0 1 1 0 1 0 1 1 0 1 0 1] * root_freq;
                backFreqs = backFreqs(backFreqs ~= 0);
                backFreqs = fliplr(backFreqs(1:end-1));
            otherwise
                backFreqs = fliplr(frontFreqs(1:end-1));
        end
        
        outputFreqs = [frontFreqs backFreqs];
end

% Create the vector based on the notes

end