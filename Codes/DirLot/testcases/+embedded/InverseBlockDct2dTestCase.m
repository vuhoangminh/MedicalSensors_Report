classdef InverseBlockDct2dTestCase < TestCase
    %INVERSEBLOCKDCT2DTESTCASE Test case for InverseBlockDct2d
    %
    % SVN identifier:
    % $Id: InverseBlockDct2dTestCase.m 349 2012-10-31 06:11:57Z harashin $
    %
    % Requirements: MATLAB R2008a, mlunit_2008a
    %
    % Copyright (c) 2008, Shogo MURAMATSU and Shintaro HARA
    %
    % All rights reserved.
    %
    % Contact address: Shogo MURAMATSU,
    %                Faculty of Engineering, Niigata University,
    %                8050 2-no-cho Ikarashi, Nishi-ku,
    %                Niigata, 950-2181, JAPAN
    %
    properties
        hibdct;
    end
    
    methods
        function this = tearDown(this)
            delete(this.hibdct);
        end
        
        function this = testInverseBlockDct(this)
            
            dec = 2;
            height = 16;
            width = 16;
            subCoefs  = rand(height,width);
            
            % Expected values
            E0 = double(LpPuFb2dFactory.createLpPuFb2d());
            fun = @(x) reshape(flipud(E0.'*x(:)),dec,dec);
            imgExpctd = myblkproc(subCoefs,[dec dec],fun);
            
            % Instantiation of target class
            this.hibdct = InverseBlockDct2d();
            
            % Actual values
            imgActual = step(this.hibdct,subCoefs);
              
            % Evaluation
            diff = norm(imgExpctd - imgActual)/numel(imgExpctd);
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
