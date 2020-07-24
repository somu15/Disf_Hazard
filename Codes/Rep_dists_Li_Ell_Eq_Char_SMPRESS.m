function [tot_time] = Rep_dists_Li_Ell_Eq_Char_SMPRESS(t, Sa)

% DESCRIPTION: This function computes the transition time distributions for a wooden
% building with three recovery states and subjected to earthquakes.

% INPUTS:
% t = required time values (vector)
% Sa = Sa(0.2s) intensity in g (scalar)

% OUTPUTS:
% tot_time = CDF values of the input time values. First row is for transition from
% state 1 to 2. Second row is for transition from state 2 to 3.

low = 1e-3;
Times = [low low;30 0;210 120;455 low];
N_states = 4;

tot_time1 = 0; tot_time2 = 0;
[P_eq] = Damage_Earthquakes_Li_Ell(Sa, 0);

    for jj = 1:N_states

        tot_time1 = tot_time1 + logncdf((t), log(Times(jj,1)), 0.75)*P_eq(jj);
        tot_time2 = tot_time2 + logncdf((t), log(Times(jj,2)), 0.75)*P_eq(jj);

    end

tot_time = [(tot_time1);(tot_time2)];
