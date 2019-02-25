function soundVector = create_sound(instrument, notes, constants)
%create_sound takes an instrument, a note, and the given constants and
%outputs a sound vector of the note being played.

soundVector = zeros(length(notes),instrument.totalTime);
if length(notes) == 1
    notes = {notes};
end

%% Additive Synthesis - Bell (Jerse, 4.28)
if instrument.sound == "Additive"
    A = [1 .67 1 1.8 2.67 1.67 1.46 1.33 1.33 1 1.33]';
    D = [1 .9 .65 .55 .325 .35 .25 .2 .15 .1 .075]';
    R = [.56 .56+1i .92 .92+1.7i 1.19 1.7 2 2.74 3 3.76 4.07]';

    for ticker = 1:length(notes)
        currNote = notes{ticker};
        DUR = currNote.duration;
        %fprintf("DUR: %i\n", DUR);
        FREQ = note2freq(currNote.note);
        sinMatrix = zeros(11,DUR);
        for counter = 1:11
            F2 = envelopeGen_exp(A(counter), floor(DUR*D(counter)), 0.0012, constants);
            %fprintf("F2 length: %i\n", length(F2));
            OSC = oscillator('sine', F2, FREQ*real(R(counter)) + imag(R(counter)), 0, floor(DUR*D(counter)), constants);
            for mover = 1:length(F2)
                sinMatrix(counter, mover) = OSC(mover);
            end
        end
        soundVector(ticker,currNote.start+1:DUR) = sum(sinMatrix);
    end
%% Subtractive Synthesis - 
elseif instrument.sound == "Subtractive"
    
end

%% Output
soundVector = sum(soundVector);

end

