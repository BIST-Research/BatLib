%
% Author: Ben Westcott
% Date created: 2/10/24
%

function [tDiv, sRate] = get_scope_settings(connstr)
    scope = visadev(connstr);
    scope.Timeout = 2;
    write(scope, 'CHDR OFF');
    flush(scope, 'output');

    tDiv = str2double(writeread(scope, 'TDIV?'));
    sRate = str2double(writeread(scope, 'SARA?'));
    flush(scope, 'input');

    clear scope;

end