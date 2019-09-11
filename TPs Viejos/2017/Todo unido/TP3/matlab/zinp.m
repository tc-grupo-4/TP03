R1=10e3;
R3=10e3;
R8=10e3;
R6=21060;
R7=80000;
R4=3997;
R5=7200;
C2=3.9e-9;
C6=3.9e-9;

s=tf('s');

H= (R7+R8)*(s*s*C2*C6*R1*R3*R5*R7*R8/(R4*R6*(R7+R8))+s*(C2*R1*R3*R5*(R7+R8)+C6*R4*R6*R7*R8)/(R4*R6*(R7+R8))+1)/((R7*(R5+R8))*(s*s*C2*C6*R1*R3*R5*R6*R8/(R4*R6*(R5+R8))+s*C2*R1*R3*R5*R8*(R6+R7)/(R4*R6*R7*(R5+R8))+1));
H=H^-1;


[mag,phase,wout]=bode(H,{1*2*pi,10e6*2*pi});
% semilogx(wout/(2*pi),squeeze(mag(1,1,:)));
% title('Amplitud de la Impedancia de Entrada Teórica');
% xlabel('Frecuencia (Hz)');
% ylabel('|Z| (Ohm)');
% grid on;
% 
% figure;
% 
% 
% semilogx(wout/(2*pi),squeeze(phase(1,1,:)));
% title('Fase de la Impedancia de Entrada Teórica');
% xlabel('Frecuencia (Hz)');
% ylabel('Grados (°)');
% grid on;
% 
% figure;


%% simulado
% 
% 
bodeSimulado=csvread('impedancia_ent.csv');
% semilogx(bodeSimulado(:,1),10.^(bodeSimulado(:,2)./20),'-');
% grid on
% title('Amplitud de la Impedancia de Entrada Simulada en LTSpice');
% 
% xlabel('Frecuencia (Hz)');
% ylabel('|Z| (Ohm)');
% 
% figure;
% 
% semilogx(bodeSimulado(:,1),bodeSimulado(:,3),'-');
% grid on
% title('Fase de la Impedancia de Entrada Simulada en LTSpice');
% 
% xlabel('Frecuencia (Hz)');
% ylabel('Grados (°)');

% figure;


%%%%comparacion

% semilogx(wout/(2*pi),squeeze(mag(1,1,:)),bodeSimulado(:,1),10.^(bodeSimulado(:,2)./20),'-');
% title('Amplitud de la Impedancia de Entrada Teórica vs. Simulada');
% xlabel('Frecuencia (Hz)');
% ylabel('|Z| (Ohm)');
% grid on;
% 
% figure;
% 
% semilogx(wout/(2*pi),squeeze(phase(1,1,:)),bodeSimulado(:,1),bodeSimulado(:,3),'-');
% title('Fase de la Impedancia de Entrada Teórica vs. Simulada');
% xlabel('Frecuencia (Hz)');
% ylabel('Grados (°)');
% grid on;



%%medido

figure

bodeMedido=xlsread('zinp_medida.xlsx',1);
bodeMedido=csvread('medido_zinp.csv');

semilogx(bodeMedido(:,1),bodeMedido(:,2),'-');
grid on
title('Amplitud de la Impedancia de Entrada Medida');

xlabel('Frecuencia (Hz)');
ylabel('|Z| (Ohm)');

figure;



semilogx(bodeMedido(:,1),bodeMedido(:,3),'-');
grid on
title('Fase de la Impedancia de Entrada Medida');

xlabel('Frecuencia (Hz)');
ylabel('Grados (°)');


%comparacion

figure;


[mag,phase,wout]=bode(H,{1*2*pi,10000000*2*pi});

semilogx(wout/(2*pi),squeeze(mag(1,1,:)),bodeSimulado(:,1),10.^(bodeSimulado(:,2)./20),'-',bodeMedido(:,1),bodeMedido(:,2),'-');
title('Amplitud de la Impedancia de Entrada Teórica vs. Simulada vs. Medida');
xlabel('Frecuencia (Hz)');
ylabel('|Z| (Ohm)');
grid on;

figure;

semilogx(wout/(2*pi),squeeze(phase(1,1,:)),bodeSimulado(:,1),bodeSimulado(:,3),'-',bodeMedido(:,1),bodeMedido(:,3),'-');
title('Fase de la Impedancia de Entrada Teórica vs. Simulada vs. Medida');
xlabel('Frecuencia (Hz)');
ylabel('Grados (°)');
grid on;

