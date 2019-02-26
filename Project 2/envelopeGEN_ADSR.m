function envelope = envelopeGEN_ADSR(ATTACK, DECAY, RELEASE, AMP_ATTACK, AMP_SUSTAIN, DUR)
%envelopeGEN_ADSR creates an envelope following the ADSR model of duration
%DUR, with attack, decay, and release times as specified

if DUR < ATTACK + DECAY + RELEASE
    error("Duration not long enough!")
else
    attack = linspace(0, AMP_ATTACK, ceil(ATTACK+1));
    decay = linspace(AMP_ATTACK, AMP_SUSTAIN, ceil(DECAY+1));
    sustain = AMP_SUSTAIN.*ones(1, ceil(1+(DUR - (ATTACK + DECAY + RELEASE))));
    release = linspace(AMP_SUSTAIN, 0, ceil(RELEASE));

    envelope = [attack(1:end-1), decay(1:end-1), sustain(1:end-1), release];
end

end