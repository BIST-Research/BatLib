%
% Author: Ben Westcott
% Date created: 2/10/24
%

function [tDiv, sRate] = set_scope_settings(connstr, tDiv_str)
    scope = visadev(connstr);
    scope.Timeout = 2;

    write(scope, 'CHDR OFF');
    write(scope, sprintf('TDIV %s', tDiv_str));
    flush(scope, 'output');

    tDiv = str2double(writeread(scope, 'TDIV?'));
    sRate = str2double(writeread(scope, 'SARA?'));
    flush(scope, 'input');

    clear scope;

end

