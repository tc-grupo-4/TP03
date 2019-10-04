clear all 
clc
f_pos = @(Q) 1./(2*Q).*(-1+sqrt(1-4*Q.^2));
f_neg = @(Q) 1./(2*Q).*(-1-sqrt(1-4*Q.^2));

q2 = [3.6 4 4.4]';
q2_legend = {'$Q_{min}$', '$Q_{central}$', '$Q_{max}$'};

poles_2_p = f_pos(q2);
poles_2_n = f_neg(q2);
poles_2 = [poles_2_p,poles_2_n];

for k=1:length(poles_2)
    polarplot(poles_2(k,:), '*');
    hold on
end
hold off
legend(q2_legend, 'Interpreter', 'Latex');
set(gca,'TickLabelInterpreter','latex');
set(gca, 'RTick', [0 1 2]);
set(gca, 'RTickLabel',{0,'$\omega_0$','2$\omega_0$'});
print -dpdf 'polos_Q_sens.pdf'