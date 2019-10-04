mag = [];
phase = [];

m = csvread('mc_1.csv');
f = m(:,1);
mag = [mag m(:,2)];
phase = [phase m(:,3)];

m = csvread('mc_2.csv');
mag = [mag m(:,2)];
phase = [phase m(:,3)];

m = csvread('mc_3.csv');
mag = [mag m(:,2)];
phase = [phase m(:,3)];

m = csvread('mc_4.csv');
mag = [mag m(:,2)];
phase = [phase m(:,3)];

m = csvread('mc_5.csv');
mag = [mag m(:,2)];

m = csvread('mc_6.csv');
mag = [mag m(:,2)];
phase = [phase m(:,3)];

m = csvread('mc_7.csv');
mag = [mag m(:,2)];
phase = [phase m(:,3)];

m = csvread('mc_8.csv');
mag = [mag m(:,2)];
phase = [phase m(:,3)];

m = csvread('mc_9.csv');
mag = [mag m(:,2)];
phase = [phase m(:,3)];

m = csvread('mc_10.csv');
mag = [mag m(:,2)];
phase = [phase m(:,3)];

data = [f mag phase];
csvwrite('montecarlo_data.csv',data);

