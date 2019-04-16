
function [output] = ringmod(constants,inSound,inputFreq,depth)
%RINGMOD applies ring modulator effect to inSound

lenSound = length(inSound);
fixedFreq = depth * sin(2 * pi * inputFreq * (0:1/constants.fs:(lenSound-1)/constants.fs)).';

output = [fixedFreq .* inSound];

end