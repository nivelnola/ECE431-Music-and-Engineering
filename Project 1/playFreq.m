function playFreq(freq, duration, constants)
%playFreq plays a sine wave at the given frequency.

times = 0:1/constants.fs:duration;
soundOut = sin(2*pi*(freq * times));

player = audioplayer(soundOut,constants.fs);
playblocking(player);

end


