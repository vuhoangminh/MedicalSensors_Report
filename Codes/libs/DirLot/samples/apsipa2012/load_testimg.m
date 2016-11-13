function [im,strpartpic] = load_testimg(strpic)
%
switch strpic
    case { 'goldhill' 'lena' 'barbara' 'baboon' }
        nDim = 512*[1 1];
        download_testimg([strpic '.png']);
        src = imread(['./images/' strpic '.png']);
        py = 0;
        px = 0;
    case { 'goldhill128' 'lena128' 'barbara128' }
        nDim = 128*[1 1];
        download_testimg([strpic(1:end-3) '.png']);
        src = imread(['./images/' strpic(1:end-3) '.png']);
        py = 196;
        px = 196;        
    case { 'goldhill256' 'lena256' 'barbara256' }
        nDim = 256*[1 1];
        download_testimg([strpic(1:end-3) '.png']);
        src = imread(['./images/' strpic(1:end-3) '.png']);
        py = 196;
        px = 196;        
    case { 'baboon128' }
        nDim = 128*[1 1];
        download_testimg([strpic(1:end-3) '.png']);
        src = imread(['./images/' strpic(1:end-3) '.png']);
        py = 16;
        px = 128;
    case { 'baboon256' }
        nDim = 256*[1 1];
        download_testimg([strpic(1:end-3) '.png']);
        src = imread(['./images/' strpic(1:end-3) '.png']);
        py = 16;
        px = 128;        
end
im = src(py+1:py+nDim(1),px+1:px+nDim(2));
strpartpic = sprintf('%s_y%d_x%d_%dx%d',strpic,py,px,nDim(1),nDim(2));