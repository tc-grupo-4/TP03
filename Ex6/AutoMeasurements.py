import visa
import instrument
import programInstance
import numpy
import matplotlib.pyplot as plt
import time
import configparser
import io
import tools
from scipy import interpolate as interp


def interpolateMeasurements(xValues, yValues, samples) :
    tenthPowerStartValue=numpy.log10(min(xValues))
    tenthPowerEndValue=numpy.log10(max(xValues))
    
    xSamples=numpy.logspace(tenthPowerStartValue,tenthPowerEndValue,samples)
    
    tck=interp.splrep(xValues,yValues,xb=min(xValues),xe=max(xValues),s=len(xValues)-numpy.sqrt(len(xValues)*2))
    interpolation=interp.splev(xSamples, tck, ext=2)
    firstGradient=interp.splev(xSamples, tck, der=1, ext=2)
    secGradient=interp.splev(xSamples, tck, der=2, ext=2)

    return [xSamples, interpolation, firstGradient, secGradient]


def getPoint(freq, chanIn, chanOut, tEst=0.001, noiseTolerance=0.1):
    # Get settings from instance
    vClearance=thisInstance.settings["sampling"]["vClearance"]
    periods=thisInstance.settings["sampling"]["periods"]
    verbose=thisInstance.settings["console"]["verbose"]
    #freq=points[currentStep-1]
    if verbose : print("---------")
    if verbose : print("Frequency point: "+str(freq))
    thisInstance.generator.send("FREQ "+str(freq))

    # Set initial oscilloscope values
    #thisInstance.oscilloscope.send(":TRIG:HFR 0")
    #thisInstance.oscilloscope.send(":TRIG:LIFIF")

    # Adjust voltage range for both channels based on their Vpp values
    thisInstance.oscilloscope.send(":MEAS:VPP "+chanIn.id) 
    vRangeIn=thisInstance.oscilloscope.ask(":MEAS:VPP?")
    vRangeIn=(1+vClearance)*vRangeIn
    thisInstance.oscilloscope.send(":"+chanIn.id+":RANG "+str(vRangeIn))
    
    thisInstance.oscilloscope.send(":MEAS:VPP "+chanOut.id) 
    vRangeOut=thisInstance.oscilloscope.ask(":MEAS:VPP?")
    vRangeOut=(1+vClearance)*vRangeOut
    thisInstance.oscilloscope.send(":"+chanOut.id+":RANG "+str(vRangeOut))

    # Adjust timebase range for both channels based on their periods 
    thisInstance.oscilloscope.send(":MEAS:FREQ "+chanIn.id) 
    tFreqIn=thisInstance.oscilloscope.ask(":MEAS:FREQ?")
    
    thisInstance.oscilloscope.send(":MEAS:FREQ "+chanOut.id) 
    tFreqOut=thisInstance.oscilloscope.ask(":MEAS:FREQ?")

    tRange=periods/min(tFreqIn,tFreqOut)
    thisInstance.oscilloscope.send(":TIM:RANG "+str(tRange))
    
    time.sleep(tEst)

    # Obtain n samples per frequency point, average and store them # TODO: implement variable sample quantity based on samples taken
    # TODO: implement these functions in a generic method
    # Measure Vpp of in signal with a standard deviation less than noiseTolerance different from the signal
    vIn=thisInstance.oscilloscope.getValue("vpp",noiseTolerance,thisInstance,chanIn.id,None,verbose)
    
   
   # Measuring Vpp of out signal with a deviation less than noiseTolerance different from the signal
    vOut=thisInstance.oscilloscope.getValue("vpp",noiseTolerance,thisInstance,chanOut.id,None,verbose)
   
    # Measure phase difference with a deviation less than noiseTolerance different from the signal
    phase=thisInstance.oscilloscope.getValue("phase",noiseTolerance,thisInstance,chanIn.id,chanOut.id,verbose)
    
    # Calculate ratio
    ratio=20*numpy.log10(vOut/vIn)
    
    # Generate matrix of k x 5 with data from run
    run=[freq, vIn, vOut, phase, ratio]

    return run
    
        
def bode(startfreq=10, stopfreq=100000, samp=200, signal="sine", mode="normal", vpp=1, tEst=0.001, cIn=1, cOut=3, noiseTolerance=0.1, autoStep=False, plot=True, livePlot=False, dumpToFile=True):
    
    # Get settings from instance
    vClearance=thisInstance.settings["sampling"]["vClearance"]
    periods=thisInstance.settings["sampling"]["periods"]
    maxTries=thisInstance.settings["sampling"]["maxTries"]
    verbose=thisInstance.settings["console"]["verbose"]
    closeness=thisInstance.settings["interpolation"]["closeness"]
    # Set channels for transfer function
    chanIn=instrument.channel(cIn)
    chanOut=instrument.channel(cOut)
    
    # Auxiliary methods
    def isNotClose(value1,list):
        returnValue=True
        for element in list:
            if numpy.abs(value1-element)<closeness*(stopFreq-startFreq):
                returnValue=False
                break
        return returnValue
            


    # Set array of frequency points to measure
    if autoStep : samp=2000
    points=numpy.logspace(numpy.log10(startfreq),numpy.log10(stopfreq),samp)
    
    
    points=points.tolist()
    # Set generator signal type
    if signal is "sine" : thisInstance.generator.send("FUNC SIN")
    if signal is "square" : thisInstance.generator.send("FUNC SQU")
    if signal is "triangle" : thisInstance.generator.send("FUNC TRI")

    # Set initial generator values
    thisInstance.generator.send("VOLT "+str(vpp/2)+" VPP")
    thisInstance.generator.send("FREQ "+str(points[0]))
    thisInstance.generator.send(":OUTP ON")
    thisInstance.generator.send("OUTP:LOAD INF")
    time.sleep(1)
    thisInstance.oscilloscope.send(":TRIG:HFR 0")
    thisInstance.oscilloscope.send("TRIG:LIFIF")
    time.sleep(1)
    thisInstance.oscilloscope.send(":AUT")
    time.sleep(1)
    thisInstance.oscilloscope.send(":"+chanIn.id+":OFFS 0")
    thisInstance.oscilloscope.send(":"+chanOut.id+":OFFS 0")
    thisInstance.oscilloscope.send(":TRIG:SOUR "+chanIn.id)
    thisInstance.oscilloscope.send(":"+chanOut.id+":COUP AC")

    vRangeIn=thisInstance.generator.ask("VOLT?")
    vRangeIn=(1+vClearance)*vRangeIn
    thisInstance.oscilloscope.send(":"+chanIn.id+":RANG "+str(vRangeIn))
     
    vRangeOut=thisInstance.generator.ask("VOLT?")
    vRangeOut=(1+vClearance)*vRangeOut
    thisInstance.oscilloscope.send(":"+chanOut.id+":RANG "+str(vRangeOut))

    tRange=periods/thisInstance.generator.ask("FREQ?")
    thisInstance.oscilloscope.send(":TIM:RANG "+str(tRange))
    
    time.sleep(0.2)
    results=[]
    countSinceFail=1000
    currentStep=1
    step=int(numpy.round(1+len(points)/100))
    line=[]
    phase=[]
    ratio=[]
    frequency=[]
    # Perform a frequency sweep and obtain the measurements for each frequency point
    tries=1
    failedPoints=0
    availablePoints=None
    pointsTaken=[]
    ratioData=[]
    phaseData=[]
    first30Points=0
    second40Points=0
    third30Points=0
    while mode is "normal": 
        valid=False
        freq=points[currentStep]
        if verbose : 
            print("-----------------------------")
            print("Run "+str(currentStep)+", try "+str(tries))
        run=getPoint(freq, chanIn, chanOut, tEst, noiseTolerance)
        ratio.append(run[4])
        phase.append(run[3])
        if len(results)>6:
            meanRatio=numpy.mean(ratio[-5:],dtype=numpy.float64())
            meanPhase=numpy.mean(phase[-5:],dtype=numpy.float64())
            devRatio=numpy.std(ratio[-5:],dtype=numpy.float64())
            devPhase=numpy.std(ratio[-5:],dtype=numpy.float64())
            if numpy.abs(run[4]-meanRatio)<50*devRatio and numpy.abs(run[3]-meanPhase)<50*devPhase :
                valid=True
                results.append(run)
                tries=1
            else : tries=1+tries
            if tries>maxTries+1 : 
                valid=True
                tries=1
                failedPoints=failedPoints+1
                if verbose : print("Failed to acquire reasonable ratio value for frequency point "+str(freq)+"Hz after "+str(maxTries)+" tries. Point is ignored.")
        else:
            valid=True
            results.append(run)
        if len(results)>1 : # If there are enough points to calculate slope, calculate it
            ratioSlope=(results[len(results)-1][4]-results[len(results)-2][4])/(results[len(results)-1][0]-results[len(results)-2][0])
            if verbose : print("Ratio slope is: "+str(ratioSlope))
            if valid : results[len(results)-1].append(ratioSlope)
    # AutoStep: Dynamic curve interpretation and frequency step adaptation
    # Step is made longer if there is no change in slope detected, and shorter if a change is detected.
    # In this way, points of interest are analyzed throughly whereas linear parts of the curve are not.
        if autoStep:
            # Import settings from instance
            ratioTolerance=thisInstance.settings["autoStep"]["ratioTolerance"]
            minStep=thisInstance.settings["autoStep"]["minStep"]
            maxStep=thisInstance.settings["autoStep"]["maxStep"]
            minCountSinceFail=thisInstance.settings["autoStep"]["minCountSinceFail"]
            stepFactor=thisInstance.settings["autoStep"]["stepFactor"]
            if len(results)>3 : # If there are enough points to compare current slope to previous slope, compare them
                if numpy.absolute(ratioSlope-(results[len(results)-2][5])) > ratioTolerance : # If difference is greater than tolerance, reduce step
                    if (step/stepFactor)>minStep :
                        step=step/stepFactor
                        if verbose : print("Step is reduced to "+str(step))
                    elif verbose : print("Step cannot be reduced any further. Minimum step has been reached.")
                    countSinceFail=0
                else : # If slope difference is okay and some steps since last failure have gone by, enlarge step
                    countSinceFail=countSinceFail+1
                    if countSinceFail>minCountSinceFail and (step*stepFactor)>maxStep :
                        step=step*stepFactor
                        if verbose : print("Step is raised to "+str(step))
            if valid : currentStep=currentStep+int(numpy.round(step))
            

        elif valid : currentStep=currentStep+1 # If AutoStep is off, all of the points in the array are analyzed
 
        if plot and livePlot:
            frequency.append(results[len(results)-1][0])
            phase.append(results[len(results)-1][3])
            line=tools.live_plotter(frequency,ratio,line,"Bode diagram",points[len(points)-1])
        if currentStep>=len(points): break

    

    while mode is "interp":
        secDerivWeight=thisInstance.settings["interpolation"]["secDerivWeight"]
        initialSamples=thisInstance.settings["interpolation"]["initialSamples"]
        initialPoints=numpy.logspace(numpy.log10(startfreq),numpy.log10(stopfreq),initialSamples)
        
        if frequency==[]: 
            if verbose: print("Getting first "+str(initialSamples)+" before interpolating:")
            if verbose: print("Run  Frequency   Phase   Ratio   VPP1    VPP2")
            for freq in initialPoints:
                run=getPoint(freq, chanIn, chanOut, tEst, noiseTolerance)
                phase.append(run[3])
                ratio.append(run[4])
                frequency.append(run[0])
                if verbose: print([str(len(frequency)),str(run[0]),str(run[3]),str(run[4]),str(run[1]),str(run[2])])
            interpolate=True
                
        if availablePoints is None: 
            availablePoints=initialPoints-samp
            first30Points=numpy.round(availablePoints*0.5)
            second40Points=numpy.round(availablePoints*0.4)
            third30Points=numpy.round(availablePoints*0.1)

        if interpolate:
            if verbose : print("Interpolating points...")
            pointsTaken.clear()
            pointsTaken.extend(frequency)
            ratioData=interpolateMeasurements(frequency,ratio,10*samp)
            phaseData=interpolateMeasurements(frequency,phase,10*samp)
            
            

            sortedPhaseDerivative=sorted(phaseData[1].tolist(),key=tools.takeSecond)
            sortedRatioDerivative=ratioData[1].tolist().sorted(key=tools.takeSecond)

            sortedPhaseSecDerivative=phaseData[2].sorted(key=tools.takeSecond)
            sortedRatioSecDerivative=ratioData[2].sorted(key=tools.takeSecond)
            
            maxRatioSecDerivative=max(sortedRatioSecDerivative)
            maxPhaseSecDerivative=max(sortedPhaseSecDerivative)

            sortedRatioDerivativeFraction=[]
            sortedPhaseDerivativeFraction=[]
            sortedRatioSecDerivativeFraction=[]
            sortedPhaseSecDerivativeFraction=[]

            for r in sortedRatioDerivative:
                sRDF[1]=r[1]/maxRatioDerivative
                sRDF[0]=r[0]
                sortedRatioDerivativeFraction.append(sRDF)

            for p in sortedRatioDerivative:
                sPDF[1]=p[1]/maxPhaseDerivative
                sPDF[0]=p[0]
                sortedPhaseDerivativeFraction.append(sPDF)
           
            for r in sortedRatioSecDerivative:
                sRSDF[1]=r[1]/maxRatioSecDerivative
                sRSDF[0]=r[0]
                sortedRatioSecDerivativeFraction.append(sRSDF)

            for p in sortedRatioSecDerivative:
                sPSDF[1]=p[1]/maxPhaseSecDerivative
                sPSDF[0]=p[0]
                sortedPhaseSecDerivativeFraction.append(sPSDF)
            
            sortedPhaseDerivative=sortedRatioDerivativeFraction.sorted(key=tools.takeFirst)
            sortedRatioDerivative=sortedPhaseDerivativeFraction.sorted(key=tools.takeFirst)
            sortedPhaseSecDerivative=sortedRatioSecDerivativeFraction.sorted(key=tools.takeFirst)
            sortedRatioSecDerivative=sortedPhaseSecDerivativeFraction.sorted(key=tools.takeFirst)

            
            for n in range(len(sortedPhaseDerivative)):
                weight[n][0]=sortedPhaseDerivative[n][0].copy()
                weightPhase[n][1]=secDerivWeight*sortedPhaseSecDerivativeFraction[n][1]+(1-secDerivWeight)*sortedPhaseDerivativeFraction[n][1]
                weightRatio[n][1]=secDerivWeight*sortedRatioSecDerivativeFraction[n][1]+(1-secDerivWeight)*sortedRatioDerivativeFraction[n][1]

            
          #  for n in range(len(weightPhase)) :
          #      if weightPhase[-n][1]>=0.7 and isNotClose(weightPhase[-n],pointsTaken) and first30points>=0:
          #           points1.append(weightPhase[-n][0])
          #           pointsTaken.append(weightPhase[-n][0])
          #           first30Points=first30Points-1
          #      elif weightPhase[-n][1]>=0.3 and isNotClose(weightPhase[-n],pointsTaken) and second40points>=0:
          #           points2.append(weightPhase[-n][0])
          #           pointsTaken.append(weightPhase[-n][0])
          #           second40Points=second40Points-1
          #      elif isNotClose(weightPhase[-n],pointsTaken) and third30points>=0:
          #           points3.append(weightPhase[-n][0])
          #           pointsTaken.append(weightPhase[-n][0])
          #           third30Points=third30Points-1

            for n in range(len(weightRatio)) :
                if weightRatio[-n][1]>=0.7 and isNotClose(weightRatio[-n],pointsTaken) and first30points>=0:
                     points1.append(weightRatio[-n][0])
                     pointsTaken.append(weightRatio[-n][0])
                     first30Points=first30Points-1
                elif weightRatio[-n][1]>=0.3 and isNotClose(weightRatio[-n],pointsTaken) and second40points>=0:
                     points2.append(weightRatio[-n][0])
                     pointsTaken.append(weightRatio[-n][0])
                     second40Points=second40Points-1
                elif isNotClose(weightRatio[-n],pointsTaken) and third30points>=0:
                     points3.append(weightRatio[-n][0])
                     pointsTaken.append(weightRatio[-n][0])
                     third30Points=third30Points-1
            interpolate=false
                     
        pointsToTake=points1+points2+points3
        freq=pointsToTake.pop(0)
        if verbose: print("About to measure next point. Frequency: "+str(freq)+"Hz")
        run=getPoint(freq, chanIn, chanOut, tEst, noiseTolerance)
        if verbose: print([str(len(frequency)),str(run[0]),str(run[3]),str(run[4]),str(run[1]),str(run[2])])
        availablePoints-=1
        if verbose: print("Measured! Available points left: "+str(availablePoints))
        if verbose: print("Available points left: "+str(availablePoints))
        phase.append(run[3])
        ratio.append(run[4])
        frequency.append(run[0])   

        for n in len(ratioData):
            if ratioData[n][0]==run[0]:
                if numpy.abs(ratioData[n][1]-run[4])>numpy.abs(ratioTolerance*ratioData[n][1]):
                    interpolate=True
                    if verbose: print("Need to interpolate again!")
                else: 
                    interpolate=False
                    successCount=successCount+1
                    if verbose: print("Success! Count is now "+str(successCount))

        if successCount>successesToExit or availablePoints==0: 
            if verbose: print("Finishing cycle after "+str(len(frequency))+"measurements. Available points left were "+str(availablePoints)+" and there were "+str(successCount)+" successes.")
            break

    if plot and not livePlot:
         ratio.clear()
         phase.clear()
         for vector in results :
             frequency.append(vector[0])
             phase.append(vector[3])
             ratio.append(vector[4])
        # plt.semilogx(frequency, ratio,label="Ratio")
        # plt.semilogx(frequency, phase,label="Phase")
         #plt.grid(None,"both","both")
         plt.legend(loc="best")

         fig, ax1 = plt.subplots(sharex=True)
         ax1.set_title("Bode Diagram")
         color = 'tab:red'
         ax1.set_xlabel('Frequency [Hz]')
         ax1.set_ylabel('Phase [deg]', color=color)
         ax1.set_xscale('log')
         ax1.plot(frequency, phase, color=color)
         ax1.tick_params(axis='y', labelcolor=color)
         ax1.grid(True,"both")
         
         ax2 = ax1.twinx()  # instantiate a second axes that shares the same x-axis
         
         color = 'tab:blue'
         ax2.set_ylabel('Ratio [dB]', color=color)  # we already handled the x-label with ax1
         ax2.plot(frequency, ratio, color=color)
         ax2.tick_params(axis='y', labelcolor=color)
         ax2.grid(True,"both")     
         
         fig.tight_layout()  # otherwise the right y-label is slightly clipped
         
         plt.show()
         time.sleep(1)
    if dumpToFile:
        timestr = time.strftime("%d%m%Y-%H%M%S")
        filename="BodeData-"+timestr+".txt"
        file=open(filename,"w+")
        file.write("Bode taken on "+timestr+"\n")
        file.write(str(failedPoints)+" points could not be taken due to noise in the signal.\n")
        file.write("Obtained data is as follows:\n")
        file.write(str(["Frequency","Vpp 1","Vpp 2","Phase","Ratio","Slope"])+"\n")
        for line in results :
            file.write(str(line)+"\n")
        file.close()
    return results




thisInstance = programInstance.programInstance()
#plt.style.use('ggplot')
if thisInstance.generator and thisInstance.oscilloscope : 
    bode()
time.sleep(1)



    
    
    #bodedata=bode()
    #phase=[]
    #ratio=[]
    #frequency=[]
    #for vector in bodedata :
    #    frequency.append(vector[0])
    #    phase.append(vector[3])
    #    ratio.append(vector[4])
    #plt.semilogx(frequency, ratio,label="Ratio")
    #plt.semilogx(frequency, phase,label="Phase")
    #plt.title("Bode Diagram")
    #plt.xlabel("Frequency [Hz]")
    #plt.legend(loc="best")
    #plt.show()
    #time.sleep(1)

