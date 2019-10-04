H = @(w) 6500*j*w./((j*w).^2 + 3250*j*w + 1.69e08);
f = logspace(3,5,1000);
mag = abs(H(2*pi*f));
phase = radtodeg(angle(H(2*pi*f)));


x0=10;
y0=10;
width=550;
height=300;
set(gcf,'units','points','position',[x0,y0,width,height])

yyaxis left
semilogx(f, 20*log(mag));
ylabel('$|H(f)|[dB]$','Interpreter', 'latex');
yyaxis right
semilogx(f, phase);
ylabel('$\theta (f)[grad]$','Interpreter', 'latex');
xlabel('$f[Hz]$', 'Interpreter', 'latex');
set(gca,'TickLabelInterpreter','latex');
legend({'Magnitud','Fase'}, 'Interpreter', 'latex')
grid minor

print -dpdf 'bode_analitico_filtro.pdf'

