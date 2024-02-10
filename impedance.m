%
% Author: Ben Westcott
% Date created: 2/10/24
%

% Simple script to determine impedance from V/I

clc;
commandwindow;

get_inductance(58.60E-3, 10.08, 40E-9, 4.45E6, 10E3)

function imp = get_impedance(Vpkr, Vpkc, dt, freq)

phase_diff = deg2rad(360 * dt * freq);

[Vpkr_Re, Vpkr_Im] = pol2cart(phase_diff, Vpkr);

Vpkr_Cmplx = Vpkr_Re + 1j*Vpkr_Im;
Vpkc_Cmplx = Vpkc + 1j*0;

imp = Vpkc_Cmplx/(Vpkr_Cmplx - Vpkc_Cmplx);

end

function ind = get_inductance(Vpkr, Vpkc, dt, freq, R)

ind = (R * imag(get_impedance(Vpkr, Vpkc, dt, freq))/(2*pi*freq));

end

function kp = get_kp(Loc, Lsc)

kp = sqrt((Loc - Lsc)/Loc);

end


