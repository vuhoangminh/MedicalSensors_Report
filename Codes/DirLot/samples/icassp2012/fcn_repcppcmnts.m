function fcn_repcppcmnts(fname)

fnameorg = [fname '.org'];
if ~exist(fnameorg,'file')
    fprintf('Replace C++ style comments in %s. \n', fname)
    movefile(fname,fnameorg);
    fidorg = fopen(fnameorg,'r');
    fidnew = fopen(fname,'w');
    tline = fgets(fidorg);
    while ischar(tline)
        cmntstr = regexp(tline,'//.*$','match','once');
        if ~isempty(cmntstr)
            cmnt = regexprep(cmntstr,'//','/* ');
            cmnt = regexprep(cmnt,'(\r\n|\n\r|\n|\r)',' */\n');
            cmnt = regexprep(cmnt,'\*/[ \t]\*/',' */');
            tlinenew = regexprep(tline,'//.*$',cmnt);
        else
            tlinenew = tline;
        end
        fprintf(fidnew,'%s',tlinenew);
        tline = fgets(fidorg);
    end
    fclose(fidorg);
    fclose(fidnew);
end