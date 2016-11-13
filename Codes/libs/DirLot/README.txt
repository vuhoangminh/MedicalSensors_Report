* MATLAB class definitions for directional lapped orthogonal transforms

---

NOTICE: SaivDr Package contains fast and stable implementation of DirLOTs. 
Please see the folder 'examples/dirlot' in the package.

 http://www.mathworks.com/matlabcentral/fileexchange/45084-saivdr-package

---

- Release DirLOT20130201

** Requirements

- MATLAB R2011b or later, 
-- Image Processing Toolbox
-- Optimization Toolbox

** Recomended

-- Global Optimization Toolbox 
-- Parallel Computing Toolbox
-- Wavelet Toolbox 
-- MATLAB Coder

** Brief introduction

1. Change directory to where this file contains on MATLAB.

2. Set the path by using the following command:

 >> setpath

3. If MATLAB Coder is available, it is recommended to first 
   generate MEX codes for the M-files in the 'mexcode' directory. 
   The M-file script 'mybuild,'  which you can find at the top directory 
   of this toolbox, does the task as a batch file.

 >> mybuild

4. Change directory to 'sample' and run an M-file of which name begins
   with 'main,' such as

 >> main_tip2011td

   and then run an M-file of which name begins with 'disp,' such as

 >> disp_denoisingresults

** References 

- Natsuki Aizawa and Shogo Muramatsu, ''FISTA-Based Image Restoration
  with Multiple DirLOTs," Proc. of IWAIT 2013, pp.642-647, Jan. 2013.

- Shogo Muramatsu, Natsuki Aizawa and Masahiro Yukawa, ''Image Restoration 
  with Union of Directional Orthonormal DWTs,'' Proc. of APSIPA ASC 2012, 
  Dec. 2012.

- Shogo Muramatsu, ''SURE-LET Image Denoising with Multiple
  Directional LOTs,'' Proc. of PCS2012, May 2012

- Shogo Muramatsu, Dandan Han, Tomoya Kobayashi and Hisakazu Kikuchi,
  ''Directional Lapped Orthogonal Transform: Theory and Design,'' IEEE
  Trans. on Image Proc., Vol.21, No.5, pp.2434-2448, 
  DOI: 10.1109/TIP.2011.2182055, May 2012

- Shogo Muramatsu,Tomoya Kobayashi, Minoru Hiki and Hisakazu Kikuchi,
  ''Block-wise Implementation of 2-D Non-separable Linear-phase
  Paraunitary Filter Banks,'' IEEE Trans. on Image Proc., Vol.21, No.4,
  pp.2314-2318, DOI: 10.1109/TIP.2011.2181527, April 2012

- Shogo Muramatsu and Dandan Han ''Image Denoising with Union of
  Directional Orthonormal DWTs,'' IEEE Proc. of ICASSP, pp.1089-1092,
  Mar. 2012.

- Shogo Muramatsu, Dandan Han and Hisakazu Kikuchi, 
  ''SURE-LET Image Denoising with Directional LOTs,''
   Proc. of APSIPA ASC 2011, THu-PM.PS1.9, Oct. 2011

- Shogo Muramatsu, Tomoya Kobayashi, Dandan Han and Hisakazu Kikuchi, 
  ''Design Method of Directional GenLOT with Trend Vanishing Moments,''
   Proc. of APSIPA ASC 2010, pp.692-701, Dec. 2010

- Shogo Muramatsu, Dandan Han, Tomoya Kobayashi and Hisakazu Kikuchi, 
  ''Theoretical Analysis of Trend Vanishing Moments for Directional
  Orthogonal Transforms, ''
  Proc. of PCS2010, pp.130-133, Dec. 2010

- Tomoya Kobayashi, Shogo Muramatsu and Hisakazu Kikuchi, 
  ''2-D Nonseparable GenLOT with Trend Vanishing Moments, ''
  IEEE Proc. of ICIP2010, pp.385-388, Sep. 2010.

- Shogo Muramatsu and Minoru Hiki, 
  ''Block-Wise Implementation of Directional GenLOT,''
  IEEE Proc. of ICIP2009, pp.3977-3980, Nov. 2009

- Tomoya Kobayashi, Shogo Muramatsu and Hisakazu Kikuchi, 
  ''Two-Degree Vanishing Moments on 2-D Non-separable GenLOT,''
  IEEE Proc. of ISPACS2009, pp.248-251, Dec. 2009.

** Contact address: 

   Shogo MURAMATSU,
   Faculty of Engineering, Niigata University,
   8050 2-no-cho Ikarashi, Nishi-ku,
   Niigata, 950-2181, JAPAN
   Email: shogo@eng.niigata-u.ac.jp
   LinkedIn: http://www.linkedin.com/pub/shogo-muramatsu/4b/b08/627

** Contributors

- For coding
-- Tomoya KOBAYASHI, 2008-2010
-- Shintaro HARA, 2011-
-- Natsuki AIZAWA, 2011-

- For testing
-- Haruki MINAGAWA, 2009-2010
-- Rui WANG, 2009-2011
-- Dandan HAN, 2009-2012
-- Saemi CHOI, 2010-2011
-- Yuya OTA, 2010-
-- Kazuki TAKEDA, 2010-

% SVN identifier:
% $Id: README.txt 385 2016-04-15 02:59:04Z sho $
