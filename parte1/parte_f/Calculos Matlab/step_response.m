R = 3.3e3;
R6 = 13.2e3;
C = 23.48e-9;

H = 2*tf([1/(R6*C) 0],[1 1/(R6*C) 1/(R^2*C^2)]);

t1 = linspace(0, 4e-3,1000);
t1_mili = t1/1e-3;
t2 = linspace(-1e-3, t1(end), 1000);
t2_mili = t2/1e-3;

y = step(H,t1);
u = heaviside(t2);

med = csvread('Medicion_step.csv',2);
t_exp = med(:,1);
t_exp_mili = t_exp/1e-3;
vin_exp = med(:,2);
vout_exp = med(:,3);

x0=10;
y0=10;
width=550;
height=300;
set(gcf,'units','points','position',[x0,y0,width,height])

sim = csvread('Simulacion__step.csv',2);
t_sim = sim(:,1);
t_sim_mili = t_sim/1e-3;
vout_sim = sim(:,3);

plot(t1_mili,y,t_sim_mili,vout_sim,t_exp_mili,vout_exp,t2_mili,u);
xlabel('$t[mseg]$', 'Interpreter', 'latex');
ylabel('$v_{out}[V]$','Interpreter', 'latex');
set(gca,'TickLabelInterpreter','latex');
legend({'Calulado','Simulado','Medido'}, 'Interpreter', 'latex')
axis([-1 3.5 -0.4 1.2])
grid minor

print -dpdf 'step_response.pdf'