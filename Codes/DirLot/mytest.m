%MYTEST2008A Test script for DirLOT Toolbox Project
% This test script works with mlUnit2008a.
% mlUnit2008a is available from MATLAB Central File Exchange.
% See the following site:
%
%  http://www.mathworks.cn/matlabcentral/fileexchange/21888
%
% SVN identifier:
% $Id: mytest.m 350 2012-10-31 21:35:27Z sho $
%
% Requirements: MATLAB R2008a, mlunit_2008a
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

%% Clear classes
clear classes

%% 
if ~exist('./mlunit_2008a','dir')
    fprintf('Downloading mlunit_2008a.zip.\n');
    url = 'http://www.mathworks.cn/matlabcentral/fileexchange/21888-mlunit2008a?controller=file_infos&download=true';
    unzip(url,'.')
    fprintf('Done!\n');
else
    fprintf('mlunit_2008a already exists.\n');
    fprintf('See %s\n', ...
        'http://www.mathworks.cn/matlabcentral/fileexchange/21888-mlunit2008a');
end

%% Set path
setpath
addpath('./mlunit_2008a')
addpath('./testcases')

%% Open matlabpool
isOpeningPct = false;
[isPctAvailable, errmsg] = license('checkout','distrib_computing_toolbox');
if isPctAvailable && exist('matlabpool','file') == 2 && ...
   matlabpool('size') < 1
   matlabpool open
   isOpeningPct = true;
end

%% Set mlunit runner
runner = TextTestRunner();

%% Set list of test suites
TestSuites= {
    'dirlot.DirLotTestSuite',...
    'genlot.GenLotTestSuite',...
    'appendix.AppendixTestSuite',...
    'embedded.EmbeddedTestSuite'
    };

%% Add test suites
clearTests(runner);
for iTestSuite = TestSuites
    addTests(runner, iTestSuite);
end

%% Run test suites
runTests(runner);

%% Show report
% showReport(runner);

%% Close matlabpool
if isPctAvailable && exist('matlabpool','file') == 2 && ...
        ~verLessThan('distcomp','4.0') && ...
        isOpeningPct
    if matlabpool('size') > 0
        matlabpool close
    end
end