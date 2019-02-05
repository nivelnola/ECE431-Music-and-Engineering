function [freq] = note2freq(note, temperament)
%note2freq parses a string representing a note, and returns the
%corresponding Hz frequency. 
switch temperament
    case {'equal','Equal'}
        switch note
            case 'A4'
                freq = 440;
            case {'A#','Eb'}
                freq = 466.1638;
            case {'B','Cb'}
                freq = 493.8833;
            case {'C'}
                freq = 
C#/Db
D
D#/Eb
E/Fb
E#/F
F#/Gb
G
G#/Ab

        end
        
end

end

