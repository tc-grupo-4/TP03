s=tf('s');
wo=10000;
Q=2;
H=(s*s/(wo*wo)+s/(wo*Q)+1)/(s*s/(wo*wo)+s/(wo)+1);
[mag,phase,wout]=bode(H,{100*2*pi,100e3*2*pi});

semilogx(wout/(2*pi),squeeze(20*log10(mag(1,1,:))));

hold on;
Q=5;
H=(s*s/(wo*wo)+s/(wo*Q)+1)/(s*s/(wo*wo)+s/(wo)+1);
[mag,phase,wout]=bode(H,{100*2*pi,100e3*2*pi});

semilogx(wout/(2*pi),squeeze(20*log10(mag(1,1,:))));
hold on;

Q=10;
H=(s*s/(wo*wo)+s/(wo*Q)+1)/(s*s/(wo*wo)+s/(wo)+1);
[mag,phase,wout]=bode(H,{100*2*pi,100e3*2*pi});


semilogx(wout/(2*pi),squeeze(20*log10(mag(1,1,:))));
hold on;
Q=25;
H=(s*s/(wo*wo)+s/(wo*Q)+1)/(s*s/(wo*wo)+s/(wo)+1);
[mag,phase,wout]=bode(H,{100*2*pi,100e3*2*pi});

semilogx(wout/(2*pi),squeeze(20*log10(mag(1,1,:))));
hold on;
Q=100;
H=(s*s/(wo*wo)+s/(wo*Q)+1)/(s*s/(wo*wo)+s/(wo)+1);
[mag,phase,wout]=bode(H,{100*2*pi,100e3*2*pi});

semilogx(wout/(2*pi),squeeze(20*log10(mag(1,1,:))));




