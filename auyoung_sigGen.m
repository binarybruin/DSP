% Name: Michelle Auyoung


 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% function generates, plots, and records audio file of a certain type of wave using additive synthesis

% 

% USAGE: [ signal, timeVector ] = auyoung_sigGen(srate, duration, fundFreq, otCnt, type, filename);

%

% INPUT: 
    % srate: the sampling rate (samples per second)
    % duration: the duration of the output signal in seconds
    % fundFreq: the fundamental frequency of the signal in Hertz
    % otCnt: the overtone count (for bandlimited signals of type square, triangle, saw)
    % type: the output signal waveform shape (specified as a string)
        % 'sine' = for sine waves
        % 'cosine' = for cosine waves
        % 'sq' = for square (bandlimited waves)
        % 'tri' = for triangle (bandlimited waves)
        % 'saw' = for sawtooth (bandlimited waves)
        % 'noise' = for white noise (zero-mean)
    % filename: name of .WAV file where generated signal will be saved and
    % output (function will not save audio if this input is not provided)

%

% OUTPUT: 
    % signal: vector containing the given signal desired by the user
    % timeVector: time vector corresponding to the given signal

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ signal, timeVector ] = auyoung_sigGen( srate, duration, fundFreq, otCnt, type, filename )

% check args %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% inputs should include at least the first five arguments
if (nargin < 5)
    error('auyoung_sigGen:argChk', 'please enter at least the srate, duration, fundFreq, otCnt, and type');
end

% check if type is correct
if (~(strcmp(type, 'sine') || strcmp(type, 'cosine') || strcmp(type, 'sq') || strcmp(type, 'tri') || strcmp(type, 'saw') || strcmp(type, 'noise')))
    error('auyoung_sigGen:argChk', 'please enter a signal type: sine, cosine, sq, tri, saw, or noise');
end

% check for valid values
if (duration <= 0)
    error('auyoung_sigGen:argChk', 'please enter duration greater than 0');
end

if (otCnt < 0 && (strcmp(type, 'sq') || strcmp(type, 'tri') || strcmp(type, 'saw')))
    error('auyoung_sigGen:argChk', 'please enter overtone count greater than or equal to 0');
end

if (srate <= 0)
    error('auyoung_sigGen:argChk', 'please enter sampling rate greater than 0');
end

% check that fundFreq does not exceed Nyquist
if (fundFreq > srate/2)
    error('auyoung_sigGen:argChk', 'please enter a srate that is at least twice that of the fundFreq');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% initialize output signal vector
signal = [];

% check if filename is given input, check if it is valid string and set flag for writing file
write_flag = false;
if (nargin == 6)
    if (ischar(filename))
        write_flag = true;
    else
        error('auyoung_sigGen:argChk', 'please enter valid string for filename');
    end
end

% calculate the number of samples
N = floor(duration*srate);
% generate time vector for each sample
timeVector = (0:N-1)/srate;

% if type is 'noise', generate signal, record file, and return
if (strcmp(type, 'noise'))
    signal = rand(N, 1);
    % normalize signal
    signal = normalize_signal(signal);
    
    % save audio file
    if (write_flag)
        wavwrite(signal, srate, filename);
    end
    return;
end

% if type is 'sine' or 'cosine', generate signal, record file, and return
if (strcmp(type, 'sine') || strcmp(type, 'cosine'))
    switch type
        case 'sine'
            signal = sin(2*pi*fundFreq*timeVector);
        case 'cosine'
            signal = cos(2*pi*fundFreq*timeVector);
    end
    % normalize signal
    signal = normalize_signal(signal);
    
    % save audio file
    if (write_flag)
        wavwrite(signal, srate, filename);
    end
    return;
end

% calculate output signal based on type
switch type
    case 'sq'
        k = 1;
        wave = 0;
        while (k <= 2*otCnt+1)
            % use formula, add sine wave
            wave = wave + (1/k)*sin(k*2*pi*fundFreq*timeVector);
            % increment to next odd number
            k = k + 2;  
            % only continue if k*freq is less than or eqal to Nyquist frequency
            % otherwise breeak out of loop
            if (k*fundFreq > 0.5*srate)
                break;
            end
        end
        signal = wave;
        
    case 'tri'
        k = 1;
        wave = 0;
        while (k <= 2*otCnt+1)
            % use formula, add sine wave
            wave = wave + (-1)^((k-1)/2)*(1/(k^2))*sin(k*2*pi*fundFreq*timeVector);
            % increment to next odd number
            k = k + 2;  
            % only continue if k*freq is less than or eqal to Nyquist frequency
            % otherwise breeak out of loop
            if (k*fundFreq > 0.5*srate)
                break;
            end
        end
        signal = wave;
        
    case 'saw'
        k = 1;
        wave = 0;
        while (k <= 2*otCnt+1)
            % use formula, add sine wave
            wave = wave + (1/k)*sin(k*2*pi*fundFreq*timeVector);
            % increment to next number
            k = k + 1;  
            % only continue if k*freq is less than or eqal to Nyquist frequency
            % otherwise breeak out of loop
            if (k*fundFreq > 0.5*srate)
                break;
            end
        end
        signal = -wave;
end

% normalize signal
signal = normalize_signal(signal);

% save audio file
if (write_flag)
    wavwrite(signal, srate, filename);
end

end


% HELPER FUNCTION - Normalize signal vector
function [ normalized ] = normalize_signal( in_signal )

normalized = in_signal*2 - 1;
normalized = normalized/max(abs(normalized));
normalized = 0.5*normalized;

end
