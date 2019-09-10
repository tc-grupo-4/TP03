from sympy import Symbol
from sympy import Function, simplify
from sympy import init_printing
from sympy.core.numbers import pi, I, oo
from sympy.solvers.inequalities import solve_rational_inequalities
from sympy.solvers.inequalities import reduce_rational_inequalities
from sympy.solvers import solve
import sympy as sy
import numpy as np

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
B=C2*K**2*R2**2+9*C2*K*R2**2-C2*R1**2-31*C2*R1*R2-10*C2*R2**2
E=-C2*K**2 *R2**2+11*C2*K*R2**2+C2*R1**2+31*C2*R1*R2

Qz= C/(B *wo)
#Qz = Qz.subs(K,1)
#Qz = sy.simplify(Qz)

Qp = C/(E*wo)
#Qp = Qp.subs(K,1)
#Qp = sy.simplify(Qp)

A=Qp/Qz
A = sy.simplify(A)

print(sy.latex(Qp))