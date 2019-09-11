i = 1;
while( i<=4 )
    switch(i)
        case 1
           outputString = 'HP';
        case 2
           outputString = 'BR';
        case 3
           outputString = 'BP';
        case 4
           outputString = 'LP';
    end
    
    outputStringCSV = sprintf('%s.csv', outputString);
    if(  outputString == 'LP')
                bode_medido = csvread('resultado.csv');

%         cap_plus = csvread('LPp.csv');
%         cap_min  = csvread('LPm.csv');
%         cap_min(1:52,2) = 0;
%         cap_min(1:52,3) = 0;
%         bode_medido(:,1) = cap_plus(:,1); %Frecuencias
%         
%         for i = 1:length(cap_min(:,1))
%             
%             %(i,2)
%             %cap_plus(i,3)
%             [xplus , yplus] =  pol2cart(deg2rad(cap_plus(i,3)),cap_plus(i,2));
%             [xmin , ymin] =  pol2cart(deg2rad(cap_min(i,3)),cap_min(i,2));
%             xres = xplus - xmin;
%             yres = yplus - ymin;
%             [th,modulo] = cart2pol(xres,yres);
%             
%             bode_medido(i,2) = modulo;
%             bode_medido(i,3) = rad2deg(th);
%             
%             
%             
%         end
%         csvwrite('resultado.csv',bode_medido);

        
    else
        bode_medido = csvread(outputStringCSV);
    end
    
    outputStringBobina = sprintf('%s_BOBINA.txt', outputString);
    outputStringGyrator = sprintf('%s_GYRATOR.txt', outputString);

    [data_simulado_bobina,label,units] = LTspiceBodeSimulationLoader(outputStringBobina);
    [data_simulado_gyrator,label,units] = LTspiceBodeSimulationLoader(outputStringGyrator);

    %if(outputString == 'LP')
        
        
    figure
    semilogx(data_simulado_bobina(1,:), data_simulado_bobina(2,:));
    hold
    semilogx(data_simulado_gyrator(1,:), data_simulado_gyrator(2,:));
    semilogx(bode_medido(:,1),20*log10(bode_medido(:,2)));

    
    xlim([1e2, 1e6]);
    grid on;
    % Create xlabel
    xlabel({'Frecuencia(Hz)'});
    % Create ylabel
    ylabel({'Magnitud(dB)'});
    % Create title
    outputStringTitle = sprintf('Ganancia Del Filtro %s',outputString);
    title({outputStringTitle});
    % Create legend
    legend('Valor Simulado Bobibina','Valor Simulado Gyrator','Valor Medido Gyrator','Location','Southwest');
   
    %fase
    
    figure
    semilogx(data_simulado_bobina(1,:), data_simulado_bobina(3,:));
    hold 
    semilogx(data_simulado_gyrator(1,:), data_simulado_gyrator(3,:));
    semilogx(bode_medido(:,1),bode_medido(:,3));
    
    xlim([1e1, 1e7]);
	grid on;
    % Create xlabel
    xlabel({'Frecuencia(Hz)'});
    % Create ylabel
    ylabel({'Grados(°)'});
    % Create title
    outputString = sprintf('Fase Del Filtro %s',outputString);
    title({outputString});
    % Create legend
    legend('Valor Simulado Bobibina','Valor Simulado Gyrator','Valor Medido Gyrator','Location','Southwest');
    
    i = i +1;
end 
    