function [RESULT, P11, P22] = Simulate_rec(tr, F1, F2, Nsims)

for ii = 1:Nsims
    
    [x1, index] = unique(F1);
    Times(ii,1) = interp1(x1, tr(index), rand);
    [x2, index] = unique(F2);
    Times(ii,2) = interp1(x2, tr(index), rand);
    
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

for ii = 1:length(tr)
    
    tmp1 = length(find(Times(:,1)<=tr(ii) & (Times(:,1)+Times(:,2))>tr(ii)));
    tmp2 = length(find((Times(:,1)+Times(:,2))<=tr(ii)));
    % sto(ii) = tmp1/Nsims;
    P11(ii) = 1-tmp2/Nsims-tmp1/Nsims;
    
    tmp3 = length(find(Times(:,2)<=tr(ii)));
    P22(ii) = 1-(tmp3)/Nsims;
    
end

if length(mean(States))~=length(tr)
    tmp = mean(States);
RESULT = [tmp(1:length(tr))];
else
RESULT = [mean(States)];
end

end