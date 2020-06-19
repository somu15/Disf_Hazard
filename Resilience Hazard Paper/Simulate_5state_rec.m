function [RESULT, P11, P22, P33, P44] = Simulate_5state_rec(IM, T, dt, Nsims)

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

% if strcmp(Hazard,'E') == 1
    
    [tot_time] = Rep_dists_5States(tr, IM);
% else
%     
%     [tot_time] = Rep_dists_Li_Ell_Hurr_Char_SMPRESS(tr, IM);
% end

States = zeros(Nsims,length(tr));
tot_time(1,1) = 0;
tot_time(2,1) = 0;

% for ii = 1:Nsims
%     
%     [x1, index] = unique(tot_time(1,:));
%     Times(ii,1) = interp1(x1, tr(index), rand);
%     [x2, index] = unique(tot_time(2,:));
%     Times(ii,2) = interp1(x2, tr(index), rand);
%     [x3, index] = unique(tot_time(3,:));
%     Times(ii,3) = interp1(x3, tr(index), rand);
%     [x4, index] = unique(tot_time(4,:));
%     Times(ii,4) = interp1(x4, tr(index), rand);
%     
%     if round(Times(ii,1))==0
%         Times(ii,1) = 1;
%     end
%     
%     if isnan(round(Times(ii,1)))==1 || isnan(round(Times(ii,1)+Times(ii,2)))==1 || isnan(round(Times(ii,1)+Times(ii,2)+Times(ii,3)))==1 || isnan(round(Times(ii,1)+Times(ii,2)+Times(ii,3)+Times(ii,4)))==1
%         ii=ii-1;
%         continue
%     end
%     
%     [ d, ind1] = min( abs( tr-(Times(ii,1))));
%     [ d, ind2] = min( abs( tr-(Times(ii,1)+Times(ii,2))));
%     [ d, ind3] = min( abs( tr-(Times(ii,1)+Times(ii,2)+Times(ii,3))));
%     [ d, ind4] = min( abs( tr-(Times(ii,1)+Times(ii,2)+Times(ii,3)+Times(ii,4))));
%     
%     States(ii,ind1:ind2) = 0.25;
%     States(ii,(ind2+1):ind3) = 0.5;
%     States(ii,(ind3+1):ind4) = 0.75;
%     States(ii,(ind4+1):length(tr)) = 1;
%     
% end
ii = 1;
while ii <= Nsims
    
    [x1, index] = unique(tot_time(1,:));
    Times(ii,1) = interp1(x1, tr(index), rand);
    [x2, index] = unique(tot_time(2,:));
    Times(ii,2) = interp1(x2, tr(index), rand);
    [x3, index] = unique(tot_time(3,:));
    Times(ii,3) = interp1(x3, tr(index), rand);
    [x4, index] = unique(tot_time(4,:));
    Times(ii,4) = interp1(x4, tr(index), rand);
    
    if round(Times(ii,1))==0
        Times(ii,1) = 1;
    end
    
%     if isnan(round(Times(ii,1)))==1 || isnan(round(Times(ii,1)+Times(ii,2)))==1 || isnan(round(Times(ii,1)+Times(ii,2)+Times(ii,3)))==1 || isnan(round(Times(ii,1)+Times(ii,2)+Times(ii,3)+Times(ii,4)))==1
%         % ii=ii-1;
%         continue
%     end

% if isnan(round(Times(ii,1)))==1
%     Times(ii,1) = 0;
% elseif isnan(round(Times(ii,2)))==1
%     Times(ii,2) = 0;
% elseif isnan(round(Times(ii,3)))==1
% Times(ii,3) = 0;
% elseif isnan(round(Times(ii,4)))==1
% Times(ii,4) = 0;
% %     elseif isnan(round(Times(ii,5)))==1
% %     Times(ii,4) = 0;
% end

Times(isnan(Times)) = 0;
    
    [ d, ind1] = min( abs( tr-(Times(ii,1))));
    [ d, ind2] = min( abs( tr-(Times(ii,1)+Times(ii,2))));
    [ d, ind3] = min( abs( tr-(Times(ii,1)+Times(ii,2)+Times(ii,3))));
    [ d, ind4] = min( abs( tr-(Times(ii,1)+Times(ii,2)+Times(ii,3)+Times(ii,4))));
    
    States(ii,ind1:ind2) = 0.25;
    States(ii,(ind2+1):ind3) = 0.5;
    States(ii,(ind3+1):ind4) = 0.75;
    States(ii,(ind4+1):length(tr)) = 1;
    
    ii = ii + 1;
    
end

for ii = 1:length(tr)
    
    tmp1 = length(find(Times(:,1)<=tr(ii) & (Times(:,1)+Times(:,2))>tr(ii)));
    tmp2 = length(find((Times(:,1)+Times(:,2))<=tr(ii) & (Times(:,1)+Times(:,2)+Times(:,3))>tr(ii)));
    tmp3 = length(find((Times(:,1)+Times(:,2)+Times(:,3))<=tr(ii) & (Times(:,1)+Times(:,2)+Times(:,3)+Times(:,4))>tr(ii)));
    tmp4 = length(find((Times(:,1)+Times(:,2)+Times(:,3)+Times(:,4))<=tr(ii)));
    % tmp5 = length(find((Times(:,1)+Times(:,2)+Times(:,3)+Times(:,4)+Times(:,5))<=tr(ii)));
    % sto(ii) = tmp1/Nsims;
    P11(ii) = 1-tmp1/Nsims-tmp2/Nsims-tmp3/Nsims-tmp4/Nsims;
    
    % tmp1 = length(find(Times(:,1)<=tr(ii) & (Times(:,1)+Times(:,2))>tr(ii)));
    tmp2 = length(find((Times(:,2))<=tr(ii) & (Times(:,2)+Times(:,3))>tr(ii)));
    tmp3 = length(find((Times(:,2)+Times(:,3))<=tr(ii) & (Times(:,2)+Times(:,3)+Times(:,4))>tr(ii)));
    tmp4 = length(find((Times(:,2)+Times(:,3)+Times(:,4))<=tr(ii)));
    % tmp5 = length(find((Times(:,2)+Times(:,3)+Times(:,4)+Times(:,5))<=tr(ii)));
    P22(ii) = 1-tmp2/Nsims-tmp3/Nsims-tmp4/Nsims;
    
    % tmp1 = length(find(Times(:,1)<=tr(ii) & (Times(:,1)+Times(:,2))>tr(ii)));
    % tmp2 = length(find((Times(:,2))<=tr(ii) & (Times(:,2)+Times(:,3))>tr(ii)));
    tmp3 = length(find((Times(:,3))<=tr(ii) & (Times(:,3)+Times(:,4))>tr(ii)));
    tmp4 = length(find((Times(:,3)+Times(:,4))<=tr(ii)));
    % tmp5 = length(find((Times(:,3)+Times(:,4)+Times(:,5))<=tr(ii)));
    P33(ii) = 1-tmp3/Nsims-tmp4/Nsims;
    
    % tmp1 = length(find(Times(:,1)<=tr(ii) & (Times(:,1)+Times(:,2))>tr(ii)));
    % tmp2 = length(find((Times(:,2))<=tr(ii) & (Times(:,2)+Times(:,3))>tr(ii)));
    % tmp3 = length(find((Times(:,3))<=tr(ii) & (Times(:,3)+Times(:,4))>tr(ii)));
    tmp4 = length(find((Times(:,4))<=tr(ii)));
    % tmp5 = length(find((Times(:,4)+Times(:,5))<=tr(ii)));
    P44(ii) = 1-tmp4/Nsims;
    
    % tmp1 = length(find(Times(:,1)<=tr(ii) & (Times(:,1)+Times(:,2))>tr(ii)));
    % tmp2 = length(find((Times(:,2))<=tr(ii) & (Times(:,2)+Times(:,3))>tr(ii)));
    % tmp3 = length(find((Times(:,3))<=tr(ii) & (Times(:,3)+Times(:,4))>tr(ii)));
    % tmp4 = length(find((Times(:,4))<=tr(ii) & (Times(:,4)+Times(:,5))>tr(ii)));
%     tmp5 = length(find((Times(:,5))<=tr(ii)));
%     P55(ii) = 1-tmp5/Nsims;
    
end

if length(mean(States))~=length(tr)
    tmp = mean(States);
RESULT = [tmp(1:length(tr)); tr];
else
RESULT = [mean(States); tr];
end

end