H = @(w) 6500*j*w./((j*w).^2 + 3250*j*w + 1.69e08);
f = logspace(3.2,3.5,1000);
mag = abs(H(2*pi*f));

SR_TL082 = 13/1e-6;
VSAT_TL082 = 13;

x0=10;
y0=10;
width=550;
height=300;
set(gcf,'units','points','position',[x0,y0,width,height])

vin_max_sat_TL082 = VSAT_TL082./(mag);
vin_max_sr_TL082 = SR_TL082./(mag.*(2*pi*f));

semilogx(f, vin_max_sat_TL082,f, vin_max_sr_TL082);
legend({'Saturacion','Slew Rate'}, 'Interpreter', 'latex')
ylabel('$V_{in}[V]$','Interpreter', 'latex');
xlabel('$f[Hz]$', 'Interpreter', 'latex');
set(gca,'TickLabelInterpreter','latex');
grid minor

print -dpdf 'vin_max_sr_sat_TL082.pdf'