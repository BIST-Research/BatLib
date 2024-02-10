%
% Author: Ben Westcott
% Date created: 2/10/24
%

% Uses Siglent SDS oscope and SDG waveform generator
% to determine inductance via resonating with a known
% capacitance. Can work the other way if yu have known inductance

clc;
clear all;
commandwindow;

L_guess = 10E-6;
L_tol = 0.10;

L_guess_hb = L_guess*(1 - L_tol);
L_guess_lb = L_guess*(1 + L_tol);

C_val = 0.2196E-6;

f_lb = 1/(2*pi*sqrt(C_val*L_guess_lb));
f_hb = 1/(2*pi*sqrt(C_val*L_guess_hb));

% Create a VISA connection using the resource name or alias.
v = visadev("USB0::0xF4EC::0xEE38::SDSMMFCX5R3765::0::INSTR");
v.Timeout = 2;

g = visadev("USB0::0xF4EC::0x1103::SDG1XDDD6R8127::0::INSTR");
g.Timeout = 2;

write(g, 'C2:BSWV WVTP,SINE,FRQ,1000HZ,AMP,10V,OFST,0V');
write(g, 'C2:OUTP ON')

c2_rms = writeread(v, 'C2:PAVA? RMS');
c2_rms = erase(c2_rms, 'C2:PAVA RMS,');
c2_rms = str2double(erase(c2_rms, 'V'));

rms_lst = [];
grad_vec_y = zeros(1, 4);
grad_vec_x = zeros(1, 4);

dx = 1;

r = 110E3:dx:112E3;

min_grad = 100;
c_max = 1;

for c = 1:1:length(r)
    write(g, sprintf("C2:BSWV FRQ,%dHz", r(c)));
    flush(g);

    c2_rms = writeread(v, 'C2:PAVA? RMS');
    c2_rms = erase(c2_rms, 'C2:PAVA RMS,');
    c2_rms = str2double(erase(c2_rms, 'V'));

    rms_lst(c) = c2_rms;
    grad_mod_idx = 1 + mod(r(c), 4);

    if grad_mod_idx == 1 && c ~= 1
        grad = gradient(grad_vec_y(:))./gradient(grad_vec_x(:))

        sgrad = sum(grad);
        if sgrad <= min_grad
            min_grad = sgrad
            c_max = c
        end
    end

    grad_vec_y(grad_mod_idx) = c2_rms;
    grad_vec_x(grad_mod_idx) = r(c);

end

[C, I] = max(rms_lst);

% c1_pkpk = writeread(v, 'C1:PAVA? PKPK');
% c1_pkpk = erase(c1_pkpk, "C1:PAVA PKPK,");
% c1_pkpk = str2double(erase(c1_pkpk, "V"))
% 
% c2_pkpk = writeread(v, 'C2:PAVA? PKPK');
% c2_pkpk = erase(c2_pkpk, "C2:PAVA PKPK,");
% c2_pkpk = str2double(erase(c2_pkpk, "V"))

%write(v, 'C1:TRA ON');
%write(v, 'C2:TRA ON');
%write(v, 'C3:TRA OFF');
%write(v, 'C4:TRA OFF');

% volts per div = 1 volt
%vdiv = 1;

%write(v, 'C1:VDIV 1');
%write(v, 'C2:VDIV 1');

% time per div = 200 us
%write(v, 'TDIV 200US');

%write(v, 'XYDS OFF');
% Query C1 volts-per-division
%vdiv = writeread(visadevObj, 'C1:VDIV?');

% Query C1 offset
%offset = writeread(visadevObj, 'C1:OFST?');

% Query time division
%tdiv = writeread(visadevObj, 'TDIV?');

% Query sampling rate
%sr = writeread(visadevObj, 'SARA?');
%sp = writeread(visadevObj, 'SANU? C1');

%wfsu = writeread(visadevObj, 'WFSU?')
%write(v, 'C2:WF? dat1')
%recv = read(v, 2)
%write(visadevObj, 'CHDR OFF');
%brugh = writeread(visadevObj, 'C1:WF? DAT2')

%plot(recv)

% pha = writeread(v, 'C1-C2:MEAD? PHA')
% pha = split(pha, ',');
% pha = pha(2);
% pha = erase(pha, "degree");
% pha = str2double(pha)
% 
% dt_fff = writeread(v, 'C1-C2:MEAD? FFF');
% dt_fff = erase(dt_fff, "C1-C2:MEAD FFF,");
% dt_fff = str2double(erase(dt_fff, "S"));
% 
% dt_frr = writeread(v, 'C1-C2:MEAD? FRR');
% dt_frr = erase(dt_frr, "C1-C2:MEAD FRR,");
% dt_frr = str2double(erase(dt_frr, "S"));
%read(visadevObj,1000)
