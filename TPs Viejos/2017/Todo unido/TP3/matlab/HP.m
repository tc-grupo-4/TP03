s = tf('s');
func_plot = 1/( (s/(2*pi *1.5 ) +1 )*(s/(2*pi*2.75)+1) );
func_plot_2 = 1/( (s/(2*pi *1.75) +1 )*(s/(2*pi*2.50)+1) );


 [Mag, phase, W] = bode(func_plot,{0.001 * 2*pi, 1e7 * 2*pi}); %REVISAR RANGOS QUE QUEDE BIEN GRAFICO
 [Mag2, phase, W] = bode(func_plot_2,{0.001 * 2*pi, 1e7 * 2*pi}); %REVISAR RANGOS QUE QUEDE BIEN GRAFICO

      figure
     semilogx(W(:,1)./(2*pi),20*log10(Mag(:)));
     hold
     semilogx(W(:,1)./(2*pi),20*log10(Mag2(:)));
     

    xlim([0.1, 10]);
    ylim([-15, 0]);
    grid on;
    % Create xlabel
    xlabel({'Frecuencia(Hz)'});
    % Create ylabel
    ylabel({'Magnitud(dB)'});
    %
    %set(gca,'XMinorTick','on','XScale','log','XTick',[0.1 1 3.5 10],...
    %'XTickLabel',{'0.1','1','3.5','10'},'YTick',[-30 -25 -20 -15 -10 -5 -3 0],...
   % 'YTickLabel',{'-30','-25','-20','-15','-10','-5','-3','0'});
    legend('Prueba Polos 1.5 y 2.75','Prueba Polos 1.75 y 2.5')
    
    set(gca, 'YDir', 'reverse');


    func_plot = 1/( (1000/s*(2*pi *1.1) +1)*(1000/s*(2*pi*1.57)+1) );
func_plot_2 = 1/( (1000/s*(2*pi *1.75) +1 )*(1000/s*(2*pi*2.50)+1) );

%Desnormalizado
 [Mag, phase, W] = bode(func_plot,{0.001 * 2*pi, 1e7 * 2*pi}); %REVISAR RANGOS QUE QUEDE BIEN GRAFICO
 [Mag2, phase, W] = bode(func_plot_2,{0.001 * 2*pi, 1e7 * 2*pi}); %REVISAR RANGOS QUE QUEDE BIEN GRAFICO

      figure
     semilogx(W(:,1)./(2*pi),20*log10(Mag(:)));
     hold
     semilogx(W(:,1)./(2*pi),20*log10(Mag2(:)));

    xlim([100, 10000]);
    ylim([-10, 0]);
    grid on;
    % Create xlabel
    xlabel({'Frecuencia(Hz)'});
    % Create ylabel
    ylabel({'Magnitud(dB)'});
    %
   % set(gca,'XMinorTick','on','XScale','log','XTick',[0.1 1 3.5 10],...
   % 'XTickLabel',{'0.1','1','3.5','10'},'YTick',[-30 -25 -20 -15 -10 -5 -3 0],...
    %'YTickLabel',{'-30','-25','-20','-15','-10','-5','-3','0'});
    legend('Prueba Polos 1.5 y 2.75','Prueba Polos 1.75 y 2.5')