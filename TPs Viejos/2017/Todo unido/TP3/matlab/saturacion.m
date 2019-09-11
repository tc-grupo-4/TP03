datos_saturacion=csvread('saut.csv');
plot(datos_saturacion(:,1),datos_saturacion(:,2),datos_saturacion(:,1),datos_saturacion(:,3));
title('Efectos de Saturación');
xlabel('Tiempo (s)');
ylabel('Tension (V)')
grid on;