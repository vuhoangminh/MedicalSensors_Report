if ~exist('ssim_index.m','file')
    fprintf('Downloading ssim_index.m.\n');
    ssimcode = ...
        urlread('https://ece.uwaterloo.ca/~z70wang/research/ssim/ssim_index.m');
    fid = fopen('ssim_index.m','w');
    fwrite(fid,ssimcode);
    fprintf('Done!\n');
else
    fprintf('ssim_index.m already exists.\n');
    fprintf('See %s\n', ...
        'https://ece.uwaterloo.ca/~z70wang/research/ssim/');
end