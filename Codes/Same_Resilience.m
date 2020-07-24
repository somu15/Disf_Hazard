clr

% DESCRIPTION: In this script, disfunctionality hazard is computed for recovery curves
% having the same resilience but different recovery functions. Linear and sinusoidal
% recovery functions are considered. Recovery curves are considered for five hypotherical
% intensity levels.

%% Recovery curves

t1 = 0:0.001:1;
y_lin1 = 0.8+0.2*t1;
y_sin1 = 0.025*sin(2*pi*t1)+y_lin1;
A_lin1 = trapz(t1,1-y_lin1); A_sin1 = trapz(t1,1-y_sin1);
y_lin1 = [y_lin1 ones(1,5001-length(t1))];
y_sin1 = [y_sin1 ones(1,5001-length(t1))];


t2 = 0:0.001:2;
y_lin2 = 0.6+0.2*t2;
y_sin2 = 0.05*sin(1*pi*t2)+y_lin2;
A_lin2 = trapz(t2,1-y_lin2); A_sin2 = trapz(t2,1-y_sin2);
y_lin2 = [y_lin2 ones(1,5001-length(t2))];
y_sin2 = [y_sin2 ones(1,5001-length(t2))];


t3 = 0:0.001:3;
y_lin3 = 0.4+0.2*t3;
y_sin3 = 0.075*sin(0.667*pi*t3)+y_lin3;
A_lin3 = trapz(t3,1-y_lin3); A_sin3 = trapz(t3,1-y_sin3);
y_lin3 = [y_lin3 ones(1,5001-length(t3))];
y_sin3 = [y_sin3 ones(1,5001-length(t3))];


t4 = 0:0.001:4;
y_lin4 = 0.2+0.2*t4;
y_sin4 = 0.1*sin(0.5*pi*t4)+y_lin4;
A_lin4 = trapz(t4,1-y_lin4); A_sin4 = trapz(t4,1-y_sin4);
y_lin4 = [y_lin4 ones(1,5001-length(t4))];
y_sin4 = [y_sin4 ones(1,5001-length(t4))];


t5 = 0:0.001:5;
y_lin5 = 0.2*t5;
y_sin5 = 0.15*sin(0.4*pi*t5)+y_lin5;
A_lin5 = trapz(t5,1-y_lin5); A_sin5 = trapz(t5,1-y_sin5);


plot(t5,y_lin1,t5,y_sin1)
hold on
plot(t5,y_lin2,t5,y_sin2)
plot(t5,y_lin3,t5,y_sin3)
plot(t5,y_lin4,t5,y_sin4)
plot(t5,y_lin5,t5,y_sin5)

ylim([0 1])

%% Frag functions

T_req = [0.5,1.5,2.5,3.5];

IM = 1:5;

ind = find(t5==T_req(1));
P_lin1 = 1-[y_lin1(ind) y_lin2(ind) y_lin3(ind) y_lin4(ind) y_lin5(ind)];
P_sin1 = 1-[y_sin1(ind) y_sin2(ind) y_sin3(ind) y_sin4(ind) y_sin5(ind)];

ind = find(t5==T_req(2));
P_lin2 = 1-[y_lin1(ind) y_lin2(ind) y_lin3(ind) y_lin4(ind) y_lin5(ind)];
P_sin2 = 1-[y_sin1(ind) y_sin2(ind) y_sin3(ind) y_sin4(ind) y_sin5(ind)];

ind = find(t5==T_req(3));
P_lin3 = 1-[y_lin1(ind) y_lin2(ind) y_lin3(ind) y_lin4(ind) y_lin5(ind)];
P_sin3 = 1-[y_sin1(ind) y_sin2(ind) y_sin3(ind) y_sin4(ind) y_sin5(ind)];

ind = find(t5==T_req(4));
P_lin4 = 1-[y_lin1(ind) y_lin2(ind) y_lin3(ind) y_lin4(ind) y_lin5(ind)];
P_sin4 = 1-[y_sin1(ind) y_sin2(ind) y_sin3(ind) y_sin4(ind) y_sin5(ind)];

figure
plot(IM,P_lin1,IM,P_sin1)
hold on
plot(IM,P_lin2,IM,P_sin2)
plot(IM,P_lin3,IM,P_sin3)
plot(IM,P_lin4,IM,P_sin4)

clearvars -except IM P_lin1 P_lin2 P_lin3 P_lin4 P_sin1 P_sin2 P_sin3 P_sin4

%% Disfunctionality hazard

T_R = 0.001:0.001:5;

IM = 1:5;
Haz = 1-expcdf(IM,0.5);
Haz_diff = exppdf(IM,0.5);


for ii = 1:length(T_R)
    ind = ii+1;
    P_lin = 1-[y_lin1(ind) y_lin2(ind) y_lin3(ind) y_lin4(ind) y_lin5(ind)];
    P_sin = 1-[y_sin1(ind) y_sin2(ind) y_sin3(ind) y_sin4(ind) y_sin5(ind)];
    Disf_lin(ii) = trapz(IM,P_lin'.*Haz_diff');
    Disf_sin(ii) = trapz(IM,P_sin'.*Haz_diff');
end

semilogy(T_R,Disf_lin,T_R,Disf_sin)
xlim([1 3])
clearvars -except T_R Disf_lin Disf_sin
