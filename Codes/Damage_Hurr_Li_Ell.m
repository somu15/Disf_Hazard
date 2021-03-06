function [P_req] = Damage_Hurr_Li_Ell(IM, flag)

% DESCRIPTION: Computes the damage functions for the wooden building under hurricane
% winds.

% INPUTS:
% IM = Wind intensity in m/s (scalar or vector)
% flag = 1 => Exceedence Probabilities
% flag = 0 => Equivalence Probabilities

% OUTPUTS:
% P_req = Damage functions for different IM levels. The four rows correspond to the
% four damage states, none, light, moderate, and severe.

IM = round(IM,2);

load('Li_Ellingwood_Hurr.mat');

wind = round(wind,2);

index = find(wind == IM);

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
