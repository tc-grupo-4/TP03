from sympy import Symbol
from sympy import Function, simplify
from sympy import init_printing
from sympy.core.numbers import pi, I, oo
from sympy.solvers.inequalities import solve_rational_inequalities
from sympy.solvers.inequalities import reduce_rational_inequalities
from sympy.solvers import solve
import sympy as sy
import numpy as np
import matplotlib.pyplot as plt
from mpmath import *


def plotExpress(expressQz, expressQp,expressA):
    k = np.linspace(0.0,1.0,num=100)
    qz = []
    qp = []
    a =[]
    expressQz = substitute(expressQz)
    expressQp = substitute(expressQp)
    expressA = substitute(expressA)
    for u in range(0,100):
        qz.append(expressQz.subs(K,k[u]))
        qp.append(expressQp.subs(K,k[u]))
        a.append(expressA.subs(K,k[u]))
    plt.plot(k,qz)
    plt.plot(k,qp)
    plt.plot(k,a)
    plt.legend(["Qz","Qp","A"])
    plt.grid(which = "both")
    plt.xlabel("K")
    plt.ylabel("Valor")
    plt.show()
    return

def plotH(express):
    steps = 5
    k = np.linspace(0.0,1.0,num=steps)
    freq = np.logspace(1,6,base=10,num= 100)
    fig, (ax1,ax2) = plt.subplots(2,1)
    for u in range(0,steps):
        modk = []
        phasek =[]
        temp = sy.Abs(express).subs(K,k[u])
        temp2 = sy.atan(sy.im(express).subs(K,k[u])/sy.re(express).subs(K,k[u]))
        for i in range(0,100):
            hola=(temp.subs(s,I*2*pi*freq[i])).evalf()
            hola = 20*log(hola,10)
            hola2=temp2.subs(s,I*2*pi*freq[i])*180/pi
            modk.append(hola)
            phasek.append(hola2)
        ax1.semilogx(freq,modk)
        ax2.semilogx(freq,phasek)
    #plt.semilogx(freq,phasek)
    ax1.grid(which = "both")
    ax2.grid(which = "both")
    plt.xlabel("Frecuencia (Hz)")
    ax1.set(ylabel="Modulo (dB)")
    ax2.set(ylabel="Fase (°)")
    text = []
    for i in range(0,steps):
        string = "K="+str(k[i])
        text.append(string)
    ax1.legend(text,loc='upper right')
    plt.show()
    return



def substitute(express):
    express = express.subs(R1,330)
    express = express.subs(R2,2000)
    express = express.subs(C2,10*10**-9)
    return express



init_printing(use_unicode=True)
Vi = Symbol('Vi', real=True)
Vo = Symbol('Vo', real=True)
R1 = Symbol('R1', real=True, positive =True)
R2 = Symbol('R2', real=True, positive =True)
R3 = 10*R2#Symbol('R3', real=True)
C2 = Symbol('C2', real=True, positive =True)
C1 = 10*C2#Symbol('C1', real=True)
K = Symbol('K', real=True, positive =True)

s = Symbol('s')
f = Symbol('f')
den = 1/(s*C1)+R2*K+R2*(1-K)

z1 = (1/(s*C1)*R2*(1-K))/(den)
z2 = (1/(s*C1)*R2*K)/(den)
z3 = R2**2 * K *(1-K)/(den)

za = z2+R1
zb = z3 + (1/(s*C2))
zc = z1 + R1

nom = (za*zb+zb*zc+zc*za)

zk1 = nom/zc
zk2 = nom / za
zk3 = nom/zb

zalpha = (zk1 * R3)/(zk1+R3)
zbeta = (zk2*R3)/(zk2+R3)

H = - sy.simplify((zbeta/zalpha))



wo = sy.sqrt((2*R1+R2)/(100*C2**2 *R1*R2**2))
wo = sy.simplify(wo)


C=2*R1+R2
B=-C2*K**2*R2**2-9*C2*K*R2**2+C2*R1**2+31*C2*R1*R2+10*C2*R2**2
E=-C2*K**2 *R2**2+11*C2*K*R2**2+C2*R1**2+31*C2*R1*R2

Qz= C/(B *wo)
Qp = C/(E*wo)
A=Qp/Qz
A = sy.simplify(A)


#H = substitute(H)

#print(wo)

#plotExpress(Qz,Qp,A)

print(H)
#plotH(H)


