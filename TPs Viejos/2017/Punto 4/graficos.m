
semilogx(f7,10.^(r7/20),'red')
hold on
semilogx(f9,r9,'x')
xlabel 'Freq (Hz)'
ylabel 'Magnitude (ohm)'
legend ('simulado','medido')
