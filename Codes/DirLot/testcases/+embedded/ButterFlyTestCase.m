classdef ButterFlyTestCase < TestCase
    %BUTTERFLYTESTCASE Test case for ButterFly
    
    properties
        btf;
    end
    
    methods
        function this = tearDown(this)
            delete(this.btf);
        end
        function this = testButterFly(this)
            
            dec = 2;
            height = 16;
            width = 16;
            srcImg = rand(height,width);
            
            % Expected values
            E0 = [
                1 0 1 0;
                0 1 0 1;
                1 0 -1 0;
                0 1 0 -1
                ];
            fun = @(x) reshape(E0*x(:),dec,dec);
            coefExpctd = myblkproc(srcImg,[dec dec],fun);
            
            % Instantiation of target class
            this.btf = ButterFly();
            
            % Actual values
            coefActual = step(this.btf,srcImg);
            
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
