clear;
load('./datos.mat')

ACM=(1+R4/R3)*(1-(1+R2/R1)/(1+R3/R4));
ACMi=1-R4/R3*R2/R1;
ADM=0.5*(1+R4/R3)*(1+(1+R2/R1)/(1+R3/R4));
ADMi=R4/R3+0.5*(1+R4/R3*R2/R1);

CMRR=10*log10(ADM/ACM);

VDMoff=0.073;

ADMv=VDMout./VDMin;
ADMvoff=(VDMout-VDMoff)./VDMin;
ADMavg=mean(ADMv);
ADMavgoff=mean(ADMvoff);

CMRRv=10*log10(ADMavg/ACM);
CMRRvoff=10*log10(ADMavgoff/ACM);

f=fit(P,Voutmed,'poly1');

Psim=VDMSim*10/25e-3;

h=figure('Name','Resultados');
h=subplot(1,2,1);

hold on
scatter(P,Voutmed,'b');
plot(f,'b');
plot(Psim,VoutSim,'r');
hold off

grid on
xlabel('Presión [kPa]');
ylabel('Vout [V]');
title('Resultados');
axis([0 10 0 3.5]);
legend('Medición','Tendencia','Simulación','Location','northwest');

h=subplot(1,2,2);

hold on
scatter(P,Voutmed,'b');
plot(f,'b');
plot(Psim,VoutSim,'r');
hold off

grid on
xlabel('Presión [kPa]');
ylabel('Vout [V]');
title('Resultados (ampliado)');
axis([9 10 3.1 3.3]);
legend('Medición','Tendencia','Simulación','Location','northwest');



