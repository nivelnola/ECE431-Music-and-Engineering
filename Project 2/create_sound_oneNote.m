function soundVector = create_sound_oneNote(instrument, note, constants)
%create_sound takes an instrument, a note, and the given constants and
%outputs a sound vector of the note being played.

soundVector = zeros(1,note.duration);
noteStruct = note;

%% Additive Synthesis - Bell (Jerse, 4.28)
if instrument.sound == "Additive"
    A = [1 .67 1 1.8 2.67 1.67 1.46 1.33 1.33 1 1.33]';
    D = [1 .9 .65 .55 .325 .35 .25 .2 .15 .1 .075]';
    R = [.56 .56+1i .92 .92+1.7i 1.19 1.7 2 2.74 3 3.76 4.07]';

    DUR = noteStruct.duration*8;
    FREQ = note2freq(noteStruct.note);
    sinMatrix = zeros(11,DUR);
    
    for counter = 1:11
        F2 = envelopeGen_exp(A(counter), floor(DUR*D(counter)), 0.0012, constants);
        %fprintf("F2 length: %i\n", length(F2));
        OSC = oscillator('sine', F2, FREQ*real(R(counter)) + imag(R(counter)), 0, floor(DUR*D(counter)), constants);
        for mover = 1:length(F2)
            sinMatrix(counter, mover) = OSC(mover);
        end
    end
    
    soundVector = sum(sinMatrix);
    
%% Subtractive Synthesis - Square Wave
elseif instrument.sound == "Subtractive"
    DUR = noteStruct.duration;
    FREQ = note2freq(noteStruct.note);

    mainOsc = oscillator('square', 10, FREQ, 0, DUR, constants);

    filter = dsp.VariableBandwidthFIRFilter(...
        'FilterType', 'lowpass',...
        'FilterOrder', 100,...
        'SampleRate', constants.fs,...
        'CutoffFrequency', 2500);

    for counter = 1:400:length(soundVector)
        newWave = filter(mainOsc(counter:counter+399));
        soundVector(counter:counter+399) = newWave;
        filter.CutoffFrequency = filter.CutoffFrequency - 5;
    end
end

%% Output

end

