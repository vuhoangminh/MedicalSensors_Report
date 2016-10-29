classdef CoefShiftTestCase < TestCase
    %COEFSHIFTTESTCASE Test case for CoefShift
    
    properties
        hs;
    end
    
    methods
        function this = tearDown(this)
            delete(this.hs);
        end
        function this = testUpperUpShift(this)
            
%             dec = 2;
%             height = 8;
%             width = 8;
            srcImg = [
                1 1 1 1 1 1 1 1;
                2 2 2 2 2 2 2 2;
                3 3 3 3 3 3 3 3;
                4 4 4 4 4 4 4 4;
                5 5 5 5 5 5 5 5;
                6 6 6 6 6 6 6 6;
                7 7 7 7 7 7 7 7;
                8 8 8 8 8 8 8 8;
                ];
            
            % Expected values
            coefExpctd = [
                3 1 3 1 3 1 3 1;
                4 2 4 2 4 2 4 2;
                5 3 5 3 5 3 5 3;
                6 4 6 4 6 4 6 4;
                7 5 7 5 7 5 7 5;
                8 6 8 6 8 6 8 6;
                1 7 1 7 1 7 1 7;
                2 8 2 8 2 8 2 8;
                ];
                
            
            % Instantiation
            this.hs = CoefShift(...
                'DirectionOfShift','up',...
                'UpperOrLower','upper');
            
            % Actual values
            coefActual = step(this.hs,srcImg);
            
            % Evaluation
            diff = norm(coefExpctd - coefActual)/numel(coefExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        function this = testUpperDownShift(this)
            
%             dec = 2;
%             height = 8;
%             width = 8;
            srcImg = [
                1 1 1 1 1 1 1 1;
                2 2 2 2 2 2 2 2;
                3 3 3 3 3 3 3 3;
                4 4 4 4 4 4 4 4;
                5 5 5 5 5 5 5 5;
                6 6 6 6 6 6 6 6;
                7 7 7 7 7 7 7 7;
                8 8 8 8 8 8 8 8;
                ];
            
            % Expected values
            coefExpctd = [
                7 1 7 1 7 1 7 1;
                8 2 8 2 8 2 8 2;
                1 3 1 3 1 3 1 3;
                2 4 2 4 2 4 2 4;
                3 5 3 5 3 5 3 5;
                4 6 4 6 4 6 4 6;
                5 7 5 7 5 7 5 7;
                6 8 6 8 6 8 6 8;
                ];
                
            
            % Instantiation
            this.hs = CoefShift(...
                'DirectionOfShift','down',...
                'UpperOrLower','upper');
            
            % Actual values
            coefActual = step(this.hs,srcImg);
            
            % Evaluation
            diff = norm(coefExpctd - coefActual)/numel(coefExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        function this = testLowerUpShift(this)
            
%             dec = 2;
%             height = 8;
%             width = 8;
            srcImg = [
                1 1 1 1 1 1 1 1;
                2 2 2 2 2 2 2 2;
                3 3 3 3 3 3 3 3;
                4 4 4 4 4 4 4 4;
                5 5 5 5 5 5 5 5;
                6 6 6 6 6 6 6 6;
                7 7 7 7 7 7 7 7;
                8 8 8 8 8 8 8 8;
                ];
            
            % Expected values
            coefExpctd = [
                1 3 1 3 1 3 1 3;
                2 4 2 4 2 4 2 4;
                3 5 3 5 3 5 3 5;
                4 6 4 6 4 6 4 6;
                5 7 5 7 5 7 5 7;
                6 8 6 8 6 8 6 8;
                7 1 7 1 7 1 7 1;
                8 2 8 2 8 2 8 2;
                ];
                
            
            % Instantiation
            this.hs = CoefShift(...
                'DirectionOfShift','up',...
                'UpperOrLower','lower');
            
            % Actual values
            coefActual = step(this.hs,srcImg);
            
            % Evaluation
            diff = norm(coefExpctd - coefActual)/numel(coefExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        function this = testLowerDownShift(this)
            
%             dec = 2;
%             height = 8;
%             width = 8;
            srcImg = [
                1 1 1 1 1 1 1 1;
                2 2 2 2 2 2 2 2;
                3 3 3 3 3 3 3 3;
                4 4 4 4 4 4 4 4;
                5 5 5 5 5 5 5 5;
                6 6 6 6 6 6 6 6;
                7 7 7 7 7 7 7 7;
                8 8 8 8 8 8 8 8;
                ];
            
            % Expected values
            coefExpctd = [
                1 7 1 7 1 7 1 7;
                2 8 2 8 2 8 2 8;
                3 1 3 1 3 1 3 1;
                4 2 4 2 4 2 4 2;
                5 3 5 3 5 3 5 3;
                6 4 6 4 6 4 6 4;
                7 5 7 5 7 5 7 5;
                8 6 8 6 8 6 8 6;
                ];
                
            
            % Instantiation
            this.hs = CoefShift(...
                'DirectionOfShift','down',...
                'UpperOrLower','lower');
            
            % Actual values
            coefActual = step(this.hs,srcImg);
            
            % Evaluation
            diff = norm(coefExpctd - coefActual)/numel(coefExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        function this = testUpperRightShift(this)
            
%             dec = 2;
%             height = 8;
%             width = 8;
            srcImg = [
                1 2 3 4 5 6 7 8;
                1 2 3 4 5 6 7 8;
                1 2 3 4 5 6 7 8;
                1 2 3 4 5 6 7 8;
                1 2 3 4 5 6 7 8;
                1 2 3 4 5 6 7 8;
                1 2 3 4 5 6 7 8;
                1 2 3 4 5 6 7 8;
                ];
            
            % Expected values
            coefExpctd = [
                7 2 1 4 3 6 5 8;
                7 2 1 4 3 6 5 8;
                7 2 1 4 3 6 5 8;
                7 2 1 4 3 6 5 8;
                7 2 1 4 3 6 5 8;
                7 2 1 4 3 6 5 8;
                7 2 1 4 3 6 5 8;
                7 2 1 4 3 6 5 8;

                ];
                
            
            % Instantiation
            this.hs = CoefShift(...
                'DirectionOfShift','right',...
                'UpperOrLower','upper');
            
            % Actual values
            coefActual = step(this.hs,srcImg);
            
            % Evaluation
            diff = norm(coefExpctd - coefActual)/numel(coefExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        function this = testUpperLeftShift(this)
            
%             dec = 2;
%             height = 8;
%             width = 8;
            srcImg = [
                1 2 3 4 5 6 7 8;
                1 2 3 4 5 6 7 8;
                1 2 3 4 5 6 7 8;
                1 2 3 4 5 6 7 8;
                1 2 3 4 5 6 7 8;
                1 2 3 4 5 6 7 8;
                1 2 3 4 5 6 7 8;
                1 2 3 4 5 6 7 8;
                ];
            
            % Expected values
            coefExpctd = [
                3 2 5 4 7 6 1 8;
                3 2 5 4 7 6 1 8;
                3 2 5 4 7 6 1 8;
                3 2 5 4 7 6 1 8;
                3 2 5 4 7 6 1 8;
                3 2 5 4 7 6 1 8;
                3 2 5 4 7 6 1 8;
                3 2 5 4 7 6 1 8;

                ];
                
            
            % Instantiation
            this.hs = CoefShift(...
                'DirectionOfShift','left',...
                'UpperOrLower','upper');
            
            % Actual values
            coefActual = step(this.hs,srcImg);
            
            % Evaluation
            diff = norm(coefExpctd - coefActual)/numel(coefExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        function this = testLowerRightShift(this)
            
%             dec = 2;
%             height = 8;
%             width = 8;
            srcImg = [
                1 2 3 4 5 6 7 8;
                1 2 3 4 5 6 7 8;
                1 2 3 4 5 6 7 8;
                1 2 3 4 5 6 7 8;
                1 2 3 4 5 6 7 8;
                1 2 3 4 5 6 7 8;
                1 2 3 4 5 6 7 8;
                1 2 3 4 5 6 7 8;
                ];
            
            % Expected values
            coefExpctd = [
                1 8 3 2 5 4 7 6;
                1 8 3 2 5 4 7 6;
                1 8 3 2 5 4 7 6;
                1 8 3 2 5 4 7 6;
                1 8 3 2 5 4 7 6;
                1 8 3 2 5 4 7 6;
                1 8 3 2 5 4 7 6;
                1 8 3 2 5 4 7 6;
                ];
                
            
            % Instantiation
            this.hs = CoefShift(...
                'DirectionOfShift','right',...
                'UpperOrLower','lower');
            
            % Actual values
            coefActual = step(this.hs,srcImg);
            
            % Evaluation
            diff = norm(coefExpctd - coefActual)/numel(coefExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        function this = testLowerLeftShift(this)
            
%             dec = 2;
%             height = 8;
%             width = 8;
            srcImg = [
                1 2 3 4 5 6 7 8;
                1 2 3 4 5 6 7 8;
                1 2 3 4 5 6 7 8;
                1 2 3 4 5 6 7 8;
                1 2 3 4 5 6 7 8;
                1 2 3 4 5 6 7 8;
                1 2 3 4 5 6 7 8;
                1 2 3 4 5 6 7 8;
                ];
            
            % Expected values
            coefExpctd = [
                1 4 3 6 5 8 7 2;
                1 4 3 6 5 8 7 2;
                1 4 3 6 5 8 7 2;
                1 4 3 6 5 8 7 2;
                1 4 3 6 5 8 7 2;
                1 4 3 6 5 8 7 2;
                1 4 3 6 5 8 7 2;
                1 4 3 6 5 8 7 2;
                ];
                
            
            % Instantiation
            this.hs = CoefShift(...
                'DirectionOfShift','left',...
                'UpperOrLower','lower');
            
            % Actual values
            coefActual = step(this.hs,srcImg);
            
            % Evaluation
            diff = norm(coefExpctd - coefActual)/numel(coefExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
    end
    
end

