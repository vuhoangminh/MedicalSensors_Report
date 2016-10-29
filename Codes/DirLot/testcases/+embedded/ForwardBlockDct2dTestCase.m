classdef ForwardBlockDct2dTestCase < TestCase
    %FORWARDBLOCKDCT2DTESTCASE Test case for ForwardBlockDct2d
    %
    % SVN identifier:
    % $Id: ForwardBlockDct2dTestCase.m 349 2012-10-31 06:11:57Z harashin $
    %
    % Requirements: MATLAB R2008a, mlunit_2008a
    %
    % Copyright (c) 2008, Shogo MURAMATSU
    %
    % All rights reserved.
    %
    % Contact address: Shogo MURAMATSU,
    %                Faculty of Engineering, Niigata University,
    %                8050 2-no-cho Ikarashi, Nishi-ku,
    %                Niigata, 950-2181, JAPAN
    %
    properties
        hbdct;
    end
    
    methods
        function this = tearDown(this)
            delete(this.hbdct);
        end
        
 function this = testForwardBlockDct(this)
            
            dec = 2;
            height = 16;
            width = 16;
            srcImg = rand(height,width);
            
            % Expected values
            lppufb = LpPuFb2dFactory.createLpPuFb2d();
            E0 = double(lppufb);
            fun = @(x) reshape(E0*flipud(x(:)),dec,dec);
            coefExpctd = myblkproc(srcImg,[dec dec],fun);
            
            % Instantiation of target class
            this.hbdct = ForwardBlockDct2d();
            
            % Actual values
            coefActual = step(this.hbdct,srcImg);
            
            % Evaluation
            diff = norm(coefExpctd - coefActual)/numel(coefExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
    end
end

function value = myblkproc(varargin)
if exist('blockproc','file') == 2
    fun = @(x) varargin{end}(x.data);
    varargin{end} = fun;
    value = blockproc(varargin{:});
else
    value = blkproc(varargin{:});
end
end
