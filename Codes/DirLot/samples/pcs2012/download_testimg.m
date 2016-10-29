function download_testimg(fname)
% DOWNLOAD_TEST_IMG: Download a test image
%
% SVN identifier:
% $Id: download_testimg.m 254 2011-11-28 08:57:50Z sho $
%
% Requirements: MATLAB R2011a
%
% Copyright (c) 2011, Shogo MURAMATSU
%
% All rights reserved.
%
% Contact address: Shogo MURAMATSU,
%                Faculty of Engineering, Niigata University,
%                8050 2-no-cho Ikarashi, Nishi-ku,
%                Niigata, 950-2181, JAPAN
%
if ~exist(sprintf('./images/%s',fname),'file')
    img = imread(...
        sprintf('http://homepages.cae.wisc.edu/~ece533/images/%s',...
        fname));
    if size(img,3) == 3
        img = rgb2gray(img);
    end
    imwrite(img,sprintf('./images/%s',fname));
    fprintf('Downloaded and saved %s in ./images\n',fname);
else
    fprintf('%s already exists in ./images\n',fname);
end