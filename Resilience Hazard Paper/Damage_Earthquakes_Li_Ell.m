function [P_req] = Damage_Earthquakes_Li_Ell(IM, flag)

% flag = 1 => Exceedence Probabilities
% flag = 0 => Equivalence Probabilities

IM = round(IM, 2);

load('/Users/som/Documents/MATLAB/Li_Ellingwood_Eart.mat');

Sa = round(Sa, 2);

index = find(Sa == IM);

P_ex1 = prob_minor(index);
P_ex2 = prob_mod(index);
P_ex3 = prob_sev(index);

if flag == 1
    P_req = [P_ex1; P_ex2; P_ex3];
else
    P_req = [(1-P_ex1); (P_ex1-P_ex2); (P_ex2-P_ex3); (P_ex3)];
end

P_req(isnan(P_req)) = 0;

P_req = abs(P_req);