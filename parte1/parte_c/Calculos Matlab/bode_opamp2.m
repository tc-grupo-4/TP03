H = @(w) -j*w./(2.5e-8*(j*w).^3 + 7.5e-5*(j*w).^2 + 4*(j*w));
f = logspace(1,6,1000);
mag = abs(H(2*pi*f));


x0=10;
y0=10;
width=550;
height=300;
set(gcf,'units','points','position',[x0,y0,width,height])
semilogx(f,20*log(mag));
legend({'Transferencia operacional 2'}, 'Interpreter', 'latex')
ylabel('$|H(f)|$','Interpreter', 'latex');
xlabel('$f[Hz]$', 'Interpreter', 'latex');
set(gca,'TickLabelInterpreter','latex');
grid minor
print -dpdf 'bode_segundo_opamp.pdf'