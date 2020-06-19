%% Markov chain

clr

T11 = 500;
T22 = 250;

t = 1:7000;

States = zeros(5000,5000);

for ii = 1:5000
    
    Times(ii,1) = exprnd(T11);
    Times(ii,2) = exprnd(T22);
    
    if round(Times(ii,1))==0
        Times(ii,1) = 1;
    end
    
    States(ii,round(Times(ii,1)):round(Times(ii,1)+Times(ii,2))) = 0.5;
    States(ii,round(Times(ii,1)+Times(ii,2)+1):7000) = 1;
    
end

plot(1:7000,mean(States))

L1 = 1/T11; L2 = 1/T22;
P11 = exp(-L1*t);
P12 = L1/(L2-L1)*(exp(-L1*t)-exp(-L2*t));
P13 = 1-P12-P11;

rec = 0.5*P12+P13;

hold on
plot(t,rec)

%% SMP

clr

T11 = 500;
T22 = 250;

t = 1:7000;

States = zeros(5000,5000);

for ii = 1:5000
    
    Times(ii,1) = lognrnd(log(T11),0.5);
    Times(ii,2) = lognrnd(log(T22),0.5);
    
    if round(Times(ii,1))==0
        Times(ii,1) = 1;
    end
    
    States(ii,round(Times(ii,1)):round(Times(ii,1)+Times(ii,2))) = 0.5;
    States(ii,round(Times(ii,1)+Times(ii,2)+1):7000) = 1;
    
end

plot(1:7000,mean(States))

tmp = SingleHazard_Rec(0.5, 'E', 7000);
rec = tmp(1,:);

hold on
plot(1:10:7000,rec)
