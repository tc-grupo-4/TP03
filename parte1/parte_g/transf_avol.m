clear all
clc
syms R_1 C_2 C_6 R_3 R_4 R_8 R_6 A s C R Q
R1 = R;
R3 = R;
R4 = R;
R8 = R;
R6 = Q*R;
C2 = C;
C6 = C;
num_GIC = A*(R4 + R8)*(1+R3*C2*s+A*R3*C2);
den_GIC = A*C2*s*(A*R3*R8+R3*(R4+R8))+(R4+R8)*(A+1+R3*C2*s);
H_GIC = num_GIC/den_GIC;
LGIC = R1*R3*R8*C2/R4;
num_Circ = s/(R6*C6);
den_Circ = s^2 + s/(R6*C6) + 1/(LGIC*C6);
H_Circ = num_Circ/den_Circ;
H = H_GIC*H_Circ;
pretty(H)
chr = latex(H)