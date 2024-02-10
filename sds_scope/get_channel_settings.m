%
% Author: Ben Westcott
% Date created: 2/10/24
%

function [vDiv, offs, sCount] = get_channel_settings(connstr, chnum)
    scope = visadev(connstr);
    scope.Timeout = 2;
    write(scope, 'CHDR OFF');
    flush(scope, 'output');

    ch = sprintf('C%d', chnum);
    vdiv_prefix = strcat(ch, ':VDIV');
    offs_prefix = strcat(ch, ':OFST');

    vDiv = str2double(writeread(scope, vdiv_prefix + "?"));
    offs = str2double(writeread(scope, offs_prefix + "?"));
    sCount = str2double(writeread(scope, "SANU?" +  " " + ch));
    flush(scope, 'input');

    clear scope
end

