classdef InverseDirLotEmb < matlab.System %#codegen
    %INVERSEDIRLOTEMB Inverse directional lapped orthogoal transform class corresponding to embedded system
    %
    % SVN identifier:
    % $Id: InverseDirLotEmb.m 348 2012-10-31 06:10:34Z harashin $
    %
    % Requirements: MATLAB R2008a
    %
    % Copyright (c) 2012, Shogo MURAMATSU and Shintaro HARA 
    %
    % All rights reserved.
    %
    % Contact address: Shogo MURAMATSU,
    %                Faculty of Engineering, Niigata University,
    %                8050 2-no-cho Ikarashi, Nishi-ku,
    %                Niigata, 950-2181, JAPAN
    %
    %    
    
    properties (Nontunable)
        W0T = [1 0; 0 -1];
        U0T = [-sqrt(15) -1; 1 -sqrt(15)]/4;
        Ux1T = [-7 sqrt(15); -sqrt(15) -7]/8;
        Ux2T = [sqrt(15) 7; 7 -sqrt(15)]/8;
        Uy1T = [-7 -sqrt(15); sqrt(15) -7]/8;
        Uy2T = [1 0; 0 -1];
        hd;
        hW0U0;
        hUx1;
        hUx2;
        hUy1;
        hUy2;
        hb;
        huu;
        hud;
        hur;
        hul;
        hlu;
        hld;
        hlr;
        hll;
    end
    
    methods
        function  obj = InverseDirLotEmb(varargin)
            obj.hd = InverseBlockDct2d();
            obj.hW0U0 = Rotation(...
                'matrixW',obj.W0T,...
                'matrixU',obj.U0T);
            obj.hUx1 = Rotation(...
                'matrixW',eye(2),...
                'matrixU',obj.Ux1T,...
                'BorderProcess','termination',...
                'DirectionOfTermination','horizontal');
            obj.hUx2 = Rotation(...
                'matrixW',eye(2),...
                'matrixU',obj.Ux2T);
            obj.hUy1 = Rotation(...
                'matrixW',eye(2),...
                'matrixU',obj.Uy1T,...
                'BorderProcess','termination',...
                'DirectionOfTermination','vartical');
            obj.hUy2 = Rotation(...
                'matrixW',eye(2),...
                'matrixU',obj.Uy2T);
            obj.hb = ButterFly();
            obj.huu = CoefShift('DirectionOfShift','up','UpperOrLower','upper');
            obj.hud = CoefShift('DirectionOfShift','down','UpperOrLower','upper');
            obj.hur = CoefShift('DirectionOfShift','right','UpperOrLower','upper');
            obj.hul = CoefShift('DirectionOfShift','left','UpperOrLower','upper');
            obj.hlu = CoefShift('DirectionOfShift','up','UpperOrLower','lower');
            obj.hld = CoefShift('DirectionOfShift','down','UpperOrLower','lower');
            obj.hlr = CoefShift('DirectionOfShift','right','UpperOrLower','lower');
            obj.hll = CoefShift('DirectionOfShift','left','UpperOrLower','lower');
        end
    end
    
    methods (Access = protected)
        function value = stepImpl(obj,src)
            afterUy2 = step(obj.hUy2,src);
            afterBtf8 = (step(obj.hb,afterUy2))/2;
            afterShift4 = step(obj.hud,afterBtf8);
            afterBtf7 = step(obj.hb,afterShift4);
            afterUy1 = step(obj.hUy1,afterBtf7);
            afterBtf6 = (step(obj.hb,afterUy1))/2;
            afterShift3 = step(obj.hlu,afterBtf6);
            afterBtf5 = step(obj.hb,afterShift3);
            afterUx2 = step(obj.hUx2,afterBtf5);
            afterBtf4 = (step(obj.hb,afterUx2))/2;
            afterShift2 = step(obj.hur,afterBtf4);
            afterBtf3 = step(obj.hb,afterShift2);
            afterUx1 = step(obj.hUx1,afterBtf3);
            afterBtf2 = (step(obj.hb,afterUx1))/2;
            afterShift1 = step(obj.hll,afterBtf2);
            afterBtf1 = step(obj.hb,afterShift1);
            afterW0U0 = step(obj.hW0U0,afterBtf1);
            value = step(obj.hd,afterW0U0);           
        end
    end
end

