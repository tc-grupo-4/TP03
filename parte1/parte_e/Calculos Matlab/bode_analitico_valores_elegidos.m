%Cargo archivo de simulacion
S = csvread('Simulacion_bode.csv',2);
f_s = S(:,1);
mag_s_db = S(:,2);
phase_s = S(:,3);

% cargo el archivo de medición
M = csvread('bode.csv',2);
f_exp = M(:,1);
w_exp = 2*pi*f_exp;
mag_exp_db = M(:,2);
phase_exp = M(:,3);

R = 3.3e3;
R6 = 13.2e3;
C = 23.48e-9;

H = 2*tf([1/(R6*C) 0],[1 1/(R6*C) 1/(R^2*C^2)]);

[mag_teo,phase_teo] = bode(H, w_exp);
mag_teo = squeeze(mag_teo);
mag_teo_db = 20*log10(mag_teo);
phase_teo = squeeze(phase_teo);

x0=10;
y0=10;
width=550;
height=300;
set(gcf,'units','points','position',[x0,y0,width,height])

yyaxis left
semilogx(f_exp,mag_teo_db,'-r',f_exp,mag_exp_db,'-g',f_s,mag_s_db,'-b');
ylabel('$|H(f)|[dB]$','Interpreter', 'latex');
yyaxis right
semilogx(f_exp,phase_teo,'--r',f_exp,phase_exp,'--g',f_s,phase_s,'--b');
ylabel('$\theta (f)[grad]$','Interpreter', 'latex');
xlabel('$f[Hz]$', 'Interpreter', 'latex');
set(gca,'TickLabelInterpreter','latex');
legend({'Teorico','Experimental','Simulado'}, 'Interpreter', 'latex')
axis auto
grid minor

print -dpdf 'bode_todos.pdf'

yyaxis left
semilogx(f_exp,mag_teo_db,'-r',f_exp,mag_exp_db,'-g',f_s,mag_s_db,'-b');
ylabel('$|H(f)|[dB]$','Interpreter', 'latex');
axis([3e2 1e4 -25 10])
yyaxis right
semilogx(f_exp,phase_teo,'--r',f_exp,phase_exp,'--g',f_s,phase_s,'--b');
ylabel('$\theta (f)[grad]$','Interpreter', 'latex');
axis([3e2 1e4 -91 90])
xlabel('$f[Hz]$', 'Interpreter', 'latex');
set(gca,'TickLabelInterpreter','latex');
legend({'Teorico','Experimental','Simulado'}, 'Interpreter', 'latex')

print -dpdf 'bode_todos_closeup.pdf'
