classdef LpPuFb2dVm2TestCase < TestCase
    %LPPUFB2DVM2TESTCASE Test case for LpPuFb2dVm2
    %
    % SVN identifier:
    % $Id: LpPuFb2dVm2TestCase.m 249 2011-11-27 01:55:42Z sho $
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
        lppufb;
    end
    
    methods
       
        function this = tearDown(this)
            delete(this.lppufb)
        end
        
        % Test for default construction
        function this = testConstructor(this)
            
            % Expected values
            coefExpctd(:,:,1,1) = [
                0.006820182392245  -0.053695182392245   0.008804817607755   0.069320182392245
                0.026414452823264  -0.207960547176736   0.034100911961227   0.268475911961227
                -0.006820182392245   0.053695182392245  -0.008804817607755  -0.069320182392245
                -0.026414452823264   0.207960547176736  -0.034100911961227  -0.268475911961227
                ];
            
            coefExpctd(:,:,2,1) = [
                0.000000000000000                   0  -0.000000000000000                   0
                -0.000000000000000  -0.000000000000000                   0  -0.000000000000000
                -0.052828905646527   0.415921094353473  -0.068201823922454  -0.536951823922455
                0.013640364784491  -0.107390364784491   0.017609635215509   0.138640364784491
                ];
            
            coefExpctd(:,:,3,1) = [
                0.006820182392245  -0.053695182392245   0.008804817607755   0.069320182392245
                0.026414452823264  -0.207960547176736   0.034100911961227   0.268475911961227
                0.006820182392245  -0.053695182392245   0.008804817607755   0.069320182392245
                0.026414452823264  -0.207960547176736   0.034100911961227   0.268475911961227
                ];
            
            coefExpctd(:,:,1,2) = [
                -0.062500000000000   0.062500000000000  -0.062500000000000   0.062500000000000
                -0.242061459137964   0.242061459137964  -0.242061459137964   0.242061459137964
                0.062500000000000  -0.062500000000000   0.062500000000000  -0.062500000000000
                0.242061459137964  -0.242061459137964   0.242061459137964  -0.242061459137964
                ];
            
            coefExpctd(:,:,2,2) = [
                0.347719270431018   0.589780729568982   0.589780729568982   0.347719270431018
                -0.089780729568982  -0.152280729568982  -0.152280729568982  -0.089780729568982
                0                   0  -0.000000000000000   0.000000000000000
                -0.000000000000000                   0   0.000000000000000  -0.000000000000000
                ];
            
            coefExpctd(:,:,3,2) = [
                0.062500000000000  -0.062500000000000   0.062500000000000  -0.062500000000000
                0.242061459137964  -0.242061459137964   0.242061459137964  -0.242061459137964
                0.062500000000000  -0.062500000000000   0.062500000000000  -0.062500000000000
                0.242061459137964  -0.242061459137964   0.242061459137964  -0.242061459137964
                ];
            
            coefExpctd(:,:,1,3) = [
                0.069320182392245   0.008804817607755  -0.053695182392245   0.006820182392245
                0.268475911961227   0.034100911961227  -0.207960547176736   0.026414452823264
                -0.069320182392245  -0.008804817607755   0.053695182392245  -0.006820182392245
                -0.268475911961227  -0.034100911961227   0.207960547176736  -0.026414452823264
                ];
            
            coefExpctd(:,:,2,3) = [
                0.000000000000000                   0   0.000000000000000                   0
                -0.000000000000000  -0.000000000000000                   0                   0
                0.536951823922455   0.068201823922454  -0.415921094353473   0.052828905646527
                -0.138640364784491  -0.017609635215509   0.107390364784491  -0.013640364784491
                ];
            
            coefExpctd(:,:,3,3) = [
                0.069320182392245   0.008804817607755  -0.053695182392245   0.006820182392245
                0.268475911961227   0.034100911961227  -0.207960547176736   0.026414452823264
                0.069320182392245   0.008804817607755  -0.053695182392245   0.006820182392245
                0.268475911961227   0.034100911961227  -0.207960547176736   0.026414452823264
                ];
            
            % Instantiation of target class
            this.lppufb = LpPuFb2dVm2();
            
            % Actual values
            coefActual = double(this.lppufb);
            
            % Evaluation
            coefDist = norm(coefExpctd(:)-coefActual(:))/...
                sqrt(numel(coefActual));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            
        end
        
        % Test for default construction
        function this = testConstructorWithDeepCopy(this)
            
            % Instantiation of target class
            this.lppufb = LpPuFb2dVm2();
            cloneLpPuFb = LpPuFb2dVm2(this.lppufb);
            
            % Expected values
            coefExpctd = double(this.lppufb);
            
            % Actual values
            coefActual = double(cloneLpPuFb);
            
            % Evaluation
            coefDist = norm(coefExpctd(:)-coefActual(:))/...
                sqrt(numel(coefActual));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            
            % Change angles
            angles = randn(size(getAngles(cloneLpPuFb)));
            cloneLpPuFb = setAngles(cloneLpPuFb,angles);
            
            % Actual values
            coefActual = double(cloneLpPuFb);
            
            % Evaluation
            coefDist = norm(coefExpctd(:)-coefActual(:))/...
                sqrt(numel(coefActual));
            this.assert(coefDist>1e-15,sprintf('%g',coefDist));
            
        end
        
        % Test for construction
        function this = testConstructorWithOrd00(this)
            
            % Invalid input
            dec = [ 2 2 ];
            ord = [ 0 0 ];
            
            % Expected values
            exceptionIdExpctd = 'DirLOT:IllegalArgumentException';
            messageExpctd = ...
                sprintf('Order must be greater than or equal to [ 2 2 ]');
            
            % Instantiation of target class
            try
                LpPuFb2dVm2(dec,ord);
                this.fail(sprintf('%s must be thrown.',...
                    exceptionIdExpctd));
            catch me
                exceptionIdActual = me.identifier;
                this.assertEquals(exceptionIdExpctd, exceptionIdActual);
                messageActual = me.message;
                this.assertEquals(messageExpctd, messageActual);
            end
        end
        
        function this = testConstructorWithInvalidArguments(this)
            
            % Invalid input
            dec = [ 4 4 ];
            ord = [ 0 0 ];
            sizeInvalid = [2 2];
            ang = 2*pi*rand(sizeInvalid);
            
            % Expected value
            sizeExpctd = [28 2];
            
            % Expected values
            exceptionIdExpctd = 'DirLOT:IllegalArgumentException';
            messageExpctd = ...
                sprintf('Size of angles must be [ %d %d ]',...
                sizeExpctd(1), sizeExpctd(2));
            
            % Instantiation of target class
            try
                LpPuFb2dVm2(dec,ord,ang);
                this.fail(sprintf('%s must be thrown.',...
                    exceptionIdExpctd));
            catch me
                exceptionIdActual = me.identifier;
                this.assertEquals(exceptionIdExpctd, exceptionIdActual);
                messageActual = me.message;
                this.assertEquals(messageExpctd, messageActual);
            end
        end
        
        function this = testChar(this)
            
            % Expected value
            charExpctd = [...
                '[', 10, ...
                9, '0.0068202 - 0.053695*y^(-1) + 0.0068202*y^(-2) - 0.053695*y^(-3) - 0.053695*x^(-1) + 0.47954*y^(-1)*x^(-1) + 0.66109*y^(-2)*x^(-1) + 0.0068202*y^(-3)*x^(-1) + 0.0068202*x^(-2) + 0.66109*y^(-1)*x^(-2) + 0.47954*y^(-2)*x^(-2) - 0.053695*y^(-3)*x^(-2) - 0.053695*x^(-3) + 0.0068202*y^(-1)*x^(-3) - 0.053695*y^(-2)*x^(-3) + 0.0068202*y^(-3)*x^(-3);',10,...
                9, '0.026414 - 0.20796*y^(-1) + 0.026414*y^(-2) - 0.20796*y^(-3) - 0.20796*x^(-1) + 0.42076*y^(-1)*x^(-1) + 0.12388*y^(-2)*x^(-1) + 0.026414*y^(-3)*x^(-1) + 0.026414*x^(-2) + 0.12388*y^(-1)*x^(-2) + 0.42076*y^(-2)*x^(-2) - 0.20796*y^(-3)*x^(-2) - 0.20796*x^(-3) + 0.026414*y^(-1)*x^(-3) - 0.20796*y^(-2)*x^(-3) + 0.026414*y^(-3)*x^(-3);', 10, ...
                9, '-0.0068202 + 0.00086628*y^(-1) + 0.42274*y^(-2) - 0.053695*y^(-3) + 0.053695*x^(-1) - 0.20002*y^(-1)*x^(-1) - 0.46565*y^(-2)*x^(-1) + 0.0068202*y^(-3)*x^(-1) - 0.0068202*x^(-2) + 0.46565*y^(-1)*x^(-2) + 0.20002*y^(-2)*x^(-2) - 0.053695*y^(-3)*x^(-2) + 0.053695*x^(-3) - 0.42274*y^(-1)*x^(-3) - 0.00086628*y^(-2)*x^(-3) + 0.0068202*y^(-3)*x^(-3);',10,...
                9, '-0.026414 + 0.2216*y^(-1) - 0.080976*y^(-2) - 0.20796*y^(-3) + 0.20796*x^(-1) - 0.49293*y^(-1)*x^(-1) + 0.4148*y^(-2)*x^(-1) + 0.026414*y^(-3)*x^(-1) - 0.026414*x^(-2) - 0.4148*y^(-1)*x^(-2) + 0.49293*y^(-2)*x^(-2) - 0.20796*y^(-3)*x^(-2) + 0.20796*x^(-3) + 0.080976*y^(-1)*x^(-3) - 0.2216*y^(-2)*x^(-3) + 0.026414*y^(-3)*x^(-3)',10,...
                ']' ...
                ];
            
            % Instantiation of target class
            this.lppufb = LpPuFb2dVm2();
            
            % Actual values
            charActual = char(this.lppufb);
            
            % Evaluation
            this.assertEquals(charExpctd, charActual);
            
        end
        
        % Test for construction with order 2 2
        function this = testConstructorWithDec22Ord22Vm2(this)
            
            % Parameters
            dec = [ 2 2 ];
            ord = [ 2 2 ];
            ang = (2*pi*rand(1,6)-1);
            mus = 2*round(rand(2,6))-1;
            
            % Expected values
            nDecs = prod(dec);
            dimExpctd = [nDecs nDecs ord(1)+1 ord(2)+1];
            
            % Instantiation of target class
            this.lppufb = LpPuFb2dVm2(dec,ord,ang,mus);
            
            % Actual values
            coefActual = double(this.lppufb);
            dimActual = size(coefActual);
            
            % Evaluation
            this.assertEquals(dimExpctd,dimActual);
            
            % Check symmetry
            coefEvn = coefActual(1:ceil(end/2),:);
            coefDiff = coefEvn-fliplr(coefEvn);
            coefDist = norm(coefDiff(:))/sqrt(numel(coefDiff));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            coefOdd = coefActual(ceil(end/2)+1:end,:);
            coefDiff = coefOdd+fliplr(coefOdd);
            coefDist = norm(coefDiff(:))/sqrt(numel(coefDiff));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            
            % Check orthogonality
            E = getPolyPhaseMatrix2d(this.lppufb);
            coefActual = double(E.'*E);
            coefActual(1:nDecs,1:nDecs,ord(1)+1,ord(2)+1) = ...
                coefActual(1:nDecs,1:nDecs,ord(1)+1,ord(2)+1) - eye(nDecs);
            coefDist = norm(coefActual(:))/sqrt(numel(coefActual));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            
            % Check DC-leakage
            delay(1,:,1,1) = 1;
            delay(2,:,2,1) = 1;
            delay(3,:,1,2) = 1;
            delay(4,:,2,2) = 1;
            d = PolyPhaseMatrix2d(delay);
            H = E*d;
            Hdc = [
                sum(sum(H(1,1)))
                sum(sum(H(2,1)))
                sum(sum(H(3,1)))
                sum(sum(H(4,1)))
                ];
            coefDist = norm(Hdc(:).' - [sqrt(prod(dec)) 0 0 0])/...
                sqrt(numel(Hdc));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            
            % Check Vm2
            ckVm2 = checkVm2(this.lppufb);
            this.assert(ckVm2(1)<1e-15,...
                'cy=%g: triange condition failed',ckVm2(1));
            this.assert(ckVm2(2)<1e-15,...
                'cx=%g: triange condition failed',ckVm2(2));
        end
        
        % Test for construction with order 2 2
        function this = testConstructorWithDec44Ord22Vm2(this)
            
            % Parameters
            dec = [ 4 4 ];
            ord = [ 2 2 ];
            ang = 2*pi*rand(28,6);
            mus = 2*round(rand(8,6))-1;
            
            % Expected values
            nDecs = prod(dec);
            dimExpctd = [nDecs nDecs ord(1)+1 ord(2)+1];
            
            % Instantiation of target class
            this.lppufb = LpPuFb2dVm2(dec,ord,ang,mus);
            
            % Actual values
            coefActual = double(this.lppufb);
            dimActual = size(coefActual);
            
            % Evaluation
            this.assertEquals(dimExpctd,dimActual);
            
            % Check symmetry
            coefEvn = coefActual(1:ceil(end/2),:);
            coefDiff = coefEvn-fliplr(coefEvn);
            coefDist = norm(coefDiff(:))/sqrt(numel(coefDiff));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            coefOdd = coefActual(ceil(end/2)+1:end,:);
            coefDiff = coefOdd+fliplr(coefOdd);
            coefDist = norm(coefDiff(:))/sqrt(numel(coefDiff));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            
            % Check orthogonality
            E = getPolyPhaseMatrix2d(this.lppufb);
            coefActual = double(E.'*E);
            coefActual(1:nDecs,1:nDecs,ord(1)+1,ord(2)+1) = ...
                coefActual(1:nDecs,1:nDecs,ord(1)+1,ord(2)+1) - eye(nDecs);
            coefDist = norm(coefActual(:))/sqrt(numel(coefActual));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            
            % Check DC-leakage
            delay = zeros(4);
            for iCol = 1:dec(2)
                for iRow = 1:dec(1)
                    delay(dec(1)*(iCol-1)+iRow,:,iRow,iCol) = 1;
                end
            end
            dc = PolyPhaseMatrix2d(delay);
            H = upsample(E,dec,[1 2])*dc;
            Hdc = zeros(prod(dec),1);
            for i=1:prod(dec)
                Hdc(i) =  sum(sum(H(i,1)));
            end
            coefDist = norm(Hdc(:).' ...
                - [sqrt(prod(dec)) zeros(1,prod(dec)-1)])/sqrt(numel(Hdc));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            
            % Check Vm2
            if getLambdaXueq(this.lppufb) <= 0 && getLambdaYueq(this.lppufb) <= 0
                ckVm2 = checkVm2(this.lppufb);
                this.assert(ckVm2(1)<1e-15,...
                    'cy=%g: triange condition failed',ckVm2(1));
                this.assert(ckVm2(2)<1e-15,...
                    'cx=%g: triange condition failed',ckVm2(2));
            end
            
        end
        
        % Test for construction with order 3 3
        function this = testConstructorWithDec22Ord33Vm2(this)
            
            % Parameters
            dec = [ 2 2 ];
            ord = [ 3 3 ];
            ang = (2*pi*rand(1,8)-1);
            mus = 2*round(rand(2,8))-1;
            
            % Expected values
            nDecs = prod(dec);
            dimExpctd = [nDecs nDecs ord(1)+1 ord(2)+1];
            
            % Instantiation of target class
            this.lppufb = LpPuFb2dVm2(dec,ord,ang,mus);
            
            % Actual values
            coefActual = double(this.lppufb);
            dimActual = size(coefActual);
            
            % lenx3x, lenx3y
            lenx3x = getLengthX3x(this.lppufb);
            lenx3y = getLengthX3y(this.lppufb);
            
            % Evaluation
            this.assertEquals(dimExpctd,dimActual);
            this.assert(lenx3x<2);
            this.assert(lenx3y<2);
            
            % Check symmetry
            coefEvn = coefActual(1:ceil(end/2),:);
            coefDiff = coefEvn-fliplr(coefEvn);
            coefDist = norm(coefDiff(:))/sqrt(numel(coefDiff));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            coefOdd = coefActual(ceil(end/2)+1:end,:);
            coefDiff = coefOdd+fliplr(coefOdd);
            coefDist = norm(coefDiff(:))/sqrt(numel(coefDiff));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            
            % Check orthogonality
            E = getPolyPhaseMatrix2d(this.lppufb);
            coefActual = double(E.'*E);
            coefActual(1:nDecs,1:nDecs,ord(1)+1,ord(2)+1) = ...
                coefActual(1:nDecs,1:nDecs,ord(1)+1,ord(2)+1) - eye(nDecs);
            coefDist = norm(coefActual(:))/sqrt(numel(coefActual));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            
            % Check DC-leakage
            delay(1,:,1,1) = 1;
            delay(2,:,2,1) = 1;
            delay(3,:,1,2) = 1;
            delay(4,:,2,2) = 1;
            d = PolyPhaseMatrix2d(delay);
            H = E*d;
            Hdc = [
                sum(sum(H(1,1)))
                sum(sum(H(2,1)))
                sum(sum(H(3,1)))
                sum(sum(H(4,1)))
                ];
            coefDist = norm(Hdc(:).' - [sqrt(prod(dec)) 0 0 0])/...
                sqrt(numel(Hdc));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            
            % Check Vm2
            if getLambdaXueq(this.lppufb) <= 0 && getLambdaYueq(this.lppufb) <= 0
                ckVm2 = checkVm2(this.lppufb);
                this.assert(ckVm2(1)<1e-15,...
                    'cy=%g: triange condition failed',ckVm2(1));
                this.assert(ckVm2(2)<1e-15,...
                    'cx=%g: triange condition failed',ckVm2(2));
            end
            
        end
        
        % Test for construction with order 3 3
        function this = testConstructorWithDec44Ord33Vm2(this)
            
            % Parameters
            dec = [ 4 4 ];
            ord = [ 3 3 ];
            ang = 2*pi*rand(28,8);
            mus = 2*round(rand(8,8))-1;
            
            % Expected values
            nDecs = prod(dec);
            dimExpctd = [nDecs nDecs ord(1)+1 ord(2)+1];
            
            % Instantiation of target class
            this.lppufb = LpPuFb2dVm2(dec,ord,ang,mus);
            
            % Actual values
            coefActual = double(this.lppufb);
            dimActual = size(coefActual);
            
            % lenx3x, lenx3y
            lenx3x = getLengthX3x(this.lppufb);
            lenx3y = getLengthX3y(this.lppufb);
            
            % Evaluation
            this.assertEquals(dimExpctd,dimActual);
            this.assert(lenx3x<2);
            this.assert(lenx3y<2);
            
            % Check symmetry
            coefEvn = coefActual(1:ceil(end/2),:);
            coefDiff = coefEvn-fliplr(coefEvn);
            coefDist = norm(coefDiff(:))/sqrt(numel(coefDiff));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            coefOdd = coefActual(ceil(end/2)+1:end,:);
            coefDiff = coefOdd+fliplr(coefOdd);
            coefDist = norm(coefDiff(:))/sqrt(numel(coefDiff));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            
            % Check orthogonality
            E = getPolyPhaseMatrix2d(this.lppufb);
            coefActual = double(E.'*E);
            coefActual(1:nDecs,1:nDecs,ord(1)+1,ord(2)+1) = ...
                coefActual(1:nDecs,1:nDecs,ord(1)+1,ord(2)+1) - eye(nDecs);
            coefDist = norm(coefActual(:))/sqrt(numel(coefActual));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            
            % Check DC-leakage
            delay = zeros(4);
            for iCol = 1:dec(2)
                for iRow = 1:dec(1)
                    delay(dec(1)*(iCol-1)+iRow,:,iRow,iCol) = 1;
                end
            end
            dc = PolyPhaseMatrix2d(delay);
            H = upsample(E,dec,[1 2])*dc;
            Hdc = zeros(prod(dec),1);
            for i=1:prod(dec)
                Hdc(i) =  sum(sum(H(i,1)));
            end
            coefDist = norm(Hdc(:).' ...
                - [sqrt(prod(dec)) zeros(1,prod(dec)-1)])/sqrt(numel(Hdc));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            
            % Check Vm2
            if getLambdaXueq(this.lppufb) <= 0 && getLambdaYueq(this.lppufb) <= 0
                ckVm2 = checkVm2(this.lppufb);
                this.assert(ckVm2(1)<1e-15,...
                    'cy=%g: triange condition failed',ckVm2(1));
                this.assert(ckVm2(2)<1e-15,...
                    'cx=%g: triange condition failed',ckVm2(2));
            end
        end
        
    end
    
end
