classdef InverseDwt97TestCase < TestCase
    %INVERSEDWT97TESTCASE Test case for InverseDwt97
    %
    % SVN identifier:
    % $Id: InverseDwt97TestCase.m 249 2011-11-27 01:55:42Z sho $
    %
    % Requirements: MATLAB R2008a, mlunit_2008a
    %
    % Copyright (c) 2008-2009, Shogo MURAMATSU
    %
    % All rights reserved.
    %
    % Contact address: Shogo MURAMATSU,
    %                Faculty of Engineering, Niigata University,
    %                8050 2-no-cho Ikarashi, Nishi-ku,
    %                Niigata, 950-2181, JAPAN
    %
    properties
        idwt;
        filterL = [ ...
            -0.09127176311424948 ;
            -0.05754352622849957 ;
             0.5912717631142470 ;
             1.115087052456994 ;
             0.5912717631142470 ;
            -0.05754352622849957 ;
            -0.09127176311424948 ];
        filterH = [ ...
             0.02674875741080976 ;
             0.01686411844287495 ;
            -0.07822326652898785 ;
            -0.2668641184428723 ;
             0.6029490182363579 ;
            -0.2668641184428723 ;
            -0.07822326652898785 ;
             0.01686411844287495 ;
             0.02674875741080976 ];
    end
    
    methods
       
        % Test
        function this = testInverseDwt97Level1(this)
            
            % Preperation
            height = 16;
            width = 16;
            subCoefs{1} = rand(height/2,width/2);
            subCoefs{2} = rand(height/2,width/2);
            subCoefs{3} = rand(height/2,width/2);
            subCoefs{4} = rand(height/2,width/2);
            
            % Expected value
            imgExpctd = inversetransform_(this,subCoefs);
            
            % Target instantiation
            this.idwt = InverseDwt97(subCoefs);
            
            % Actual value
            this.idwt = inversetransform(this.idwt);
            imgActual = getImg(this.idwt);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))...
                /numel(imgExpctd);
            this.assert(diff<1e-14,sprintf('%g',diff));
        end
        
        % Test
        function this = testInverseDwt97Level2(this)
            
            % Preperation
            height = 16;
            width = 16;
            subCoefs{1} = rand(height/4,width/4);
            subCoefs{2} = rand(height/4,width/4);
            subCoefs{3} = rand(height/4,width/4);
            subCoefs{4} = rand(height/4,width/4);
            subCoefs{5} = rand(height/2,width/2);
            subCoefs{6} = rand(height/2,width/2);
            subCoefs{7} = rand(height/2,width/2);
            
            % Expected value
            subLv2{1} = subCoefs{1};
            subLv2{2} = subCoefs{2};
            subLv2{3} = subCoefs{3};
            subLv2{4} = subCoefs{4};
            subLv1{1} = inversetransform_(this,subLv2);
            subLv1{2} = subCoefs{5};
            subLv1{3} = subCoefs{6};
            subLv1{4} = subCoefs{7};
            imgExpctd = inversetransform_(this,subLv1);
            
            % Target instantiation
            this.idwt = InverseDwt97(subCoefs);
            
            % Actual value
            this.idwt = inversetransform(this.idwt);
            imgActual = getImg(this.idwt);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))...
                /numel(imgExpctd);
            this.assert(diff<1e-14,sprintf('%g',diff));
        end
        
        % Test
        function this = testInverseDwt97Level3(this)
            
            % Preperation
            height = 32;
            width = 32;
            subCoefs{1} = rand(height/8,width/8);
            subCoefs{2} = rand(height/8,width/8);
            subCoefs{3} = rand(height/8,width/8);
            subCoefs{4} = rand(height/8,width/8);
            subCoefs{5} = rand(height/4,width/4);
            subCoefs{6} = rand(height/4,width/4);
            subCoefs{7} = rand(height/4,width/4);
            subCoefs{8} = rand(height/2,width/2);
            subCoefs{9} = rand(height/2,width/2);
            subCoefs{10} = rand(height/2,width/2);
            
            % Expected value
            subLv3{1} = subCoefs{1};
            subLv3{2} = subCoefs{2};
            subLv3{3} = subCoefs{3};
            subLv3{4} = subCoefs{4};
            subLv2{1} = inversetransform_(this,subLv3);
            subLv2{2} = subCoefs{5};
            subLv2{3} = subCoefs{6};
            subLv2{4} = subCoefs{7};
            subLv1{1} = inversetransform_(this,subLv2);
            subLv1{2} = subCoefs{8};
            subLv1{3} = subCoefs{9};
            subLv1{4} = subCoefs{10};
            imgExpctd = inversetransform_(this,subLv1);
            
            % Target instantiation
            this.idwt = InverseDwt97(subCoefs);
            
            % Actual value
            this.idwt = inversetransform(this.idwt);
            imgActual = getImg(this.idwt);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))...
                /numel(imgExpctd);
            this.assert(diff<1e-14,sprintf('%g',diff));
        end
        
    end
    
    methods
        
        function value = inversetransform_(this,subCoefs)
            phase = 1; % for phase adjustment required experimentaly
            value = ...
                appendix.InverseDwt97TestCase.myimfilter_( ...
                upsample(appendix.InverseDwt97TestCase.myimfilter_(...
                upsample(subCoefs{1},2),this.filterL).',2),this.filterL).';
            value = value + ...
                appendix.InverseDwt97TestCase.myimfilter_( ...
                upsample(appendix.InverseDwt97TestCase.myimfilter_(...
                upsample(subCoefs{2},2),this.filterL).',2,phase),this.filterH).';
            value = value + ...
                appendix.InverseDwt97TestCase.myimfilter_( ...
                upsample(appendix.InverseDwt97TestCase.myimfilter_(...
                upsample(subCoefs{3},2,phase),this.filterH).',2),this.filterL).';
            value = value + ...
                appendix.InverseDwt97TestCase.myimfilter_( ...
                upsample(appendix.InverseDwt97TestCase.myimfilter_(...
                upsample(subCoefs{4},2,phase),this.filterH).',2,phase),this.filterH).';
        end
        
    end
    
    methods (Access = private, Static = true)
        
        function value = myimfilter_(orgImg,filter)
            verticalSize = size(orgImg,1);
            symImg = appendix.InverseDwt97TestCase.symWS_(orgImg);
            filter = filter(:);
            value = imfilter(symImg,filter,'conv');
            value = appendix.InverseDwt97TestCase.clipping_(value,verticalSize);
        end
        
        function value = symWS_(orgImg)
            imgSize = size(orgImg);
            if mod(imgSize(1),2) == 0
                value = [ ...
                    flipud(orgImg(2:5,:));
                    orgImg;
                    flipud(orgImg(end-4:end-1,:))];
            else
                value = [ ...
                    flipud(orgImg(2:4,:));
                    orgImg;
                    flipud(orgImg(end-3:end-1,:))];
            end
        end
        
        function value = clipping_(symImg,verticalSize)
            if mod(verticalSize(1),2) == 0
                value = symImg(5:end-4,:);
            else
                value = symImg(4:end-3,:);
            end
        end
        
    end
    
end
