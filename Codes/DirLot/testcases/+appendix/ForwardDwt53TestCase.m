classdef ForwardDwt53TestCase < TestCase
    %FORWARDDWT53TESTCASE Test case for ForwardDwt53
    %
    % SVN identifier:
    % $Id: ForwardDwt53TestCase.m 249 2011-11-27 01:55:42Z sho $
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
        fdwt;
        filterL = [-1 2 6 2 -1]/8;
        filterH = [-1 2 -1]/2;
    end
    
    methods
      
        % Test
        function this = testForwardDwt53Level1(this)
            
            % Preperation
            nLevels = 1;
            nDecs = nLevels*3+1;
            height = 16;
            width = 16;
            srcImg = rand(height,width);
            
            % Expected value
            coefsExpctd = forwardtransform_(this,srcImg);
            
            % Target instantiation
            this.fdwt = ForwardDwt53(srcImg,nLevels);
            
            % Actual value
            this.fdwt = forwardtransform(this.fdwt);
            coefsActual = getCoefs(this.fdwt);
            
            % Evaluation
            for iSubband = 1:nDecs
                subCoefExpctd = coefsExpctd{iSubband};
                subCoefActual = coefsActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-14,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = testForwardDwt53Level2(this)
            
            % Preperation
            nLevels = 2;
            nDecs = nLevels*3+1;
            height = 16;
            width = 16;
            srcImg = rand(height,width);
            
            % Expected value
            subCoefsLv1 = forwardtransform_(this,srcImg);
            subCoefsLv2 = forwardtransform_(this,subCoefsLv1{1});
            coefsExpctd{1} = subCoefsLv2{1};
            coefsExpctd{2} = subCoefsLv2{2};
            coefsExpctd{3} = subCoefsLv2{3};
            coefsExpctd{4} = subCoefsLv2{4};
            coefsExpctd{5} = subCoefsLv1{2};
            coefsExpctd{6} = subCoefsLv1{3};
            coefsExpctd{7} = subCoefsLv1{4};
            
            % Target instantiation
            this.fdwt = ForwardDwt53(srcImg,nLevels);
            
            % Actual value
            this.fdwt = forwardtransform(this.fdwt);
            coefsActual = getCoefs(this.fdwt);
            
            % Evaluation
            for iSubband = 1:nDecs
                subCoefExpctd = coefsExpctd{iSubband};
                subCoefActual = coefsActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-14,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = testForwardDwt53Level3(this)
            
            % Preperation
            nLevels = 3;
            nDecs = nLevels*3+1;
            height = 32;
            width = 32;
            srcImg = rand(height,width);
            
            % Expected value
            subCoefsLv1 = forwardtransform_(this,srcImg);
            subCoefsLv2 = forwardtransform_(this,subCoefsLv1{1});
            subCoefsLv3 = forwardtransform_(this,subCoefsLv2{1});
            coefsExpctd{1} = subCoefsLv3{1};
            coefsExpctd{2} = subCoefsLv3{2};
            coefsExpctd{3} = subCoefsLv3{3};
            coefsExpctd{4} = subCoefsLv3{4};
            coefsExpctd{5} = subCoefsLv2{2};
            coefsExpctd{6} = subCoefsLv2{3};
            coefsExpctd{7} = subCoefsLv2{4};
            coefsExpctd{8} = subCoefsLv1{2};
            coefsExpctd{9} = subCoefsLv1{3};
            coefsExpctd{10} = subCoefsLv1{4};
            
            % Target instantiation
            this.fdwt = ForwardDwt53(srcImg,nLevels);
            
            % Actual value
            this.fdwt = forwardtransform(this.fdwt);
            coefsActual = getCoefs(this.fdwt);
            
            % Evaluation
            for iSubband = 1:nDecs
                subCoefExpctd = coefsExpctd{iSubband};
                subCoefActual = coefsActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-14,sprintf('%d:%g',iSubband,diff));
            end
        end
        
    end
    
    methods
        
        function value = forwardtransform_(this,srcImg)
            phase = 1; % for phase adjustment required experimentaly
            value{1} = ...
                downsample(appendix.ForwardDwt53TestCase.myimfilter_( ...
                downsample(appendix.ForwardDwt53TestCase.myimfilter_(...
                srcImg,this.filterL),2).',...
                this.filterL),2).';
            value{2} = ...
                downsample(appendix.ForwardDwt53TestCase.myimfilter_( ...
                downsample(appendix.ForwardDwt53TestCase.myimfilter_(...
                srcImg,this.filterL),2).',...
                this.filterH),2,phase).';
            value{3} = ...
                downsample(appendix.ForwardDwt53TestCase.myimfilter_( ...
                downsample(appendix.ForwardDwt53TestCase.myimfilter_(...
                srcImg,this.filterH),2,phase).',...
                this.filterL),2).';
            value{4} = ...
                downsample(appendix.ForwardDwt53TestCase.myimfilter_( ...
                downsample(appendix.ForwardDwt53TestCase.myimfilter_(...
                srcImg,this.filterH),2,phase).',...
                this.filterH),2,phase).';
        end
        
    end
    
    methods (Access = private, Static = true)
        
        function value = myimfilter_(orgImg,filter)
            verticalSize = size(orgImg,1);
            symImg = appendix.ForwardDwt53TestCase.symWS_(orgImg);
            filter = filter(:);
            value = imfilter(symImg,filter,'conv');
            value = appendix.ForwardDwt53TestCase.clipping_(value,verticalSize);
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
