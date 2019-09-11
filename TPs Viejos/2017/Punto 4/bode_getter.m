classdef bode_getter < handle
    
    properties
        %Value restrctions
        MAX_FREQ=10000000;
        MIN_FREQ=10;
        MIN_VOLT=0.05;
        MAX_VOLT=10;
        MAX_POINTS=1000;
        MIN_POINTS=10;
        MAX_TIMES=100;
        MIN_TIMES=0.01;
        MAX_R=10e6;
        MIN_R=1;
        
        PAUSE=0.2;
        
        
        gui;
        handles;
        start_freq;
        stop_freq;
        vpp;
        ppd;
        r;
    end
    
    methods
        function self = bode_getter()
            self.gui = hgload('bode_getter.fig');
            self.handles = guihandles(self.gui);
            movegui(self.gui,'center');
            
            set(self.handles.fg_start_freq,'Callback',@self.fg_start_freq_cb);
            set(self.handles.fg_stop_freq,'Callback',@self.fg_stop_freq_cb);
            set(self.handles.fg_vpp,'Callback',@self.fg_vpp_cb);
            set(self.handles.fg_ppd,'Callback',@self.fg_ppd_cb);
            set(self.handles.bode_gain,'Callback',@self.bode_gain_cb);
            set(self.handles.bode_at,'Callback',@self.bode_at_cb);
            set(self.handles.bode_times,'Callback',@self.bode_times_cb);
            set(self.handles.bode_db,'Callback',@self.bode_db_cb);
            set(self.handles.bode_plot,'Callback',@self.bode_plot_cb);
            set(self.handles.zinp_r,'Callback',@self.zinp_r_cb);
            set(self.handles.zinp_plot,'Callback',@self.zinp_plot_cb);
            set(self.handles.exportar,'Callback',@self.exportar);
            self.start_freq=10;
            self.stop_freq=100;
            self.vpp=1;
            self.ppd=10;
            self.r=1;
            return;
        end
        function self=zinp_r_cb(self,varargin)
            try
                self.r=str2num(get(self.handles.zinp_r,'string'));
            catch
                errordlg('Invalid Number','Error in R Test');
                set(self.handles.zinp_r,'String','1');
                self.r=1;
            end
            if((self.r<self.MIN_R) || (self.r>self.MAX_R))
                errordlg(['Must be in range ' num2str(self.MIN_R) ' to ' num2str(self.MAX_R)],'Error in R Test');
                set(self.handles.zinp_r,'String','1');
                self.r=1;
            end
        end
        function self=fg_start_freq_cb(self,varargin)
            self.start_freq=0;
            try
                self.start_freq=str2num(get(self.handles.fg_start_freq,'String'));
            catch
                errordlg('Invalid Number','Error in Start Freq');
                set(self.handles.fg_start_freq,'String','10');
                self.start_freq=10;
                return;
            end
            if((self.start_freq<self.MIN_FREQ)||(self.start_freq>(self.MAX_FREQ/10)))
                errordlg(['Must be in range ' num2str(self.MIN_FREQ) ' to ' num2str(self.MAX_FREQ/10)],'Error in Start Freq');
                set(self.handles.fg_start_freq,'String','10');
                self.start_freq=10;
                return;
            end
            if(self.start_freq>=self.stop_freq)
                errordlg('Must be lower than Stop Freq','Error in Start Freq');
                set(self.handles.fg_start_freq,'String','10');
                self.start_freq=10;
            end
            return ;
        end
        function self=fg_stop_freq_cb(self,varargin)
            self.stop_freq=0;
            try
                self.stop_freq=str2num(get(self.handles.fg_stop_freq,'String'));
            catch
                errordlg('Invalid Number','Error in Stop Freq');
                set(self.handles.fg_stop_freq,'String',num2str(10*self.fg_start_freq));
                self.stop_freq=10*self.fg_start_freq;
                return;
            end
            if((self.stop_freq<(self.MIN_FREQ*10))||(self.stop_freq>self.MAX_FREQ))
                errordlg(['Must be in range ' num2str(self.MIN_FREQ*10) ' to ' num2str(self.MAX_FREQ)],'Error in Stop Freq');
                set(self.handles.fg_stop_freq,'String',num2str(10*self.fg_start_freq));
                self.stop_freq=10*self.fg_start_freq;
                return;
            end
            if(self.start_freq>=self.stop_freq)
                errordlg('Must be higher than Start Freq','Error in Stop Freq');
                set(self.handles.fg_stop_freq,'String',num2str(10*self.fg_start_freq));
                self.stop_freq=10*self.fg_start_freq;
            end
            return ;
        end
        function self=fg_vpp_cb(self,varargin)
            self.vpp=0;
            try
                self.vpp=str2num(get(self.handles.fg_vpp,'String'));
            catch
                errordlg('Invalid Number','Error in VPP');
                set(self.handles.fg_vpp,'String','1');
                self.vpp=1;
                return;
            end
            if(self.vpp<self.MIN_VOLT||self.vpp>self.MAX_VOLT)
                errordlg(['Must be in range ' num2str(self.MIN_VOLT) ' to ' num2str(self.MAX_VOLT)],'Error in VPP');
                set(self.handles.fg_vpp,'String','1');
                self.vpp=1;
                return;
            end
            return ;
        end
        function self=fg_ppd_cb(self,varargin)
            self.ppd=0;
            try
                self.ppd=str2num(get(self.handles.fg_ppd,'String'));
            catch
                errordlg('Invalid Number','Error in PPD');
                set(self.handles.fg_ppd,'String','10');
                self.ppd=10;
                return;
            end
            if(self.ppd<self.MIN_POINTS||self.ppd>self.MAX_POINTS)
                errordlg(['Must be in range ' num2str(self.MIN_POINTS) ' to ' num2str(self.MAX_POINTS)],'Error in PPD');
                set(self.handles.fg_ppd,'String','10');
                self.ppd=10;
                return;
            end
            return ;
        end
      
        
        function self=exportar(self,varargin)
            %Si no hay un grafico en la pantalla no hay nada que exportar
            if isequal(get(self.handles.bode_mag_axes,'Visible'),'off')
                errordlg('No hay grafico que exportar','Falta de datos para exportar');
                return;
            end
            %Obtengo el nombre del archivo y el lugar donde el usuario
            %quiere guardar el archivo
            types={'*.fig';'*.png'};
            [fileName,pathName,filterIndex] = uiputfile(types,'Export as png');
            if(isequal(fileName,0) || isequal(pathName,0))
                return;
            end
            saveDataName = fullfile(pathName,fileName);
            %Obtengo la pantalla
            if(filterIndex==2)
                dataFrame = getframe(self.gui);
                [im,imMap] = frame2im(dataFrame);
                %Recorto el grafico
                im=imcrop(im,[360 30 1150-360 560-30]); 
                imwrite(im,saveDataName);
            else
                Fig2 = figure;
                copyobj(self.handles.bode_mag_axes, Fig2);
                copyobj(self.handles.bode_phase_axes, Fig2);
                
                hgsave(Fig2, saveDataName);
            end
                
        end
        function self=salir(self,varargin)
            close(self.gui);
        end
        
        function self=bode_gain_cb(self,varargin)
            %Prendo la opcion de ganancia, y apago la de atenuación
            set(self.handles.bode_gain,'value',1);
            set(self.handles.bode_at,'value',0);
        end
        function self=bode_at_cb(self,varargin)
            %Prendo la opcion de atenuación y apago la de ganancia
            set(self.handles.bode_at,'value',1);
            set(self.handles.bode_gain,'value',0);
        end
        function self=bode_times_cb(self,varargin)
            %Prendo la opción de veces y apago la de decibeles
            set(self.handles.bode_db,'value',0);
            set(self.handles.bode_times,'value',1);
        end
        function self=bode_db_cb(self,varargin)
            %prendo la opción de decibeles y apago la de veces
            set(self.handles.bode_times,'value',0);
            set(self.handles.bode_db,'value',1);
        end
        
        function self=bode_plot_cb(self,varargin)
            Oscilloscope=instrfind('Type', 'visa-usb', 'RsrcName', 'usb0[2391::5925::MY49110441::0]', 'Tag', '');
            Generator=instrfind('Type', 'visa-usb', 'RsrcName', 'usb0[2391::1031::MY44013183::0]', 'Tag', '');
            if isempty(Oscilloscope)
                Oscilloscope=visa('AGILENT', 'USB0::0x0957::0x1725::MY49110441::0::INSTR');

            else
                fclose(Oscilloscope);
                Oscilloscope=Oscilloscope(1);
            end
            if isempty(Generator)
                Generator=visa('AGILENT','USB0::0x0957::0x0407::MY44013183::0::INSTR');

            else
                fclose(Generator);
                Generator=Generator(1);
            end
            fopen(Oscilloscope);
            fopen(Generator);
            csv=fopen('lastMed.csv','w');
            tp=floor(log10(self.stop_freq/self.start_freq)*self.ppd);
            freq=logspace(log10(self.start_freq), log10(self.stop_freq),tp);
            mag=zeros(1,tp);
            phase=zeros(1,tp);
            vpp_in=zeros(1,tp);
            vpp_out=zeros(1,tp);
            in_ch=num2str(get(self.handles.osc_ich,'Value'));
            o_ch=num2str(get(self.handles.osc_och,'Value'));
            fprintf(Oscilloscope, '*RST');
            fprintf(Oscilloscope,':CHAN2:DISP ON');
            fprintf(Oscilloscope, ':ACQ:TYPE AVER');
            fprintf(Oscilloscope, [':TRIG:EDGE:SOUR CHAN' in_ch]);
            fprintf(Oscilloscope, ':TRIG:LEV 0');
            fprintf(Oscilloscope, [':CHAN' in_ch ':SCAL ' num2str(self.vpp/5,10)]);
            fprintf(Oscilloscope, [':CHAN' o_ch ':SCAL ' num2str(self.vpp/5,10)]);
                    
            %Init axes
            cla(self.handles.bode_mag_axes);
            cla(self.handles.bode_phase_axes);
            set(self.handles.bode_mag_axes,'Visible','on');
            set(self.handles.bode_phase_axes,'Visible','on');
            
            
            for n=1:tp
                self.PAUSE=64/freq(n)+0.5;
                %%Frequency set
                fprintf(Generator, ['APPL:SIN ' num2str(freq(n)) ', ' num2str(self.vpp) ', 0']);
        
                %Scale
                fprintf(Oscilloscope, [':TIM:SCAL ' num2str(0.2/freq(n))]);
                
                if(n>1)
                    fprintf(Oscilloscope, [':CHAN' o_ch ':SCAL ' num2str(vpp_out(n-1)/5,10)]);
                    
                end
                pause(self.PAUSE);
                %Data input
                %fprintf(Oscilloscope,':STOP');
                %Vpp Out
                fprintf(Oscilloscope, [':MEAS:VPP? CHAN' o_ch]);
                vpp_out(n)=str2double(fscanf(Oscilloscope));
                %Vpp In
                fprintf(Oscilloscope, [':MEAS:VPP? CHAN' in_ch]);
                vpp_in(n)=str2double(fscanf(Oscilloscope));
                %Phase
                fprintf(Oscilloscope, [':MEAS:PHASE? CHAN' o_ch ',CHAN' in_ch]);
                phase(n)=str2double(fscanf(Oscilloscope));
                
                axes(self.handles.bode_mag_axes);
                if(get(self.handles.bode_gain,'Value')==1)
                    semilogx(freq(1:n),20*log10(vpp_out(1:n)./vpp_in(1:n)));
                else
                    semilogx(freq,(vpp_out(1:n)./vpp_in(1:n)));
                end
                axes(self.handles.bode_phase_axes);
                semilogx(freq(1:n),phase(1:n));
                fprintf(csv,'%f,%f,%f\n',freq(n),vpp_out(n)./vpp_in(n),phase(n));
            end
            
            
            fclose(Oscilloscope);
            fclose(Generator);
            fclose(csv);
            return;
        end
        function self=zinp_plot_cb(self,varargin)
            Oscilloscope=instrfind('Type', 'visa-usb', 'RsrcName', 'usb0[2391::5925::MY49110441::0]', 'Tag', '');
            Generator=instrfind('Type', 'visa-usb', 'RsrcName', 'usb0[2391::1031::MY44013183::0]', 'Tag', '');
            if isempty(Oscilloscope)
                Oscilloscope=visa('AGILENT', 'USB0::0x0957::0x1725::MY49110441::0::INSTR');

            else
                fclose(Oscilloscope);
                Oscilloscope=Oscilloscope(1);
            end
            if isempty(Generator)
                Generator=visa('AGILENT','USB0::0x0957::0x0407::MY44013183::0::INSTR');

            else
                fclose(Generator);
                Generator=Generator(1);
            end
            fopen(Oscilloscope);
            fopen(Generator);
            csv=fopen('lastMed.csv','w');
            tp=floor(log10(self.stop_freq/self.start_freq)*self.ppd);
            freq=logspace(log10(self.start_freq), log10(self.stop_freq),tp);
            mag=zeros(1,tp);
            phase=zeros(1,tp);
            vpp_in=zeros(1,tp);
            vpp_out=zeros(1,tp);
            Zin=zeros(1,tp);
            in_ch=num2str(get(self.handles.osc_ich,'Value'));
            o_ch=num2str(get(self.handles.osc_och,'Value'));
            fprintf(Oscilloscope, '*RST');
            fprintf(Oscilloscope,':CHAN2:DISP ON');
            fprintf(Oscilloscope, ':ACQ:TYPE AVER');
            fprintf(Oscilloscope, [':TRIG:EDGE:SOUR CHAN' in_ch]);
            fprintf(Oscilloscope, ':TRIG:LEV 0');
            fprintf(Oscilloscope, [':CHAN' in_ch ':SCAL ' num2str(self.vpp/5,10)]);
            fprintf(Oscilloscope, [':CHAN' o_ch ':SCAL ' num2str(self.vpp/5,10)]);
                    
            %Init axes
            cla(self.handles.bode_mag_axes);
            cla(self.handles.bode_phase_axes);
            set(self.handles.bode_mag_axes,'Visible','on');
            set(self.handles.bode_phase_axes,'Visible','on');
            
            
            for n=1:tp
                self.PAUSE=64/freq(n)+0.5;
                %%Frequency set
                fprintf(Generator, ['APPL:SIN ' num2str(freq(n)) ', ' num2str(self.vpp) ', 0']);
        
                %Scale
                fprintf(Oscilloscope, [':TIM:SCAL ' num2str(0.2/freq(n))]);
                
                if(n>1)
                    fprintf(Oscilloscope, [':CHAN' o_ch ':SCAL ' num2str(vpp_out(n-1)/5,10)]);
                    
                end
                pause(self.PAUSE);
                %Data input
                %fprintf(Oscilloscope,':STOP');
                %Vpp Out
                fprintf(Oscilloscope, [':MEAS:VPP? CHAN' o_ch]);
                vpp_out(n)=str2double(fscanf(Oscilloscope));
                %Vpp In
                fprintf(Oscilloscope, [':MEAS:VPP? CHAN' in_ch]);
                vpp_in(n)=str2double(fscanf(Oscilloscope));
                %Phase
                fprintf(Oscilloscope, [':MEAS:PHASE? CHAN' o_ch ',CHAN' in_ch]);
                phase(n)=str2double(fscanf(Oscilloscope));
                
                axes(self.handles.bode_mag_axes);
                Vin=vpp_in(n);
                Vo=vpp_out(n)*exp(1i*phase(n)*pi/180);
                Zin(n)=Vo/(Vin-Vo)*self.r;
                
                semilogx(freq(1:n),abs(Zin(1:n)));
                axes(self.handles.bode_phase_axes);
                semilogx(freq(1:n),angle(Zin(1:n))*180/pi );
                fprintf(csv,'%f,%f,%f\n',freq(n),abs(Zin(n)),angle(Zin(n))*180/pi);
            end
            fclose(Oscilloscope);
            fclose(Generator);
            fclose(csv);
            return;
        end
    end
   
    
end
