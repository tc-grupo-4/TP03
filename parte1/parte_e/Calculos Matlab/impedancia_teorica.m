R6 = 13.2e3;
C = 23.48e-9;
R = 3.3e3;
f = logspace(1,5,5000);
w = 2*pi*f;

Zin = tf([R6*R^2*C^2 R^2*C R6],[R^2*C^2 0 1]);

[Zin_mag,Zin_phase] = bode(Zin,w);

Zin_mag = squeeze(Zin_mag)/1e6;
Zin_phase = squeeze(Zin_phase);
f = w./(2*pi);

x0=10;
y0=10;
width=550;
height=300;
set(gcf,'units','points','position',[x0,y0,width,height])

semilogx(f,Zin_mag);
ylabel('$|Z_{in}(f)|[M\Omega]$','Interpreter', 'latex');

