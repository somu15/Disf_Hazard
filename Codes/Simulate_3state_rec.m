function [RESULT, States] = Simulate_3state_rec(IM, Hazard, T, dt, Nsims)

% DESCRIPTION: This function simulates the recovery curve for a system with three
% recovery states.

% INPUTS:
% IM = The hazard intensity. Sa(0.2s) in g for earthquake or wind speed in m/s for
% hurricane
% Hazard = 'H' for hurricane or 'E' for earthquake
% T = Maximum time to be considered. 1000 days maybe a good value.
% dt = Time step size. 1 day maybe a good value.
% Nsims = Number of Monte Carlo samples. 400 maybe a good value.

% OUTPUTS:
% RESULT = Functionality recovery curve in the first row; time values in the second
% row.
% States = State indices at different times. Useful for computing the transition
% probability matrix.

tr = 1:dt:T;

if strcmp(Hazard,'E') == 1

    [tot_time] = Rep_dists_Li_Ell_Eq_Char_SMPRESS(tr, IM);
elseif strcmp(Hazard,'H') == 1

    [tot_time] = Rep_dists_Li_Ell_Hurr_Char_SMPRESS(tr, IM);
else
    [tot_time] = Rep_dists_3States(tr, IM);
end

States = zeros(Nsims,length(tr));
tot_time(1,1) = 0;
tot_time(2,1) = 0;

for ii = 1:Nsims

    [x1, index] = unique(tot_time(1,:));
    Times(ii,1) = interp1(x1, tr(index), rand);
    [x2, index] = unique(tot_time(2,:));
    Times(ii,2) = interp1(x2, tr(index), rand);

    if round(Times(ii,1))==0
        Times(ii,1) = 1;
end

if isnan(round(Times(ii,1)))==1
    Times(ii,1) = 0;
elseif isnan(round(Times(ii,2)))==1
    Times(ii,2) = 0;
end

    [ d, ind1] = min( abs( tr-(Times(ii,1))));
    [ d, ind2] = min( abs( tr-(Times(ii,1)+Times(ii,2))));

    States(ii,ind1:ind2) = 0.5;
    States(ii,(ind2+1):length(tr)) = 1;

end

if length(mean(States))~=length(tr)
    tmp = mean(States);
RESULT = [tmp(1:length(tr)); tr];
else
RESULT = [mean(States); tr];
end

end
