function y = fcn_genlotshrink(x,ord)
%
% Requirements: Image Processing Tbx
%

if nargin == 0
    x = rand(32);
    ord = 2;
end

%% Wavelet setting
dec = 4;
fname = sprintf('./filters/data128i0.25/ga/lppufb1dDec%dOrd%dVm2.mat',...
    dec,ord);
load(fname)
fwdtrx = ForwardGenLot2d(lppufb,'symmetric');
invtrx = InverseGenLot2d(lppufb,'symmetric');

%% Forward Transform
% Level 1
fwdtrx = forwardTransform(fwdtrx,x,'natural');
coefs1 = getSubbandCoefs(fwdtrx);
% Level 2
fwdtrx = forwardTransform(fwdtrx,coefs1{1},'natural');
coefs2 = getSubbandCoefs(fwdtrx);

%% Shrinkage
coefs1{1,1} = [];
valueC{1} = coefs2; 
valueC{2} = coefs1; 
valueNC = bayesshrinkgenlot(valueC);

coefs2 = valueNC{1};
coefs1 = valueNC{2};

%% Inverse Transform
% Level 2
invtrx = inverseTransform(invtrx,coefs2,'natural');
coefs1{1,1} = getImage(invtrx);
% Level 1
invtrx = inverseTransform(invtrx,coefs1,'natural');
y = getImage(invtrx);

%%

function valueNC = bayesshrinkgenlot(valueC)
% BayesShrink for GenLOT
valueNC = valueC;

% Estimation of standard deviation
hh = valueC{end}{end,end}; %finest wavelet coefs
esigma = median(abs(hh(:)))/.6745;
ve = esigma^2;

% Subband dependent thresholding
%valueT = cell(size(valueC));
for iLevel = 1:2
    for iRow = 1:4
        for iCol = 1:4
            if iRow == 1 && iCol == 1
                valueNC{iLevel}{1,1} = valueC{iLevel}{1,1};
            else
                c = valueC{iLevel}{iRow,iCol};
                vy = var(c(:));
                sigmax = sqrt(max(vy-ve,0));
                T = min(ve/sigmax,max(abs(c(:))));
                nc = (abs(c(:))-T);
                nc(nc<0) = 0;
                newcoef =  sign(c).*reshape(nc,size(c));
                valueNC{iLevel}{iRow,iCol} = newcoef;
                %valueT{iLevel}{iRow,iCol} = T;
            end
        end
    end
end