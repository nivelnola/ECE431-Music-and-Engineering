%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ECE-413: Music & Engineering
% Script to Generate Wave Table of Common Waveforms
% Alon S. Levin
%
% This script generates a wave table for four common waveforms: sine,
% square, sawtooth, and triangle. Each waveform is represented throughout
% one period, with each column of the resulting matrix representing a
% specific wave:
%   (1) Sine
%   (2) Square  
%   (3) Sawtooth
%   (4) Triangle
% To access this data, please refer to the corresponding function.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Number of samples to be taken per period
numBins = 2^10;

% Samples (0 --> 2*pi-bin)
slots = (0:2*pi/numBins:(2*pi*(numBins-1)/numBins))';

% Generating the wave table
waveforms = [sin(slots), square(slots), sawtooth(slots), sawtooth(slots,0.5)];

% Writing to CSV file
csvwrite('Waveforms.csv', waveforms);

% Clearing all used variables
clear numBins slots waveforms