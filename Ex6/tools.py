import numpy
import matplotlib.pyplot as plt

def reject_outliers(data, m=2.):
    data=numpy.asarray(data,dtype=numpy.float64)
    d = numpy.abs(data - numpy.median(data))
    mdev = numpy.median(d)
    s = d / (mdev if mdev else 1.)
    return data[s < m].tolist()


def takeSecond(elem): return elem[1]
def takeFirst(elem): return elem[0]
                                
def live_plotter(x_vec,y1_data,line1,identifier='',maxX=10000):
    if line1==[]:
        # this is the call to matplotlib that allows dynamic plotting
        plt.ion()
        fig = plt.figure(figsize=(13,6))
        ax = fig.add_subplot(111)
        # create a variable for the line so we can later update it
        line1, = ax.plot(x_vec,y1_data,'-o',alpha=0.8)      
        ax.set_xscale('log')
        plt.grid(None,"both","both")
        plt.ylim((-40,40))
        plt.xlim((0,maxX))
        #update plot label/title
        plt.ylabel('Y Label')
        plt.title('{}'.format(identifier))
        plt.show()
    # after the figure, axis, and line are created, we only need to update the y-data
    line1.set_ydata(y1_data)
    line1.set_xdata(x_vec)
    # adjust limits if new data goes beyond bounds
    if numpy.min(y1_data)<=line1.axes.get_ylim()[0] or numpy.max(y1_data)>=line1.axes.get_ylim()[1]:
        plt.ylim([numpy.min(y1_data)-numpy.std(y1_data),numpy.max(y1_data)+numpy.std(y1_data)])
    if numpy.min(x_vec)<=line1.axes.get_xlim()[0] or numpy.max(x_vec)>=line1.axes.get_xlim()[1]:    
        plt.xlim([numpy.min(x_vec)-numpy.std(x_vec),numpy.max(x_vec)+numpy.std(x_vec)])
    # return line so we can update it again in the next iteration
    return line1