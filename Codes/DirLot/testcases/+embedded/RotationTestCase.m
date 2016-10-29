classdef RotationTestCase < TestCase
    %ROTATIONTESTCASE Test case for Rotation
    
    properties
        hr;
    end
    
    methods
        function this = tearDown(this)
            delete(this.hr);
        end
        
        function this = testRotationW0U0(this)
        
            dec = 2;
            height = 16;
            width = 16;
            srcImg = rand(height,width);
            
            % Expected values
            W0 = [1 0; 0 -1];
            U0 = [-sqrt(15) 1; -1 -sqrt(15)]/4;
            R0 = blkdiag(W0,U0);
            fun = @(x) reshape(R0*x(:),dec,dec);
            coefExpctd = myblkproc(srcImg,[dec dec],fun);
            
            % Instantiation
            this.hr = Rotation(...
                'matrixW',W0,...
                'matrixU',U0);
            
            % Actual values
            coefActual = step(this.hr,srcImg);
            
            % Evaluation
            diff = norm(coefExpctd - coefActual)/numel(coefExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        function this = testCircular(this)
        
            dec = 2;
            height = 16;
            width = 16;
            srcImg = rand(height,width);
            
            % Expected values
            W0 = [1 0; 0 -1];
            U0 = [-sqrt(15) 1; -1 -sqrt(15)]/4;
            R0 = blkdiag(W0,U0);
            fun = @(x) reshape(R0*x(:),dec,dec);
            coefExpctd = myblkproc(srcImg,[dec dec],fun);
            
            % Instantiation
            this.hr = Rotation(...
                'matrixW',W0,...
                'matrixU',U0,...
                'BorderProcess','circular');
            
            % Actual values
            coefActual = step(this.hr,srcImg);
            
            % Evaluation
            diff = norm(coefExpctd - coefActual)/numel(coefExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        function this = testVerticalTermination(this)
            
%             dec = 2;
            height = 16;
            width = 16;
            srcImg = ones(height,width);
            
            % Expected values           
            coefExpctd = [
                1 -1  1 -1  1 -1  1 -1  1 -1  1 -1  1 -1  1 -1;
                1 -1  1 -1  1 -1  1 -1  1 -1  1 -1  1 -1  1 -1;
                1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1;
                1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1;
                1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1;
                1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1;
                1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1;
                1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1;
                1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1;
                1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1;
                1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1;
                1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1;
                1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1;
                1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1;
                1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1;
                1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1;
                ];
            
            % Instantiation
            W0 = eye(2);
            U0 = eye(2);
            this.hr = Rotation(...
                'matrixW',W0,...
                'matrixU',U0,...
                'BorderProcess','termination',...
                'DirectionOfTermination','vertical');
            
            % Actual values
            coefActual = step(this.hr,srcImg);
            
            % Evaluation
            diff = norm(coefExpctd - coefActual)/numel(coefExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        function this = testHorizontalTermination(this)
            
%             dec = 2;
            height = 16;
            width = 16;
            srcImg = ones(height,width);
            
            % Expected values           
            coefExpctd = [
                1 -1  1  1  1  1  1  1  1  1  1  1  1  1  1  1;
                1 -1  1  1  1  1  1  1  1  1  1  1  1  1  1  1;
                1 -1  1  1  1  1  1  1  1  1  1  1  1  1  1  1;
                1 -1  1  1  1  1  1  1  1  1  1  1  1  1  1  1;
                1 -1  1  1  1  1  1  1  1  1  1  1  1  1  1  1;
                1 -1  1  1  1  1  1  1  1  1  1  1  1  1  1  1;
                1 -1  1  1  1  1  1  1  1  1  1  1  1  1  1  1;
                1 -1  1  1  1  1  1  1  1  1  1  1  1  1  1  1;
                1 -1  1  1  1  1  1  1  1  1  1  1  1  1  1  1;
                1 -1  1  1  1  1  1  1  1  1  1  1  1  1  1  1;
                1 -1  1  1  1  1  1  1  1  1  1  1  1  1  1  1;
                1 -1  1  1  1  1  1  1  1  1  1  1  1  1  1  1;
                1 -1  1  1  1  1  1  1  1  1  1  1  1  1  1  1;
                1 -1  1  1  1  1  1  1  1  1  1  1  1  1  1  1;
                1 -1  1  1  1  1  1  1  1  1  1  1  1  1  1  1;
                1 -1  1  1  1  1  1  1  1  1  1  1  1  1  1  1;
                ];
            
            % Instantiation
            W0 = eye(2);
            U0 = eye(2);
            this.hr = Rotation(...
                'matrixW',W0,...
                'matrixU',U0,...
                'BorderProcess','termination',...
                'DirectionOfTermination','horizontal');
            
            % Actual values
            coefActual = step(this.hr,srcImg);
            
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

