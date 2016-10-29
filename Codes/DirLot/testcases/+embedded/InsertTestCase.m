classdef InsertTestCase < TestCase
    %INSERTTESTCASE Test case for Insert
    
    properties
        hi;
    end
    
    methods
        function this = tearDown(this)
            delete(this.hi);
        end
        
        function this = testInsert(this)
        
            srcImg1 = [
                5 5;
                5 5];
            
            srcImg2 = [
                1 2 1 2;
                3 4 3 4;
                1 2 1 2;
                3 4 3 4];
            


            
            % Expected values

            coefExpctd = [
                5 2 5 2;
                3 4 3 4;
                5 2 5 2;
                3 4 3 4];
            
            % Instantiation
            this.hi = Insert();
            
            % Actual values
            coefActual = step(this.hi,srcImg1,srcImg2);
            
            % Evaluation
            diff = norm(coefExpctd - coefActual)/numel(coefExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
%         function this = testPickUp2(this)
%             
%             srcImg = [
%                 1 2 1 2 1 2 ;
%                 3 4 3 4 3 4 ;
%                 1 2 1 2 1 2 ;
%                 3 4 3 4 3 4 ;
%                 1 2 1 2 1 2 ;
%                 3 4 3 4 3 4 ];
%             
%             % Expected values
%             
%             coefExpctd = [
%                 1 1 1;
%                 1 1 1;
%                 1 1 1];
%             
%             % Instantiation
%             this.hp = PickUp();
%             
%             % Actual values
%             coefActual = step(this.hp,srcImg);
%             
%             % Evaluation
%             diff = norm(coefExpctd - coefActual)/numel(coefExpctd);
%             this.assert(diff<1e-15,sprintf('%g',diff));
%             
%         end
%         
        
    end
    
end
% function value = myblkproc(varargin)
% if exist('blockproc','file') == 2
%     fun = @(x) varargin{end}(x.data);
%     varargin{end} = fun;
%     value = blockproc(varargin{:});
% else
%     value = blkproc(varargin{:});
% end
% end

