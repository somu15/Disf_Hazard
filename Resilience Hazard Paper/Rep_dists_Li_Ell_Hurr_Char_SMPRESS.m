function [tot_time] = Rep_dists_Li_Ell_Hurr_Char_SMPRESS(t, Wind)

flag_rand = 0; Work_hours = 8;

% T_insp = 30; % Inspection time
% T_func = 60; % Time to restore functionality
% T_asm = 60; % Time to conduct engg assessment
% T_occ = mean(T_Occ( flag_rand, Work_hours)); % Time to conduct repairs
% T_mob = ([0;0;120;365;365]); % Time to mobilize resources
% T_rep = 365; % Time to replace the building
std_req = 0.4;

low = 1e-3;
% Times = [low low;T_insp T_func;(T_insp+T_asm+T_mob(3)+T_occ) T_func;(T_asm+T_mob(4)+T_rep) low];

Times = [low low;5 low;240 120;540 low];

std_req_sum = [std_req std_req;std_req std_req;sqrt(std_req^2+std_req^2+std_req^2+std_req^2) std_req;sqrt(std_req^2+std_req^2+std_req^2) std_req];

N_states = 4;

tot_time1 = 0; tot_time2 = 0;

    [P_eq] = Damage_Hurr_Li_Ell(Wind,0);
    
    
    for jj = 1:N_states
        
        tot_time1 = tot_time1 + raylcdf(t,0.8*Times(jj,1))*P_eq(jj);
        tot_time2 = tot_time2 + raylcdf(t,0.8*Times(jj,2))*P_eq(jj);
    
    end

tot_time = [(tot_time1);(tot_time2)];

