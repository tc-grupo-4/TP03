clear all
close all
% cargo medicion
Zin = csvread('Z_in.csv');
f_exp = Zin(:,1);
% las tengo en kohm
mag_exp = Zin(:,2);
phase_exp = Zin(:,3);

%teorica
R6 = 13.2e3;
C = 23.48e-9;
R = 3.3e3;
f = logspace(1,5,5000);
w = 2*pi*f_exp;

Zin = tf([R6*R^2*C^2 R^2*C R6],[R^2*C^2 0 1]);

[mag_teo,phase_teo] = bode(Zin,w);

% paso a kohm
mag_teo = squeeze(mag_teo)/1e3;
phase_teo = squeeze(phase_teo);

x0=10;
y0=10;
width=550;
height=300;
set(gcf,'units','points','position',[x0,y0,width,height])

semilogx(f_exp,mag_teo,'-r',f_exp,mag_exp,'-b');
ylabel('$|Z_{in}(f)|[k\Omega]$','Interpreter', 'latex');
xlabel('$f[Hz]$', 'Interpreter', 'latex');
set(gca,'TickLabelInterpreter','latex');
legend({'Teorico','Experimental'}, 'Interpreter', 'latex')
grid minor

print -dpdf 'impedancia_exp_teo_mag.pdf'

semilogx(f_exp,phase_teo,'--r',f_exp,phase_exp,'--b');
ylabel('$\theta (f)[grad]$','Interpreter', 'latex');
xlabel('$f[Hz]$', 'Interpreter', 'latex');
set(gca,'TickLabelInterpreter','latex');
legend({'Teorico','Experimental'}, 'Interpreter', 'latex')
grid minor

print -dpdf 'impedancia_exp_teo_phase.pdf'