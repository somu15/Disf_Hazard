function [res_fin, States] = Simulate_MH_rec_5States_wo(IM1, IM2, T_int, T, dt, NSims)

% for ss = 1:NSims_T

tr = 1:dt:T;
%res_fin = zeros(1,length(tr));
%T_int = exprnd(mean_int);

% if strcmp(H1,'E') == 1
%     
%     [tot_time1] = Rep_dists_Li_Ell_Eq_Char_SMPRESS(tr, IM_E);
%     [tot_time2] = Rep_dists_Li_Ell_Hurr_Char_SMPRESS(tr, IM_H);
%     
% else
%     
%     [tot_time2] = Rep_dists_Li_Ell_Eq_Char_SMPRESS(tr, IM_E);
%     [tot_time1] = Rep_dists_Li_Ell_Hurr_Char_SMPRESS(tr, IM_H);
%     
% end
% 
% tot_time1(1,1) = 0;
% tot_time1(2,1) = 0;
% tot_time2(1,1) = 0;
% tot_time2(2,1) = 0;

[tot_time] = Rep_dists_5States(tr, IM2);
tot_time(1,1) = 0;
tot_time(2,1) = 0;
tot_time(3,1) = 0;
tot_time(4,1) = 0;

% [result_1, P11, P22] = Simulate_5state_rec(IM1, T, dt, NSims);
[result_1, P11, P22, P33, P44] = Simulate_5state_rec(IM1, T, dt, NSims);

[ d, ind_crit] = min( abs( tr-(T_int)));
P11_new = P11(ind_crit:length(P11));
P11_new = [0 1-P11_new];
P22_new = P22(ind_crit:length(P22));
P22_new = [0 1-P22_new];
P33_new = P33(ind_crit:length(P33));
P33_new = [0 1-P33_new];
P44_new = P44(ind_crit:length(P44));
P44_new = [0 1-P44_new];

if length(P11_new) > length(tr)
    tr_new = tr;
    P11_new = P11_new(1:length(tr));
    P22_new = P22_new(1:length(tr));
    P33_new = P33_new(1:length(tr));
    P44_new = P44_new(1:length(tr));
else
    
tr_new = tr(1:length(P11_new));
end

for ii = 1:NSims
    
    [x1, index] = unique(P11_new);
    Times(ii,1) = interp1(x1, tr_new(index), rand);
    [x1, index] = unique(tot_time(1,:));
    Times(ii,1) = Times(ii,1)+interp1(x1, tr(index), rand);
    Times(ii,1) = interp1(x1, tr(index), rand);
    
    [x2, index] = unique(P22_new);
    Times(ii,2) = interp1(x2, tr_new(index), rand);
    [x2, index] = unique(tot_time(2,:));
    Times(ii,2) = Times(ii,2)+interp1(x2, tr(index), rand);
    Times(ii,2) = interp1(x2, tr(index), rand);
    
    [x3, index] = unique(P33_new);
    Times(ii,3) = interp1(x3, tr_new(index), rand);
    [x3, index] = unique(tot_time(3,:));
    Times(ii,3) = Times(ii,3)+interp1(x3, tr(index), rand);
    Times(ii,3) = interp1(x3, tr(index), rand);
    
    [x4, index] = unique(P44_new);
    Times(ii,4) = interp1(x4, tr_new(index), rand);
    [x4, index] = unique(tot_time(4,:));
    Times(ii,4) = Times(ii,4)+interp1(x4, tr(index), rand);
    Times(ii,4) = interp1(x4, tr(index), rand);
    
    if round(Times(ii,1))==0
        Times(ii,1) = 1;
    end
    
    if isnan(round(Times(ii,1)))==1 || isnan(round(Times(ii,1)+Times(ii,2)))==1 || isnan(round(Times(ii,1)+Times(ii,2)+Times(ii,3)))==1 || isnan(round(Times(ii,1)+Times(ii,2)+Times(ii,3)+Times(ii,4)))==1 
        ii=ii-1;
        continue
    end
    
    [ d, ind1] = min( abs( tr-(Times(ii,1))));
    [ d, ind2] = min( abs( tr-(Times(ii,1)+Times(ii,2))));
    [ d, ind3] = min( abs( tr-(Times(ii,1)+Times(ii,2)+Times(ii,3))));
    [ d, ind4] = min( abs( tr-(Times(ii,1)+Times(ii,2)+Times(ii,3)+Times(ii,4))));
    
    
    States(ii,ind1:ind2) = 0.25;
    States(ii,(ind2+1):ind3) = 0.5;
    States(ii,(ind3+1):ind4) = 0.75;
    States(ii,(ind4+1):length(tr)) = 1;
    
end

if length(mean(States))~=length(tr)
    tmp = mean(States);
RESULT = [tmp(1:length(tr))];
else
RESULT = [mean(States)];
end

tmp = [result_1(1,1:ind_crit) RESULT];
res_fin = [tr;tmp(1:length(tr))];

% end
% 
% res_fin = res_fin/NSims_T;
% res_req = [tr;res_fin];

end