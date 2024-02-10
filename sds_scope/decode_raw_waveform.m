%
% Author: Ben Westcott
% Date created: 2/10/24
%

function [tvec, data] = decode_raw_waveform(raw_data, sRate, tDiv, vDiv, offs)

    dsize = size(raw_data, 2);

    tvec = zeros(dsize, 1);
    data = zeros(dsize, 1);

    for n = 1:1:dsize

        tvec(n) = -(tDiv * (14/2)) + ((n - 1) * (1/sRate));

        if raw_data(n) > 127
            raw_data(n) = raw_data(n) - 255;
        end

        data(n) = raw_data(n) * (vDiv/25) - offs;

    end
end
