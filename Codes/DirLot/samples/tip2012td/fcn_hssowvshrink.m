function [y,elms,coefs,invtrx] = fcn_hssowvshrink(b,ord)
% DirLOT Denosing with Heuristic Shrinkage

if nargin < 2 || ord < 2
    isMinOrd = true;
else 
    isMinOrd = false;
end

%% Wavelet setting
nlevels = 4;

%% Generate dictionary
idx = 1;
%
fnamehead = sprintf('lppufb2dDec22Ord%d%dAlp',ord,ord);
fname{idx} = [fnamehead '0.0Dir1Vm2h.mat']; idx = idx+1;
fname{idx} = [fnamehead '0.0Dir2Vmd000.00h.mat']; idx = idx+1;  
fname{idx} = [fnamehead '1.7Dir2Vmd030.00h.mat']; idx = idx+1;     
fname{idx} = [fnamehead '1.7Dir1Vmd060.00h.mat']; idx = idx+1;     
fname{idx} = [fnamehead '0.0Dir1Vmd090.00h.mat']; idx = idx+1;    
fname{idx} = [fnamehead '-1.7Dir1Vmd120.00h.mat']; idx = idx+1;    
fname{idx} = [fnamehead '-1.7Dir2Vmd150.00h.mat']; %idx = idx+1;    
%
nTrx = length(fname);
fwdtrx = cell(nTrx,1);
invtrx = cell(nTrx,1);
nsgenlot = cell(nTrx,1);
%
%figure(4)
for idx = 1:nTrx
    load(['./filters/data128x128i0.25/ga/' fname{idx} ]);
    if isMinOrd
        phiset = pi/180.*(0:10:170);
        if idx == 1
            nsgenlot{idx} = fcn_eznsgenlotcvm2();
        else
            nsgenlot{idx} = fcn_ezdirlottvm(phiset(idx-1));
        end
    else
        nsgenlot{idx} = lppufb;
    end
    %{
    dispBasisImages(nsgenlot{idx});
    drawnow
    %}
    fwdtrx{idx} = ForwardDirLot(nsgenlot{idx},'circular');
    invtrx{idx} = InverseDirLot(nsgenlot{idx},'circular');
end

%% Main Process of Heuristic Shrinkage
x = cell(1,nTrx); % Transform coefficients
parfor itrx = 1:nTrx
    x{itrx} = zeros(1,numel(b));
end
parfor itrx = 1:nTrx
    % Back-Projection (Forward transform)
    [x{itrx},valueS] = wavedec2(fwdtrx{itrx},b,nlevels); % e_i,k = phi'_i*r_i,k
    % Shrinkage
    x{itrx} = fcn_bayesshrink(x{itrx},valueS); % x_i,k = S(e_i,k)
    % 
    u{itrx} = waverec2(invtrx{itrx},x{itrx},valueS); % phi_i*x_i,k
end
% Reconstruction
y = 0;
for itrx = 1:nTrx
    % Update
    y = y + u{itrx}/nTrx; % y_k = sum(phi_j*x_i,k)
end

%% Output
coefs = x;
elms = cell(nTrx,1);
for itrx=1:nTrx
    elms{itrx} = u{itrx};
end