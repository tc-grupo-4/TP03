H = @(w) 6500*j*w./((j*w).^2 + 3250*j*w + 1.69e08);
f = logspace(3,4,1000);
mag = abs(H(2*pi*f));

SR_LM741 = 0.5/1e-6;
SR_TL082 = 13/1e-6;
SR_LM833 = 7/1e-6;

vin_max_LM741 = SR_LM741./(mag.*(2*pi*f));
vin_max_TL082 = SR_TL082./(mag.*(2*pi*f));
vin_max_LM833 = SR_LM833./(mag.*(2*pi*f));

x0=10;
y0=10;
width=550;
height=300;
set(gcf,'units','points','position',[x0,y0,width,height])

semilogx(f, vin_max_LM741,f,vin_max_TL082,f,vin_max_LM833);
legend({'$LM741$','$TL082$','$LM833$'}, 'Interpreter', 'latex')
ylabel('$V_{in}[V]$','Interpreter', 'latex');
xlabel('$f[Hz]$', 'Interpreter', 'latex');
set(gca,'TickLabelInterpreter','latex');
grid minor

print -dpdf 'vin_max_todos.pdf'
