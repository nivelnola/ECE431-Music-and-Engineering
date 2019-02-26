function envelope = envelopeGEN_ASD(RISE, AMP, DUR, DECAY)
%envelopeGEN_ASD creates an envelope following the ASD model of duration
%DUR, with rise and decay times as specified

if DUR < RISE + DECAY
    error("Duration not long enough!")
else
    envelope = AMP*ones(1,DUR);
    envelope(1:RISE) = linspace(0, AMP, RISE);
    envelope(DUR-(DECAY-1):end) = linspace(AMP, 0, DECAY);
end

end