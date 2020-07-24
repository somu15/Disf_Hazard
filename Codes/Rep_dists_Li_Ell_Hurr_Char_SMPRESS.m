function [tot_time] = Rep_dists_Li_Ell_Hurr_Char_SMPRESS(t, Wind)

% DESCRIPTION: This function computes the transition time distributions for a wooden
% building with three recovery states and subjected to hurricane winds.

% INPUTS:
% t = required time values (vector)
% Wind = Wind intensity in m/s (scalar)

% OUTPUTS:
% tot_time = CDF values of the input time values. First row is for transition from
% state 1 to 2. Second row is for transition from state 2 to 3.

low = 1e-3;
Times = [low low;5 low;240 120;540 low];
N_states = 4;

tot_time1 = 0; tot_time2 = 0;
[P_eq] = Damage_Hurr_Li_Ell(Wind,0);

    for jj = 1:N_states

        tot_time1 = tot_time1 + raylcdf(t,0.8*Times(jj,1))*P_eq(jj);
        tot_time2 = tot_time2 + raylcdf(t,0.8*Times(jj,2))*P_eq(jj);

    end

tot_time = [(tot_time1);(tot_time2)];
