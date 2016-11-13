% SCALOGRAM - Calculates phase and amplitude scalogram of 1D signal.
%
% Usage: 
% [amplitude, phase] = scalogram(signal, minwavelength, mult, nscales, sigmaOnf, threeD)
%
% Function to calculate the phase and amplitude scalograms of a 1D signal
% Analysis is done using quadrature pairs of log Gabor filters
%
% Arguments:
%        signal        - a 1D vector to be analyzed (for maximum speed 
%                        length should be a power of 2)
%        minwavelength - wavelength of smallest scale filter to use
%        mult          - scaling factor between successive filters
%        nscales       - No of filtering scales to use
%        sigmaOnf      - Shape factor of log Gabor filter controlling bandwidth
%                       .35 - bandwidth of approx 3 ocatves
%                       .55 - bandwidth of approx 2 ocatves
%                       .75 - bandwidth of approx 1 ocatve
%        threeD        - An optional argument (0 or 1) indicating whether
%                        to display additional 3D visualisations of the
%                        result (this can take a while to display).
%
% Output:
%         amplitude    - image of amplitude responses
%         phase        - image of phase responses
%
% Suggested values:
% [amplitude, phase] = scalogram(signal, 4, 1.05, 128, .55)
%

% Copyright (c) 1997-2014 Peter Kovesi
% Centre for Exploration Targeting
% The University of Western Australia
% 
% Permission is hereby granted, free of charge, to any person obtaining a copy
% of this software and associated documentation files (the "Software"), to deal
% in the Software without restriction, subject to the following conditions:
% 
% The above copyright notice and this permission notice shall be included in 
% all copies or substantial portions of the Software.
%
% The Software is provided "as is", without warranty of any kind.

% March     1997  - Original version
% September 2001  - Code tidied and plots improved.
% January   2013  - More Octave compatibility (Carnë Draug)
% February  2014  - Ensure input signal is double! This avoids problems with
%                   MATLAB's stupid convention of casting data types *down*
%                   to the lowest class when they are combined.

function [amplitude, phase, tickLocations, tickValues] = ...
        scalogram(signal, minwavelength, mult, nscales, sigmaOnf, threeD)

    Octave = exist('OCTAVE_VERSION', 'builtin') == 5; % Are we running under Octave
    
    assert(isvector(signal), 'Input vector must be 1D');
    signal = signal(:)';     % Ensure it is a row vector
    if ~isa(signal,'double'), signal = double(signal); end
    if ~exist('threeD', 'var'), threeD = 0; end 

    ndata = length(signal);
    
    % Trim off the last signal element if the array length is odd.  The basic
    % filter construction code assumes an even number of data elements.
    if mod(ndata,2), signal = signal(1:end-1); ndata = ndata-1; end
    
    signalfft = fft(signal);           % Take FFT of signal
    
    amplitude = zeros(nscales,ndata);  % Pre-allocate memory for speed
    phase     = zeros(nscales,ndata);
    logGabor  = zeros(1,ndata);
    EO        = zeros(1,ndata);
    
    radius =  [0:fix(ndata/2)]/fix(ndata/2)/2;  % Frequency values 0 - 0.5
    radius(1) = 1;                     % Fudge to stop log function complaining at origin.

    wavelength = minwavelength;

    for row = 1:nscales
        fo = 1.0/wavelength;            % Centre frequency of filter.
        
        % Construct filter
        logGabor(1:ndata/2+1) = exp((-(log(radius/fo)).^2) / (2 * log(sigmaOnf)^2));  
        logGabor(1) = 0;                % Set value at zero frequency to 0 (undo fudge).

        % Multiply filter and FFT of signal, then take inverse FFT.
        EO = ifft(signalfft .* logGabor);
        
        amplitude(row,:) = abs(EO);     % Record the amplitude of the result
        phase(row,:) = angle(EO);       % .. and the phase.
        
        wavelength = wavelength * mult; % Increment the filter wavelength.
    end 


    % Set up axis range for plotting the results.
    minsig = min(signal); maxsig = max(signal); r = maxsig-minsig;  
    rmin = minsig-r/10; rmax = maxsig+r/10;

    % Set up data for labelling the scale axis
    Nticks = 12;
    dtick = fix(nscales/Nticks);
    tickLocations = 1:dtick:nscales;
    tickValues = round(minwavelength*mult.^(tickLocations-1));

    % Amplitude only scalogram.
    figure(1), clf, colormap(gray)
    subplot(2,1,1), plot(signal), axis([0,ndata,rmin,rmax]), title('signal');
    h = subplot(2,1,2); imagesc(-amplitude), colormap(gray), title('amplitude scalogram');
    set(h,'YTick',tickLocations);
    if ~Octave
        set(h,'YTickLabel',tickValues);
    end
    
    ylabel('scale');

    % Phase only scalogram: phase encoded by hue, saturation uniform.
    figure(2), clf
    hsv(:,:,1) = (phase+pi)/(2*pi);               % hue varies with phase.
    hsv(:,:,2) = ones(size(amplitude));           % saturation fixed at 1
    hsv(:,:,3) = ones(size(amplitude));           % intensity is fixed at 1.

    subplot(2,1,1), plot(signal), axis([0,ndata,rmin,rmax]), title('signal');
    h = subplot(2,1,2); 
    image(hsv2rgb(hsv));
    title('phase scalogram');
    set(h,'YTick',tickLocations);
    if ~Octave
        set(h,'YTickLabel',tickValues);
    end
    
    ylabel('scale');
    
    % Phase and amplitude scalogram: phase encoded by hue, amplitude encoded by saturation.
    figure(3), clf
    amp = log1p(amplitude);
%    hsv(:,:,2) = amplitude/max(max(amplitude));   % saturation varies with
%    amplitude.

    hsv(:,:,2) = amp/max(amp(:));   % saturation varies with amplitude.
    subplot(2,1,1), plot(signal),  axis([0,ndata,rmin,rmax]), title('signal');
    h = subplot(2,1,2); 
    image(hsv2rgb(hsv));

    title('scalogram:   phase encoded by hue, amplitude encoded by saturation');
    set(h,'YTick',tickLocations);
    if ~Octave
        set(h,'YTickLabel',tickValues);
    end

    ylabel('scale');
    
    if threeD            % Generate 3D plots.
        h = figure(4); clf;
        surfl(amplitude, [30,60]), axis('ij'), view(30,70), box on
        axis([0,ndata,0,nscales,0,max(max(amplitude))]), shading interp, colormap(gray);
        title('amplitude surface'); 
        h = get(h,'CurrentAxes');
        set(h,'YTick',tickLocations);
        if ~Octave
            set(h,'YTickLabel',tickValues);
        end
        ylabel('scale');
        
        h = figure(5); clf;
        hsv(:,:,2) = ones(size(amplitude));           % saturation fixed at 1
        warp(amplitude, hsv2rgb(hsv)), axis('ij'), view(30,70), box on, grid on
        title('amplitude surface, phase encoded by hue');
        h = get(h,'CurrentAxes');
        set(h,'YTick',tickLocations);
        if ~Octave
            set(h,'YTickLabel',tickValues);
        end
        ylabel('scale');
    end
