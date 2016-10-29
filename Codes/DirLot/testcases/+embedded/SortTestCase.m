classdef SortTestCase < TestCase
    %SORTTESTCASE Test case for Sort
    
    properties
        hs;
    end
    
    methods
        function this = tearDown(this)
            delete(this.hs);
        end
        
        function this = testSortBlock1(this)
        
            srcImg = [
                1 2 1 2;
                3 4 3 4;
                1 2 1 2;
                3 4 3 4];
            
            % Expected values

            coefExpctd = [
                1 1 2 2;
                1 1 2 2;
                3 3 4 4;
                3 3 4 4];
            
            % Instantiation
            this.hs = Sort();
            
            % Actual values
            coefActual = step(this.hs,srcImg);
            
            % Evaluation
            diff = norm(coefExpctd - coefActual)/numel(coefExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        
    
            function this = testSortBlock2(this)
        
            srcImg = [
                1 2 1 2 1 2 ;
                3 4 3 4 3 4 ;
                1 2 1 2 1 2 ;
                3 4 3 4 3 4 ;
                1 2 1 2 1 2 ;
                3 4 3 4 3 4 ];
            
            % Expected values

            coefExpctd = [
                1 1 1 2 2 2;
                1 1 1 2 2 2;
                1 1 1 2 2 2;
                3 3 3 4 4 4;
                3 3 3 4 4 4;
                3 3 3 4 4 4];
            
            % Instantiation
            this.hs = Sort();
            
            % Actual values
            coefActual = step(this.hs,srcImg);
            
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

