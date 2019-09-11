R1=10e3;
R3=10e3;
R8=10e3;
R6=20930;
R7=80000;
R4=4150;
R5=7090;
C2=3.9e-9;
C6=3.9e-9;

%%diagrama de polos y ceros generico


zplane([(R1*R3*C2*((R5*R7-R6*R8)*R4-R5*R6*R8)+((R1*R3*R4*C2*(R5*R7-R6*R8)-R1*R3*R5*R6*R8*C2)^(2)-4*R1*R3*R4*R5*(R6^2)*(R7^2)*R8*C2*C6*(R4+R5))/(2*R1*R3*R6*R7*R8*C2*C6*(R4+R5))),(R1*R3*C2*((R5*R7-R6*R8)*R4-R5*R6*R8)-((R1*R3*R4*C2*(R5*R7-R6*R8)-R1*R3*R5*R6*R8*C2)^(2)-4*R1*R3*R4*R5*(R6^2)*(R7^2)*R8*C2*C6*(R4+R5))/(2*R1*R3*R6*R7*R8*C2*C6*(R4+R5)))]',[(-R1*R3*R5*R8*C2*(R6+R7)+((R5*R1*R3*R5*R8*C2*(R6+R7))^(2)-4*R1*R3*R4*(R6^2)*(R7^2)*R8*C2*C6*(R8+R5)))/(2*R1*R3*R5*R6*R7*R8*C2*C6),(-R1*R3*R5*R8*C2*(R6+R7)-((R5*R1*R3*R5*R8*C2*(R6+R7))^(2)-4*R1*R3*R4*(R6^2)*(R7^2)*R8*C2*C6*(R8+R5)))/(2*R1*R3*R5*R6*R7*R8*C2*C6)]');



title('Diagrama de Polos y Ceros');
xlabel('Parte Real');
ylabel('Parte Imaginaria');
grid on;


figure;
s=tf('s');

H=(R5/(R5+R8))*(s*s*(C2*C6*R1*R3*R8*((1/R5)+(1/R4)))+s*C2*R1*R3*(R8/(R5*R7)-1/(R6)+R8/(R4*R7))+1)/(s*s*(C2*C6*R1*R3*R5*R8/(R4*(R5+R8)))+s*C2*R1*R3*R5*R8*(1/(R4+R7)+1/(R4*R6))/(R5+R8)+1);


[mag,phase,wout]=bode(H,{1*2*pi,10e6*2*pi});
% semilogx(wout/(2*pi),20*log10(squeeze(mag(1,1,:))));
% title('Amplitud del Bode Teórico');
% xlabel('Frecuencia (Hz)');
% ylabel('Amplitud (dB)');
% grid on;
% 
% figure;
% 
% 
% semilogx(wout/(2*pi),squeeze(phase(1,1,:)));
% title('Fase del Bode Teórico');
% xlabel('Frecuencia (Hz)');
% ylabel('Grados (°)');
% grid on;



%% simulado


bodeSimulado=csvread('bode_simu.csv');
semilogx(bodeSimulado(:,1),bodeSimulado(:,2),'-');
grid on
title('Amplitud del Bode Simulado en LTSpice');

xlabel('Frecuencia (Hz)');
ylabel('Amplitud (dB)');

figure;

semilogx(bodeSimulado(:,1),bodeSimulado(:,3),'-');
grid on
title('Fase del Bode Simulado en LTSpice');

xlabel('Frecuencia (Hz)');
ylabel('Grados (°)');

figure;


%%%%comparacion

semilogx(wout/(2*pi),20*log10(squeeze(mag(1,1,:))),bodeSimulado(:,1),bodeSimulado(:,2),'-');
title('Amplitud del Bode Teórico vs. Simulado');
xlabel('Frecuencia (Hz)');
ylabel('Amplitud (dB)');
grid on;

figure;

semilogx(wout/(2*pi),squeeze(phase(1,1,:)),bodeSimulado(:,1),bodeSimulado(:,3),'-');
title('Fase del Bode Teórico vs. Simulado');
xlabel('Frecuencia (Hz)');
ylabel('Grados (°)');
grid on;



%%medido

% figure
% 
% bodeMedido=xlsread('datos_bode_derivador1',1);
% 
% semilogx(bodeMedido(:,1),bodeMedido(:,2),'-');
% grid on
% title('Amplitud del Bode Medido');
% 
% xlabel('Frecuencia (Hz)');
% ylabel('Amplitud (dB)');
% 
% figure;



% semilogx(bodeMedido(:,1),bodeMedido(:,3),'-');
% grid on
% title('Fase del Bode Medido');
% 
% xlabel('Frecuencia (Hz)');
% ylabel('Grados (°)');
% 

%%comparacion
% 
% figure;
% 
% 
% [mag,phase,wout]=bode(derPolo,{1*2*pi,10000000*2*pi});
% 
% semilogx(wout/(2*pi),20*log10(squeeze(mag(1,1,:))),bodeSimulado(:,1),bodeSimulado(:,2),'-',bodeMedido(:,1),bodeMedido(:,2),'-');
% title('Amplitud del Bode Teórico vs. Simulado vs. Medido');
% xlabel('Frecuencia (Hz)');
% ylabel('Amplitud (dB)');
% grid on;

% figure;

% semilogx(wout/(2*pi),squeeze(phase(1,1,:)),bodeSimulado(:,1),bodeSimulado(:,3),'-',bodeMedido(:,1),bodeMedido(:,3),'-');
% title('Fase del Bode Teórico vs. Simulado vs. Medido');
% xlabel('Frecuencia (Hz)');
% ylabel('Grados (°)');
% grid on;
% 
