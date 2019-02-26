function soundVector = create_sound_oneNote(instrument, note, constants)
%create_sound takes an instrument, a note, and the given constants and
%outputs a sound vector of the note being played.

soundVector = zeros(1,note.duration);
noteStruct = note;

%% Additive Synthesis - Bell (Jerse, 4.28)
if instrument.sound == "Additive"
    A = [1 .67 1 1.8 2.67 1.67 1.46 1.33 1.33 1 1.33]';
    D = [1 .9 .65 .55 .325 .35 .25 .2 .15 .1 .075]';
    R = [.56 .56 .92 .92 1.19 1.7 2 2.74 3 3.76 4.07]';

    DUR = noteStruct.duration*8;
    FREQ = note2freq(noteStruct.note);
    sinMatrix = zeros(11,DUR);
    
    for counter = 1:11
        F2 = envelopeGen_exp(A(counter), floor(DUR*D(counter)), 0.0012, constants);
        %fprintf("F2 length: %i\n", length(F2));
        currFreq = FREQ*R(counter);
        if counter == 2
            currFreq = currFreq + 1;
        elseif counter == 4
            currFreq = currFreq + 1.7;
        end
        OSC = oscillator('sine', F2, currFreq, 0, floor(DUR*D(counter)), constants);
        for mover = 1:length(F2)
            sinMatrix(counter, mover) = OSC(mover);
        end
    end
    
    soundVector = sum(sinMatrix);
    
%% Subtractive Synthesis - Square Wave w/ Closing Filter Amplitude Modulation
elseif instrument.sound == "Subtractive"
    DUR = noteStruct.duration;
    FREQ = note2freq(noteStruct.note);
    ENV = envelopeGEN_ASD(.2*DUR,10,DUR,.10*DUR);

    mainOsc = oscillator('square', 7, FREQ, 0, DUR, constants);
    
    filter = dsp.VariableBandwidthFIRFilter(...
        'FilterType', 'lowpass',...
        'FilterOrder', 100,...
        'SampleRate', constants.fs,...
        'CutoffFrequency', 2500);

    for counter = 1:400:length(soundVector)
        newWave = filter(mainOsc(counter:counter+399)).*ENV(counter:counter+399);
        soundVector(counter:counter+399) = newWave;
        filter.CutoffFrequency = filter.CutoffFrequency - 5;
    end
    
 %% Frequency Modulation - Brasslike Timbre
elseif instrument.sound == "FM"
    fc = note2freq(noteStruct.note);
    fm = fc;
    IMAX = 5;
    DUR = noteStruct.duration;
    
    F1 = envelopeGEN_ADSR((3/17)*DUR, (2.5/17)*DUR, (3/17)*DUR, 10, 7.5, DUR);
    F2 = envelopeGEN_ADSR((3/17)*DUR, (2.5/17)*DUR, (3/17)*DUR, fm*IMAX, .75*fm*IMAX, DUR);
    
    freqMod = oscillator('sine', F2, fm, 0, DUR, constants);
    soundVector = oscillator('sine', F1, fc+freqMod, 0, DUR, constants);
    
%% Wave Shaping
elseif instrument.sound == "Waveshaper"
    
    
%% Else
else
    error("Improper instrument sound!");
end

%% Output
figure
plot(soundVector);

end

