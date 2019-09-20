import visa
import pyvisa
import time
import tools
import numpy
import programInstance

class instrument:
    def __init__(self, address, rm):
        self.delay=0.0001
        self.instResource=rm.open_resource(address)
        self.instAddress=address
        self.instID = self.instResource.query('*IDN?')
        if ("DSO" in self.instID):
            self.type="OSC"
        else:
            self.type="SGN"

    def send(self, string) :
        self.instResource.write(string)
        time.sleep(self.delay)
    def ask(self, string) :
        returnValue=self.instResource.query(string)
        time.sleep(self.delay)
        returnValue=float(returnValue.replace('\n',''))
        return returnValue

    def getValue(self, value, noiseTolerance, thisInstance, chanInId, chanOutId=None, verbose=True): # ChanOut only required for phase calculation
        minSamples=thisInstance.settings["sampling"]["minSamples"]
        maxSamples=thisInstance.settings["sampling"]["maxSamples"]
        returnArray=[]
        
        if value is "vpp" : # Measure Vpp
            thisInstance.oscilloscope.send(":MEAS:VPP "+chanInId)
            for n in range(minSamples) : 
                returnArray.append(thisInstance.oscilloscope.ask(":MEAS:VPP?"))
                time.sleep(numpy.random.rand()/100)
            while numpy.std(returnArray) > (numpy.mean(returnArray, dtype=numpy.float64)*noiseTolerance) :
                returnArray.append(thisInstance.oscilloscope.ask(":MEAS:VPP?"))
                time.sleep(numpy.random.rand()/100)
                if len(returnArray) > maxSamples :
                    break
            if verbose: print("Peak-to-peak voltage samples taken for "+chanInId+": "+str(len(returnArray)))
        elif value is "phase" : # Measure phase
            thisInstance.oscilloscope.send(":MEAS:PHAS "+chanInId+","+chanOutId)
            for n in range(minSamples) :   
                ph=thisInstance.oscilloscope.ask("MEAS:PHAS?")
            
                if ph > 180 : ph = ph-180 
                elif ph < -180 : ph = ph+180

                returnArray.append((-1)*ph)
            while numpy.std(returnArray) > numpy.abs((numpy.mean(returnArray, dtype=numpy.float64)*noiseTolerance)) :
                returnArray.append(-1*(thisInstance.oscilloscope.ask(":MEAS:PHAS?")))
                if len(returnArray) > maxSamples :
                    break
            if verbose: print("Phase samples taken: "+str(len(returnArray)))
        else : raise Exception('getValue: Unrecognised value type: "'+value+'". Try Vpp or phase.')
        
        if verbose :
            print("Values are:")
            print(returnArray)
        returnArray=tools.reject_outliers(returnArray)
        meanReturnValue=numpy.mean(returnArray, dtype=numpy.float64)
        if verbose :
            print("Values after filtering outliers are:")
            print(returnArray)
            print("Mean= "+str(meanReturnValue)+", standard deviation= "+str(numpy.std(returnArray)))
        
        return meanReturnValue

class channel :
     def __init__(self, idn) :
         if idn is 1 : self.id="CHAN1"
         if idn is 2 : self.id="CHAN2"
         if idn is 3 : self.id="CHAN3"
         if idn is 4 : self.id="CHAN4"
         self.vpp=0
         self.vRange=1
         self.tRange=1
         self.phase=0
         self.freq=0

                
        



    


