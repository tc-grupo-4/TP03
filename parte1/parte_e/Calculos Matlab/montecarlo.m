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

x0=10;
y0=10;
width=550;
height=300;
set(gcf,'units','points','position',[x0,y0,width,height])


semilogx(f,mag);
ylabel('$|H(f)|[dB]$','Interpreter', 'latex');
xlabel('$f[Hz]$', 'Interpreter', 'latex');
set(gca,'TickLabelInterpreter','latex');
xlim([1e3 1e4])
grid minor

print -dpdf 'montecarlo_mag.pdf'

semilogx(f,phase);
ylabel('$\theta (f)[grad]$','Interpreter', 'latex');
xlabel('$f[Hz]$', 'Interpreter', 'latex');
set(gca,'TickLabelInterpreter','latex');
xlim([1e3 1e4])
grid minor

print -dpdf 'montecarlo_phase.pdf'