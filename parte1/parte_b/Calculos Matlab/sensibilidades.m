syms R1 R3 R4 R8 R6 C2 C6
vars = {R1 R3 R4 R8 R6 C2 C6};
sensQ = zeros(length(vars),1);
sensw0 = [];
Q = R6*sqrt((C6*C2*R4)/(R1*R3*R8));
w0 = sqrt(R4/(R1*R3*R8*C2*C6));
Hw0 = 1 + (R4/R8);
for k=1:length(vars)
    sensQ(k) = diff(Q,vars(k))*(vars(k)/Q);
    aux = diff(w0,vars(k))*(vars(k)/w0);
    sensw0 = [sensw0 aux];
end
