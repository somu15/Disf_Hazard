function [RESULT, States] = Simulate_3state_rec(IM, Hazard, T, dt, Nsims)

% tr = 1:7000;
% 
% if strcmp(Hazard,'E') == 1
%     
%     [tot_time] = Rep_dists_Li_Ell_Eq_Char_SMPRESS(tr, IM);
% else
%     
%     [tot_time] = Rep_dists_Li_Ell_Hurr_Char_SMPRESS(tr, IM);
% end
% 
% States = zeros(10000,5000);
% tot_time(1,1) = 0;
% tot_time(2,1) = 0;
% 
% for ii = 1:10000
%     
%     [x1, index] = unique(tot_time(1,:));
%     Times(ii,1) = interp1(x1, tr(index), rand);
%     [x2, index] = unique(tot_time(2,:));
%     Times(ii,2) = interp1(x2, tr(index), rand);
%     
%     if round(Times(ii,1))==0
%         Times(ii,1) = 1;
%     end
%     
%     if isnan(round(Times(ii,1)))==1 || isnan(round(Times(ii,1)+Times(ii,2)))==1
%         ii=ii-1;
%         continue
%     end
%     
%     States(ii,round(Times(ii,1)):round(Times(ii,1)+Times(ii,2))) = 0.5;
%     States(ii,round(Times(ii,1)+Times(ii,2)+1):7000) = 1;
%     
% end
% 
% if length(mean(States))~=length(tr)
%     tmp = mean(States);
% RESULT = [tmp(1:7000); tr];
% else
% RESULT = [mean(States); tr];
% end

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
    
%     if isnan(round(Times(ii,1)))==1 || isnan(round(Times(ii,1)+Times(ii,2)))==1
%         ii=ii-1;
%         continue
%     end

if isnan(round(Times(ii,1)))==1
    Times(ii,1) = 0;
elseif isnan(round(Times(ii,2)))==1
    Times(ii,2) = 0;
%     elseif isnan(round(Times(ii,3)))==1
%     Times(ii,3) = 0;
%     elseif isnan(round(Times(ii,4)))==1
%     Times(ii,4) = 0;
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