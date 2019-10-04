import visa
import instrument
import yaml


class programInstance:
    instrumentList = []
    rManager = ""
    
    def updateSettings(self, settings=None, defaults=False): # Method to update settings during execution. Setting=None to read from config file again. Format: setting=[[category,setting,value]]
        if not settings or defaults:
            with open("config.yml", 'r') as config :
                self.settings = yaml.load(config)
            if defaults and self.changedSettings : self.changedSettings.clear()
        else:
            for setting in settings:
                if self.settings[setting[0]][setting[1]] : self.savedSettings[setting[0]][setting[1]]=setting[2]
            for cat in self.changedSettings:
                for sett in cat:
                    self.settings[cat][sett]=self.savedSettings[cat][sett].copy() #Load the settings onto instance settings
 
            
    
    def __init__(self):
        self.rManager=visa.ResourceManager()
        self.instrumentAddresses = self.rManager.list_resources()
      
        for addr in self.instrumentAddresses:
            inst=instrument.instrument(addr,self.rManager)
            inst.instResource.write("*rst; status:preset; *cls")
            self.instrumentList.append(inst)

        for x in self.instrumentList:
            if x.type=="OSC":
                self.oscilloscope=x
                break
         
        for x in self.instrumentList:
            if x.type=="SGN":
                self.generator=x
                break
        
        if self.instrumentList :     
            print("Connected instruments:")
            for x in self.instrumentList: 
                print(x.instAddress, x.instID, x.type)
            if self.oscilloscope : print("Oscilloscope defaulted to", self.oscilloscope.instID) #TODO: add device selection support
            if self.generator : print("Signal generator defaulted to", self.generator.instID)
        else : print("No instruments detected. Check National Instruments NIMAX program for details.")

        # Load settings from config file
        with open("config.yml", 'r') as config:
            self.settings = yaml.load(config)

        self.updateSettings()

        

        

