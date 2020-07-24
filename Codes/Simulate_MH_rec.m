function [res_fin, States] = Simulate_MH_rec(IM_E, IM_H, T_int, T, dt, NSims, H1, flag)

% DESCRIPTION: Simulate a multihazard recovery curve with
% earthquake-hurricane or hurricane-earthquake sequence.

% INPUTS:
% IM_E = Earthquake intensity as Sa(0.2s) in g
% IM_H = Hurricane wind intensity in m/s
% T_int = Inter-arrival time between the hazards
% T = Maximum time value for the recovery curve. 1000 days maybe a good
% value
% dt = Time step size for the recovery curve. 1 day maybe a good value
% NSims = Number of Monte Carlo simulations. 400 maybe a good value
% H1 = The first hazard in the sequence. 'H' for hurricane or 'E' for
% earthquake
% flag = 1 for consider temporal dependencies or 0 for ignore them

% OUTPUTS:
% res_fin = First row is the time values. Second row is the recovery curve.
% States = State indices of the system during recovery. Useful for
% computing the transition probability matrix.

tr = 1:dt:T;

if strcmp(H1,'E') == 1

    [tot_time1] = Rep_dists_Li_Ell_Eq_Char_SMPRESS(tr, IM_E);
    [tot_time2] = Rep_dists_Li_Ell_Hurr_Char_SMPRESS(tr, IM_H);

else

    [tot_time2] = Rep_dists_Li_Ell_Eq_Char_SMPRESS(tr, IM_E);
    [tot_time1] = Rep_dists_Li_Ell_Hurr_Char_SMPRESS(tr, IM_H);

end

tot_time1(1,1) = 0;
tot_time1(2,1) = 0;
tot_time2(1,1) = 0;
tot_time2(2,1) = 0;

[result_1, P11, P22] = Simulate_rec(tr, tot_time1(1,:), tot_time1(2,:), NSims);

[ d, ind_crit] = min( abs( tr-(T_int)));
P11_new = P11(ind_crit:length(P11));
P11_new = [0 1-P11_new];
P22_new = P22(ind_crit:length(P22));
P22_new = [0 1-P22_new];
if length(P11_new) > length(tr)
    tr_new = tr;
    P11_new = P11_new(1:length(tr));
    P22_new = P22_new(1:length(tr));
else

tr_new = tr(1:length(P11_new));
end

for ii = 1:NSims

    [x1, index] = unique(P11_new);
    Times(ii,1) = interp1(x1, tr_new(index), rand);
    [x1, index] = unique(tot_time2(1,:));
    
    if flag == 1
        Times(ii,1) = Times(ii,1)+interp1(x1, tr(index), rand);
    else
        Times(ii,1) = interp1(x1, tr(index), rand);
    end

    [x2, index] = unique(P22_new);
    Times(ii,2) = interp1(x2, tr_new(index), rand);
    [x2, index] = unique(tot_time2(2,:));
    
    if flag == 1
        Times(ii,2) = Times(ii,2)+interp1(x2, tr(index), rand);
    else
        Times(ii,2) = interp1(x2, tr(index), rand);
    end


    if round(Times(ii,1))==0
        Times(ii,1) = 1;
    end

    if isnan(round(Times(ii,1)))==1 || isnan(round(Times(ii,1)+Times(ii,2)))==1
        ii=ii-1;
        continue
    end

    [ d, ind1] = min( abs( tr-(Times(ii,1))));
    [ d, ind2] = min( abs( tr-(Times(ii,1)+Times(ii,2))));

    States(ii,ind1:ind2) = 0.5;
    States(ii,(ind2+1):length(tr)) = 1;

end

if length(mean(States))~=length(tr)
    tmp = mean(States);
RESULT = [tmp(1:length(tr))];
else
RESULT = [mean(States)];
end

tmp = [result_1(1:ind_crit) RESULT];
res_fin = [tr;tmp(1:length(tr))];

end
