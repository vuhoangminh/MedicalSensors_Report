classdef ForwardDirLotEmb < matlab.System %#codegen
    %FORWARDDIRLOTEMB Forward directional lapped orthogoal transform class corresponding to embedded system
    %
    % SVN identifier:
    % $Id: ForwardDirLotEmb.m 348 2012-10-31 06:10:34Z harashin $
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
        W0 = [1 0; 0 -1];
        U0 = [-sqrt(15) 1; -1 -sqrt(15)]/4;
        Ux1 = [-7 -sqrt(15); sqrt(15) -7]/8;
        Ux2 = [sqrt(15) 7; 7 -sqrt(15)]/8;
        Uy1 = [-7 sqrt(15); -sqrt(15) -7]/8;
        Uy2 = [1 0; 0 -1];
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
        function  obj = ForwardDirLotEmb(varargin)
            obj.hd = ForwardBlockDct2d();
            obj.hW0U0 = Rotation(...
                'matrixW',obj.W0,...
                'matrixU',obj.U0);
            obj.hUx1 = Rotation(...
                'matrixW',eye(2),...
                'matrixU',obj.Ux1,...
                'BorderProcess','termination',...
                'DirectionOfTermination','horizontal');
            obj.hUx2 = Rotation(...
                'matrixW',eye(2),...
                'matrixU',obj.Ux2);
            obj.hUy1 = Rotation(...
                'matrixW',eye(2),...
                'matrixU',obj.Uy1,...
                'BorderProcess','termination',...
                'DirectionOfTermination','vartical');
            obj.hUy2 = Rotation(...
                'matrixW',eye(2),...
                'matrixU',obj.Uy2);
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
             afterDct = step(obj.hd,src);
             afterW0U0 = step(obj.hW0U0,afterDct);
            afterBtf1 = step(obj.hb,afterW0U0);
            afterShift1 = step(obj.hlr,afterBtf1);
            afterBtf2 = (step(obj.hb,afterShift1))/2;
            afterUx1 = step(obj.hUx1,afterBtf2);            
            afterBtf3 = step(obj.hb,afterUx1);
            afterShift2 = step(obj.hul,afterBtf3);           
            afterBtf4 = (step(obj.hb,afterShift2))/2;            
            afterUx2 = step(obj.hUx2,afterBtf4);
            afterBtf5 = step(obj.hb,afterUx2);
            afterShift3 = step(obj.hld,afterBtf5);
            afterBtf6 = (step(obj.hb,afterShift3))/2;
            afterUy1 = step(obj.hUy1,afterBtf6);
            afterBtf7 = step(obj.hb,afterUy1);
            afterShift4 = step(obj.huu,afterBtf7);
            afterBtf8 = (step(obj.hb,afterShift4))/2;
            value = step(obj.hUy2,afterBtf8);
        end
    end 
end

