%
% Author: Ben Westcott
% Date created: 2/10/24
%
clc;
commandwindow;
clear all;

WF_HEADER_LENGTH = 16;
WF_FOOTER_LENGTH = 2;

interface = 'USB0::0xF4EC::0xEE38::SDSMMFCX5R3765::0::INSTR';

%[tDiv, sRate] = scope_settings(interface, '1MS');
%[vDiv, offs, sCount] = channel_settings(interface, 1, '500MV', '0V');

[tDiv, sRate] = get_scope_settings(interface);
[vDiv, offs, sCount] = get_channel_settings(interface, 1);

scope = visadev(interface);
scope.Timeout = 2;

write(scope, 'CHDR OFF');
flush(scope, 'output');

write(scope, 'C1:WF? DAT2');
flush(scope, 'output');

raw_data = read(scope, sCount + WF_HEADER_LENGTH + WF_FOOTER_LENGTH);
raw_data = raw_data((WF_HEADER_LENGTH + 1) : (end - WF_FOOTER_LENGTH));

out_size = size(raw_data, 2);
assert(out_size == sCount);

[tvec, data] = decode_raw_waveform(raw_data, sRate, tDiv, vDiv, offs);

plot(tvec, data);

clear scope;