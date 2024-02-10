%
% Author: Ben Westcott
% Date created: 2/10/24
%

function [vDiv, offs, sCount] = set_channel_settings(connstr, chnum, vDiv_str, offs_str)

    scope = visadev(connstr);
    scope.Timeout = 2;

    ch = sprintf('C%d', chnum);
    vdiv_prefix = strcat(ch, ':VDIV');
    offs_prefix = strcat(ch, ':OFST');

    write(scope, 'CHDR OFF');

    write(scope, vdiv_prefix + " " + vDiv_str);
    write(scope, offs_prefix + " " + offs_str);
    flush(scope, 'output');

    vDiv = str2double(writeread(scope, vdiv_prefix + "?"));
    offs = str2double(writeread(scope, offs_prefix + "?"));
    sCount = str2double(writeread(scope, "SANU?" +  " " + ch));
    flush(scope, 'input');

    clear scope;

end