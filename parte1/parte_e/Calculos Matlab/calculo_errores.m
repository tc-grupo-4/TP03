M = csvread('montecarlo_mag.csv');
P = csvread('montecarlo_phase.csv');
[rows cols] = size(M);
n = 15;
f = M(:,1);
mag = M(:,2:n);
phase = P(:,2:n);


R = 3.3e3;
R6 = 13.2e3;
C = 23.48e-9;

H = 2*tf([1/(R6*C) 0],[1 1/(R6*C) 1/(R^2*C^2)]);
w_exp = 2*pi*f;
[mag_teo,phase_teo] = bode(H, w_exp);
mag_teo = squeeze(mag_teo);
mag_teo_db = 20*log10(mag_teo);
phase_teo = squeeze(phase_teo);

f0_teo = 1/(2*pi*R*C);

% busco las frecuencias f0 de todas las curvas.

[max_mags,max_mags_indexes] = max(mag);
f0_list = f(max_mags_indexes);
f0_max = max(f0_list);
f0_min = min(f0_list);

error_f0_max = abs(f0_teo - f0_max)
error_f0_min = abs(f0_teo - f0_min)

error_f0_max_porc = abs(f0_teo - f0_max)/f0_teo*100
error_f0_min_porc = abs(f0_teo - f0_min)/f0_teo*100



