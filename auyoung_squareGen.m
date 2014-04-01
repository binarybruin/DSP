 % Name: Michelle Auyoung

% Student ID: N10642420

% NetID: ma3345

 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% function generates, plots, and records a square wave using additive synthesis

% 

% USAGE: [ squareWave, sqWaveSound ] = auyoung_squareGen(dur, freq, otCnt, srate);

%

% INPUT: 
    % dur is the duration of the output signal in seconds
    % freq is the fundamental frequency of the signal in Hertz (pos or neg)
    % otCnt is the overtone count (multiply with fundamental frequency)
    % srate is the sampling rate (samples/second)

%

% OUTPUT: 
    % squareWave is the vector containing the output square wave signal
    % sqWaveSound is the sound of the square wave in a .wav file

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ squareWave, sqWaveSound ] = auyoung_squareGen( dur, freq, otCnt, srate )

% check arguments
if (dur <= 0)
    error('auyoung_squareGen:argChk', 'please enter duration greater than 0');
end

if (freq <= 0)
    error('auyoung_squareGen:argChk', 'please enter frequency greater than 0');
end

if (otCnt <= 0)
    error('auyoung_squareGen:argChk', 'please enter overtone count greater than 0');
end

if (srate <= 0)
    error('auyoung_squareGen:argChk', 'please enter sampling rate greater than 0');
end

if (freq > 0.5*srate)
    error('auyoung_squareGen:argChk', 'Warning: aliasing will occur with too low of a sample rate');
end

% calculate the number of samples
N = floor(dur*srate);
% generate time vector for each sample
timeVector = (0:N-1)/srate;

%fprintf('timeVector size: %d', size(timeVector));

% initialize square wave vector
squareWave = [];

% initialize k and 0 sine wave for additive synthesis
k = 1;
sine = 0;

% calculate square wave by summing sine waves up to overtone count
% (when k = 2*otCnt + 1)
while (k <= 2*otCnt+1)
    % use formula, add sine wave
    sine = sine + (1/k)*sin(k*2*pi*freq*timeVector);
    % increment to next odd number
    k = k + 2;  
    % only continue if k*freq is less than or eqal to Nyquist frequency
    % otherwise breeak out of loop
    if (k*freq > 0.5*srate)
        break;
    end
end

% assign result of adding sine waves to squareWave vector
squareWave = -sine;


%fprintf('squareWave vector size: %d', size(squareWave));

% plot graph
close all; % closes all currently open plot windows
plot(timeVector, squareWave);
title('Square Wave');
xlabel('Time');
ylabel('Amplitude');
xlim([0,timeVector(300)]);

% record wave file
wavwrite(squareWave, srate, 'sqWaveSound.wav');

sqWaveSound = 'sqWaveSound.wav';


end

