function [soundOut] = create_chord( chordType,temperament, root, constants )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%    [ soundOut ] = create_scale( chordType,temperament, root, constants )
% 
% This function creates the sound output given the desired type of chord
%
% OUTPUTS
%   soundOut = The output sound vector
%
% INPUTS
%   chordType = Must support 'Major' and 'Minor' at a minimum
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


switch chordType
    case {'Major','major','M','Maj','maj'}
        chordID = [1 0 0 0 1 0 0 1 0 0 0 0 0];  % Root, major third, perfect fifth
    case {'Minor','minor','m','Min','min'}
        chordID = [1 0 0 1 0 0 0 1 0 0 0 0 0];  % Root, minor third, perfect fifth
    case {'Power','power','pow'}
        chordID = [1 0 0 0 0 0 0 1 0 0 0 0 0];  % Root, perfect fifth
    case {'Sus2','sus2','s2','S2'}
        chordID = [1 0 1 0 0 0 0 1 0 0 0 0 0];  % Root, major second, perfect fifth
    case {'Sus4','sus4','s4','S4'}
        chordID = [1 0 0 0 0 1 0 1 0 0 0 0 0];  % Root, perfect fourth, perfect fifth
    case {'Dom7','dom7','Dominant7', '7'}
        chordID = [1 0 0 0 1 0 0 1 0 0 1 0 0];  % Root, major third, perfect fifth, minor seventh
    case {'Min7','min7','Minor7', 'm7'}
        chordID = [1 0 0 1 0 0 0 1 0 0 1 0 0];  % Root, minor third, perfect fifth, minor seventh
    otherwise
        error('Inproper chord specified');
end

switch temperament
    case {'just','Just'}
    case {'equal','Equal'}
    otherwise
        error('Inproper temperament specified')
end


% Complete with chord vectors

end