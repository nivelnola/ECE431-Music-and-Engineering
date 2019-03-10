function soundVector = create_sound(instrument, notes, constants)
%create_sound takes an instrument, a note, and the given constants and
%outputs a sound vector of the note being played.

soundVector = zeros(length(notes),instrument.totalTime);
if isstruct(notes)
    notes = {notes};
end

%% Additive Synthesis - Bell (Jerse, 4.28)
if instrument.sound == "Additive"
    A = [1 .67 1 1.8 2.67 1.67 1.46 1.33 1.33 1 1.33]';
    D = [1 .9 .65 .55 .325 .35 .25 .2 .15 .1 .075]';
    R = [.56 .56 .92 .92 1.19 1.7 2 2.74 3 3.76 4.07]';

    for noter = 1:length(notes)
        noteStruct = notes{noter};
        
        DUR = 10*noteStruct.duration;
        
        if instrument.temperament == "Just" && ~(noter == 1)
            switch instrument.mode
                case "Major"
                    switch noter
                        case 2
                            FREQ = note2freq(notes{1}.note)*9/8;
                        case 3
                            FREQ = note2freq(notes{1}.note)*3/2;
                    end
                case "Minor"
                    switch noter
                        case 2
                            FREQ = note2freq(notes{1}.note)*6/5;
                        case 3
                            FREQ = note2freq(notes{1}.note)*3/2;
                    end
            end
        else
            FREQ = note2freq(noteStruct.note);
        end
        
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
        
        soundVector(noter, (noteStruct.start + (1:10*noteStruct.duration))) = sum(sinMatrix);
    end
    
%% Subtractive Synthesis - Square Wave w/ Closing Filter Amplitude Modulation
elseif instrument.sound == "Subtractive"
    for noter = 1:length(notes)
        noteStruct = notes{noter};
        
        DUR = noteStruct.duration;
        if instrument.temperament == "Just" && ~(noter == 1)
            switch instrument.mode
                case "Major"
                    switch noter
                        case 2
                            FREQ = note2freq(notes{1}.note)*9/8;
                        case 3
                            FREQ = note2freq(notes{1}.note)*3/2;
                    end
                case "Minor"
                    switch noter
                        case 2
                            FREQ = note2freq(notes{1}.note)*6/5;
                        case 3
                            FREQ = note2freq(notes{1}.note)*3/2;
                    end
            end
        else
            FREQ = note2freq(noteStruct.note);
        end
        
        ENV = envelopeGEN_ASD(.2*DUR,10,DUR,.10*DUR);

        mainOsc = oscillator('square', 7, FREQ, 0, DUR, constants);

        filter = dsp.VariableBandwidthIIRFilter(...
            'FilterType', 'lowpass',...
            'FilterOrder', 48,...
            'SampleRate', constants.fs,...
            'PassbandFrequency', 200);

        for counter = 1:length(soundVector)/400:length(soundVector)
            index = length(soundVector)/400;
            newWave = filter(mainOsc(counter:counter+index-1)).*ENV(counter:counter+index-1);
            soundVector(noter, noteStruct.start+(counter:counter+index-1)) = newWave;
            filter.PassbandFrequency = filter.PassbandFrequency - .2;
        end
        
    end
    
%% Frequency Modulation - Brasslike Timbre (Jerse, 5.9d)
elseif instrument.sound == "FM"
    for noter = 1:length(notes)
        noteStruct = notes{noter};
        
        if instrument.temperament == "Just" && ~(noter == 1)
            switch instrument.mode
                case "Major"
                    switch noter
                        case 2
                            fc = note2freq(notes{1}.note)*9/8;
                        case 3
                            fc = note2freq(notes{1}.note)*3/2;
                    end
                case "Minor"
                    switch noter
                        case 2
                            fc = note2freq(notes{1}.note)*6/5;
                        case 3
                            fc = note2freq(notes{1}.note)*3/2;
                    end
            end
        else
            fc = note2freq(noteStruct.note);
        end
        
        fm = fc;
        IMAX = 5;
        DUR = 0.6*constants.fs;

        soundVector = zeros(length(notes),DUR);

        F1 = envelopeGEN_ADSR((3/17)*DUR, (2.5/17)*DUR, (3/17)*DUR, 10, 7.5, DUR);
        F2 = envelopeGEN_ADSR((3/17)*DUR, (2.5/17)*DUR, (3/17)*DUR, fm*IMAX, .75*fm*IMAX, DUR);

        freqMod = oscillator('sine', F2, fm, 0, DUR, constants);
        
        soundVector(noter,:) = oscillator('sine', F1, fc+freqMod, 0, DUR, constants);
    end
%% Wave Shaping - Drum (Jerse, 5.31)
elseif instrument.sound == "Waveshaper"
    for noter = 1:length(notes)
        noteStruct = notes{noter};
    
        DUR = 0.2*constants.fs;
        if instrument.temperament == "Just" && ~(noter == 1)
            switch instrument.mode
                case "Major"
                    switch noter
                        case 2
                            FREQ = note2freq(notes{1}.note)*9/8;
                        case 3
                            FREQ = note2freq(notes{1}.note)*3/2;
                    end
                case "Minor"
                    switch noter
                        case 2
                            FREQ = note2freq(notes{1}.note)*6/5;
                        case 3
                            FREQ = note2freq(notes{1}.note)*3/2;
                    end
            end
        else
            FREQ = note2freq(noteStruct.note);
        end
        AMP = 10;

        soundVector = zeros(length(notes),DUR);

        F1 = [linspace(1, 0, (constants.fs)*.04), zeros(1, constants.fs*(.2-.04))];
        % Approximation of F2
        F2 = AMP*[linspace(0, 1, (constants.fs)*.02), linspace(1, .5, constants.fs*.05), linspace(.5, 0, constants.fs*.13)];

        osc1 = oscillator('sine', F2, FREQ, 0, DUR, constants);
        osc2 = oscillator('sine', F1, FREQ*.7071, 0, DUR, constants);

        shapeWave = @(x) 1 +.841*x -.707*x.^2 -.595*x.^3 +.5*x.^4 +.42*x.^5 ...
            -.354*x.^6 -.297*x.^7 +.25*x.^8 +.210*x.^9;

        soundVector(noter,:) = osc1.*(shapeWave(osc2));
    end
    
%% Else
else
    error("Improper instrument sound!");
end

%% Output
soundVector = sum(soundVector, 1);

end