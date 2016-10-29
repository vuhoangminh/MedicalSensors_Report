function [bitRates,qTable] = posBitAssign(...
    aveRate, elementSet, etaSet, gainSet)
%POSBITASSIGN Positive bit assignment
%
% >> aveRate = .2;
% >> elementSet = [32 4 2 1 1];
% >> etaSet = [1/16 1/16 1/8 1/4 1/2];
% >>
% >> bitRates = posBitAssign(aveRate,elementSet,etaSet)
% >>
% >> bitRates * etaSet(:)
%

% Number of subbands
nSubbands = length(elementSet);

if nargin == 4
    elementSet = elementSet.*gainSet;
end    

% Average bitrate
aveRateOrg = aveRate;

% Occupation ratios of subbands
etaSetOrg = etaSet;

% Index set of valid subbnads
sigSubbands = 1:nSubbands;

bitRates = ones(nSubbands,1)*aveRate;

while true

   % Denominator
   denom = prod(elementSet(sigSubbands).^etaSet(sigSubbands));

   if denom == 0
       break
   end
   
   % Initial bitrate
   bitRates(sigSubbands) = aveRate ...
       + 0.5*log2(elementSet(sigSubbands)/denom);

   % Search for inavailable subband indexes
   insigSubbands = find(bitRates < 0);

   if isempty(insigSubbands)

       break

   else

       % Update inavailable subbands
       bitRates(insigSubbands) = 0 * bitRates(insigSubbands);

       % Update available subbands
       sigSubbands = setdiff(sigSubbands, insigSubbands);

       % Update average bitrate
       zeta = sum(etaSetOrg(sigSubbands));
       aveRate = aveRateOrg / zeta;

       % Update subband occupation
       denom = sum(etaSet(sigSubbands));
       etaSet(sigSubbands) = etaSet(sigSubbands)/denom;

   end

end

ebsqrd =1;
cb = 1/12;
qTable = zeros(nSubbands,1);
for iSubband = 1:nSubbands
   qTable(iSubband) = sqrt(ebsqrd*elementSet(iSubband)/cb)...
          *2^(-bitRates(iSubband));
end
