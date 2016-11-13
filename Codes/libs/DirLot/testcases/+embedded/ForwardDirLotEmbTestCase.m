classdef ForwardDirLotEmbTestCase < TestCase
    %FORWARDDIRLOTEMBTESTCASE Test case for ForwardDirLotEmb
    
    properties
        hf
    end
    
    methods
        function this = tearDown(this)
            delete(this.hf);
        end
        
        function this = testForwardDirLOTEmb(this)
            
%             dec = 2;
%             height = 4;
%             width = 4;
%             Ux1 = [-7 -sqrt(15); sqrt(15) -7]/8;
%             Ux2 = [sqrt(15) 7; 7 -sqrt(15)]/8;
%             Uy1 = [-7 sqrt(15); -sqrt(15) -7]/8;
%             Uy2 = [1 0; 0 -1];
            srcImg = ones(4);
            
            
            % Expected values
%             coefExpctd = [
%                 2 2 0 0;
%                 2 2 0 0;
%                 0 0 0 0;
%                 0 0 0 0
%                 ];
            coefExpctd = [
                2 0 2 0;
                0 0 0 0;
                2 0 2 0;
                0 0 0 0
                ];
                
%             lppufb = LpPuFb2dFactory.createLpPuFb2d();
%             dct = double(lppufb);
%             fun1 = @(x) reshape(dct*flipud(x(:)),dec,dec);
%             afterDct = myblkproc(srcImg,[dec dec],fun1);
%             
%             W0 = [1 0; 0 -1];
%             U0 = [-sqrt(15) 1; -1 -sqrt(15)]/4;
%             R0 = blkdiag(W0,U0);
%             Rx1 = blkdiag(eye(dec),Ux1);
%             Rb = blkdiag(eye(dec),-eye(dec));
%             Rx2 = blkdiag(eye(dec),Ux2);
%             Ry1 = blkdiag(eye(dec),Uy1);
%             Ry2 = blkdiag(eye(dec),Uy2);
%             
%             fun2 = @(x) reshape(R0*x(:),dec,dec);
%             afterW0U0 = myblkproc(afterDct,[dec dec],fun2);
%             
%             btf = [
%                 1 0 1 0;
%                 0 1 0 1;
%                 1 0 -1 0;
%                 0 1 0 -1
%                 ];
%             funBtf = @(x) reshape(btf*x(:),dec,dec);
%             afterBtf1 = myblkproc(afterW0U0,[dec dec],funBtf);
%             afterShift1 = zeros(height,width);
%             afterShift1(1:height,1:dec:width) = afterBtf1(1:height,1:dec:width);
%             afterShift1(1:height,2*dec:dec:width) = afterBtf1(1:height,dec:dec:width-dec);
%             afterShift1(1:height,dec) = afterBtf1(1:height,width);
%             
%             afterBtf2 = (myblkproc(afterShift1,[dec dec],funBtf))/2;
%             afterUx1 = zeros(height,width);
%              for iCol = 1:dec:width
%                  for iRow = 1:dec:height
%                      x = afterBtf2(iRow:iRow+dec-1,iCol:iCol+dec-1);
%                      if iCol == 1
%                          afterUx1(iRow:iRow+dec-1,iCol:iCol+dec-1) = ...
%                              reshape(Rb*(x(:)),dec,dec);
%                      else
%                          afterUx1(iRow:iRow+dec-1,iCol:iCol+dec-1) = ...
%                              reshape(Rx1*(x(:)),dec,dec);
%                      end
%                  end
%              end
%              
%              afterBtf3 = myblkproc(afterUx1,[dec dec],funBtf);
%              afterShift2 = zeros(height,width);
%              afterShift2(1:height,2:dec:width) = afterBtf3(1:height,2:dec:width);
%              afterShift2(1:height,1:dec:width-dec) = afterBtf3(1:height,dec+1:dec:width);
%              afterShift2(1:height:width-dec+1) = afterBtf3(1:height,1);
%              
%              afterBtf4 = (myblkproc(afterShift2,[dec dec],funBtf))/2;
%              
%              afterUx2 = zeros(height,width);
%              for iCol = 1:dec:width
%                 for iRow = 1:dec:height
%                     y = afterBtf4(iRow:iRow+dec-1,iCol:iCol+dec-1);
%                     afterUx2(iRow:iRow+dec-1,iCol:iCol+dec-1) = ...
%                         reshape(Rx2*(y(:)),dec,dec);
%                 end
%              end
%              
%              afterBtf5 = myblkproc(afterUx2,[dec dec],funBtf);
%              afterShift3 = zeros(height,width);
%              afterShift3(1:height,1:dec:width) = afterBtf5(1:height,1:dec:width);
%              afterShift3(1:dec,2:dec:width) = afterBtf5(height-dec+1:height,2:dec:width);
%              afterShift3(dec+1:height,2:dec:width) = afterBtf5(1:height-dec,2:dec:width);
%              
%              afterBtf6 = (myblkproc(afterShift3,[dec dec],funBtf))/2;
%             
%              afterUy1 = zeros(height,width);
%              for iCol = 1:dec:width
%                  for iRow = 1:dec:height
%                      z = afterBtf6(iRow:iRow+dec-1,iCol:iCol+dec-1);
%                      if iRow == 1
%                          afterUy1(iRow:iRow+dec-1,iCol:iCol+dec-1) = ...
%                              reshape(Rb*(z(:)),dec,dec);
%                      else
%                          afterUy1(iRow:iRow+dec-1,iCol:iCol+dec-1) = ...
%                              reshape(Ry1*(z(:)),dec,dec);
%                      end
%                  end
%              end
%              
%              afterBtf7 = myblkproc(afterUy1,[dec dec],funBtf);
%              afterShift4 = zeros(height,width);
%              afterShift4(1:height,2:dec:width) = afterBtf7(1:height,2:dec:width);
%              afterShift4(height-dec+1:height,1:dec:width) = afterBtf7(1:dec,1:dec:width);
%              afterShift4(1:height-2,1:dec:width) = afterBtf7(dec+1:height,1:dec:width);
%              
%              afterBtf8 = (myblkproc(afterShift4,[dec dec],funBtf))/2;
%              
%              afterUy2 = zeros(height,width);
%              for iCol = 1:dec:width
%                 for iRow = 1:dec:height
%                     p = afterBtf8(iRow:iRow+dec-1,iCol:iCol+dec-1);
%                     afterUy2(iRow:iRow+dec-1,iCol:iCol+dec-1) = ...
%                         reshape(Ry2*(p(:)),dec,dec);
%                 end
%              end
             
             % Instantiation
             this.hf = ForwardDirLotEmb();
             % Actual values
             coefActual = step(this.hf,srcImg);
             
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


