classdef InverseDirLotEmbTestCase < TestCase
    %INVERSEDIRLOTEMBTESTCASE Test case for InverseDirLotEmb
    
    properties
        hi
    end
    
    methods
        function this = tearDown(this)
            delete(this.hi);
        end
        
        function this = testInverseDirLOTEmb(this)
            srcImg = [
                2 0 2 0;
                0 0 0 0;
                2 0 2 0;
                0 0 0 0
                ];
            
            
            % Expected values
            coefExpctd = ones(4);
            
            
            % Instantiation
            this.hi = InverseDirLotEmb();
            % Actual values
            coefActual = step(this.hi,srcImg);
            
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


