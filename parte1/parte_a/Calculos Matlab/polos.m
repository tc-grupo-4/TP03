clear all
clc
f_pos = @(Q) 1./(2*Q).*(-1+sqrt(1-4*Q.^2));
f_neg = @(Q) 1./(2*Q).*(-1-sqrt(1-4*Q.^2));
q1 = [0.2 0.3 0.4 0.45]';
q1_legend = {'$R_6 = 0.2R$','$R_6 = 0.3R$','$R_6 = 0.4R$','$R_6 = 0.45R$'};
q2 = [0.51 0.6 0.75 1 2 4]';
q2_legend = {'$R_6 = 0.51R$','$R_6 = 0.6R$','$R_6 = 0.7R$','$R_6 = R$','$R_6 = 2R$','$R_6 = 4R$'};
q3 = 0.5;
q3_legend = {'$R_6 = 0.5R$'};

poles_1_p = f_pos(q1);
poles_1_n = f_neg(q1);
poles_1 = [poles_1_p,poles_1_n];

poles_2_p = f_pos(q2);
poles_2_n = f_neg(q2);
poles_2 = [poles_2_p,poles_2_n];

poles_3_p = f_pos(q3);
poles_3_n = f_neg(q3);
poles_3 = [poles_3_p,poles_3_n];

for k=1:length(poles_1)
    polarplot(poles_1(k,:), '*');
    hold on
end
hold off
legend(q1_legend, 'Interpreter', 'Latex');
set(gca,'TickLabelInterpreter','latex');
set(gca, 'RTick', [0 2 4 6 8 10]);
set(gca, 'RTickLabel',{0,'2$\omega_0$','4$\omega_0$','6$\omega_0$','8$\omega_0$','10$\omega_0$'});
print -dpdf 'polos_reales.pdf'


for k=1:length(poles_2)
    polarplot(poles_2(k,:), '*');
    hold on
end
hold off
legend(q2_legend, 'Interpreter', 'Latex');
set(gca,'TickLabelInterpreter','latex');
set(gca, 'RTick', [0 1 2]);
set(gca, 'RTickLabel',{0,'$\omega_0$','2$\omega_0$'});
print -dpdf 'polos_complejos.pdf'

polarplot(poles_3, '*');
legend(q3_legend, 'Interpreter', 'Latex');
set(gca,'TickLabelInterpreter','latex');
set(gca, 'RTick', [0 1 2]);
set(gca, 'RTickLabel',{0,'$\omega_0$','2$\omega_0$'});
print -dpdf 'polo_doble.pdf'


