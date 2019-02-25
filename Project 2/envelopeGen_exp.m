function envelope = envelopeGen_exp(AMP, DUR, LIM, constants)
%envelopeGen_exp generates an exponentially decreasing envelope for the
%duration given, starting at (0,AMP) to (DUR, AMP*LIM).

times = (0:1:(DUR-1));

envelope = AMP*exp(log(LIM)/DUR * times);

end

