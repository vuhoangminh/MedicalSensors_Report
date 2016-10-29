function [fwdtrx,invtrx,nTrx] = fcn_gendic(isMinOrd,isdisplay)
%sdir = './filters/data128x128ampk2l2/ga/';
sdir = './filters/data128x128ampk3l3/ga/';
idx = 1;
%
fname{idx} = 'lppufb2dDec22Ord44Alp0.0Dir1Vm2.mat'; idx = idx+1;
fname{idx} = 'lppufb2dDec22Ord44Alp0.0Dir2Vmd000.00.mat'; idx = idx+1;
fname{idx} = 'lppufb2dDec22Ord44Alp5.7Dir2Vmd010.00.mat'; idx = idx+1;
fname{idx} = 'lppufb2dDec22Ord44Alp2.7Dir2Vmd020.00.mat'; idx = idx+1;
%fname{idx} = 'lppufb2dDec22Ord44Alp2.4Dir2Vmd022.50.mat'; idx = idx+1;
fname{idx} = 'lppufb2dDec22Ord44Alp1.7Dir2Vmd030.00.mat'; idx = idx+1;
fname{idx} = 'lppufb2dDec22Ord44Alp1.2Dir2Vmd040.00.mat'; idx = idx+1;
%fname{idx} = 'lppufb2dDec22Ord44Alp1.0Dir2Vmd045.00.mat'; idx = idx+1;
fname{idx} = 'lppufb2dDec22Ord44Alp1.2Dir1Vmd050.00.mat'; idx = idx+1;
fname{idx} = 'lppufb2dDec22Ord44Alp1.7Dir1Vmd060.00.mat'; idx = idx+1;
%fname{idx} = 'lppufb2dDec22Ord44Alp2.4Dir1Vmd067.50.mat'; idx = idx+1;
fname{idx} = 'lppufb2dDec22Ord44Alp2.7Dir1Vmd070.00.mat'; idx = idx+1;
fname{idx} = 'lppufb2dDec22Ord44Alp5.7Dir1Vmd080.00.mat'; idx = idx+1;
fname{idx} = 'lppufb2dDec22Ord44Alp0.0Dir1Vmd090.00.mat'; idx = idx+1;
fname{idx} = 'lppufb2dDec22Ord44Alp-5.7Dir1Vmd100.00.mat'; idx = idx+1;
fname{idx} = 'lppufb2dDec22Ord44Alp-2.7Dir1Vmd110.00.mat'; idx = idx+1;
%fname{idx} = 'lppufb2dDec22Ord44Alp-2.4Dir1Vmd112.50.mat'; idx = idx+1;
fname{idx} = 'lppufb2dDec22Ord44Alp-1.7Dir1Vmd120.00.mat'; idx = idx+1;
fname{idx} = 'lppufb2dDec22Ord44Alp-1.2Dir1Vmd130.00.mat'; idx = idx+1;
%fname{idx} = 'lppufb2dDec22Ord44Alp-1.0Dir2Vmd135.00.mat'; idx = idx+1;
fname{idx} = 'lppufb2dDec22Ord44Alp-1.2Dir2Vmd140.00.mat'; idx = idx+1;
fname{idx} = 'lppufb2dDec22Ord44Alp-1.7Dir2Vmd150.00.mat'; %idx = idx+1;
%fname{idx} = 'lppufb2dDec22Ord44Alp-2.4ir2Vmd157.50.mat'; %idx = idx+1;
fname{idx} = 'lppufb2dDec22Ord44Alp-2.7Dir2Vmd160.00.mat'; idx = idx+1;
fname{idx} = 'lppufb2dDec22Ord44Alp-5.7Dir2Vmd170.00.mat'; %idx = idx+1;
%
nTrx = length(fname);
fwdtrx = cell(nTrx,1);
invtrx = cell(nTrx,1);
nsgenlot = cell(nTrx,1);
%
for idx = 1:nTrx
    load([ sdir fname{idx} ]);
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
    if isdisplay
        figure(1)
        dispBasisImages(nsgenlot{idx});
        drawnow
    end
    %fwdtrx{idx} = ForwardDirLot(nsgenlot{idx},'circular');
    %invtrx{idx} = InverseDirLot(nsgenlot{idx},'circular');
    fwdtrx{idx} = ForwardDirLot(nsgenlot{idx},'termination');
    invtrx{idx} = InverseDirLot(nsgenlot{idx},'termination');
end