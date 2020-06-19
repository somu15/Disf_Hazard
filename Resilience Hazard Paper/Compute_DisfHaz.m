function [disF] = Compute_DisfHaz(t, res, dHaz1, dHaz2, N, dIM1, dIM2)

for kk = 1:length(t)
    
    req = 1-reshape(res(:,:,t(kk)),length(dHaz1),length(dHaz2))/N;
    
    s= 0;

for ii = 1:length(dHaz1)
    for jj = 1:length(dHaz2)
        
        s = s + req(ii,jj)*dHaz1(ii)*dHaz2(jj)*dIM1*dIM2;
        
    end
end

disF(kk) = s;

end

end