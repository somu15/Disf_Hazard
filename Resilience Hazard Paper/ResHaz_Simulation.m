clr
% 
%% Single hazard

clr

% IM = 0.01:0.01:2; dIM = 0.01;
IM = 10:5:125; dIM = 5;
T = 1000; dt = 1; Nsims = 1000;

for ii = 1:length(IM)
    
    [res] = Simulate_3state_rec(IM(ii),'H', T, dt, Nsims);
    
    % resilience(ii) = trapz(res(2,:),res(1,:));
    
    resil(ii,:) = res(1,:);
    
    progressbar(ii/length(IM))
    
end

% load('C:\Users\lakshd5\Dropbox\MultiHazards\Disf_Hazard\Resilience Hazard Paper\Data\Hazards data\Charleston_Haz.mat');
% 
% hazr = exp(interp1(log(im),log(haz),log(IM)));

hazr = 1-wblcdf(IM,26.8,1.86);

hazr_diff = abs(Differentiation(dIM,hazr));

tr = 1:1:T;
for ii = 1:length(tr)
    
    resH(ii) = trapz(IM,(1-resil(:,ii)).*hazr_diff');
    
end



% clearvars -except tr resH
% 
% IM = 0.01:0.01:2;
% T = 5000; dt = 1; Nsims = 5000;
% 
% for ii = 1:length(IM)
%     
%     [res] = Simulate_3state_rec(IM(ii), 'E', T, dt, Nsims);
%     
%     % resilience(ii) = trapz(res(2,:),res(1,:));
%     
%     resil(ii,:) = res(1,:);
%     
%     progressbar(ii/length(IM))
%     
% end
% 
% haz = importdata('C:\Users\lakshd5\Dropbox\Site Response IM Selection\Hazard Info\Hazard curve\Sa0.2.txt');
% 
% hazr = exp(interp1(log(haz(:,1)),log(haz(:,2)),log(IM)));
% hazr_diff = abs(Differentiation(0.01,hazr));
% 
% tr1 = 1:dt:T;
% for ii = 1:length(tr1)
%     
%     resH1(ii) = trapz(IM,(1-resil(:,ii)).*hazr_diff');
%     
% end
% loglog(tr,resH,tr1,resH1)
%% Two states PBEE comparison

clr
IM = 0.01:0.01:2;
T = 7000;
tr = 1:T;

for ii = 1:length(IM)
    
    [tot_time] = Rep_dists_Li_Ell_Eq_Char_SMPRESS(tr, IM(ii));
    tot_time(1,1) = 0;
    tot_time(2,1) = 0;
    
    % resilience(ii) = trapz(res(2,:),res(1,:));
    
    resil(ii,:) = tot_time(1,:);
    
    progressbar(ii/length(IM))
    
end

load('C:\Users\lakshd5\Dropbox\MultiHazards\Disf_Hazard\Resilience Hazard Paper\Data\Hazards data\Charleston_Haz.mat');

hazr = exp(interp1(log(im),log(haz),log(IM)));
hazr_diff = abs(Differentiation(0.01,hazr));

tr = 1:1:T;
for ii = 1:length(tr)
    
    resH(ii) = trapz(IM,(1-resil(:,ii)).*hazr_diff');
    
end

%% Multihazard disfunctionality

clr

IMe = 0.85; % 0.01:0.05:2; 
IMh = 75; % 20:5:150;
T = 2000; dt = 1; Nsims = 300;

N_rand = 1; mu_T = 356;

count = 0;

for ii = 1:length(IMe)
    for jj = 1:length(IMh)
        
        count = count + 1;
        
        tmp = zeros(1,length(1:dt:T));
        
        for kk = 1:N_rand
    
            [res_fin] = Simulate_MH_rec(IMe(ii), IMh(jj), 150, T, dt, Nsims, 'E');% exprnd(mu_T)
            tmp = tmp + res_fin(2,:);
    
        end
        
        res_REQ(ii,jj,:) = tmp;
        
        
    
    % resilience(ii) = trapz(res(2,:),res(1,:));
    
    progressbar(count/(length(IMe)*length(IMh)))
    
    end
end

%% Monte Carlo and analytical comparison (Multihazard)

IMe = 1.5; IMh = 65; T = 150;

res = STRSAF_MH(IMe, IMh, T);
res_AN_t = res(3,:); res_AN_y = res(1,:);

[res, States] = Simulate_MH_rec(IMe, IMh, T, 3000, 1, 1000, 'E');
res_MC_t = res(1,:); res_MC_y = res(2,:);

plot(res_MC_t,res_MC_y,res_AN_t,res_AN_y)


%% Monte Carlo and analytical comparison (Single hazard)

IMe = 1.5; IMh = 65; T = 15000;

res = STRSAF_MH(IMe, IMh, T);
res_AN_t = res(3,:); res_AN_y = res(1,:);

[res, States] = Simulate_3state_rec(IMe,'E', 3000, 1, 1000);
res_MC_t = res(2,:); res_MC_y = res(1,:);

plot(res_MC_t,res_MC_y,res_AN_t,res_AN_y)

%% Sharma et al. paper issue

%% MH res demo

clr
IMe = 0.81; IMh = 60; T = 150;

NMC = 10;
for ii = 1:NMC

[res, States] = Simulate_MH_rec(IMe, IMh, exprnd(T), 3000, 1, 300, 'E');
tr = res(1,:); res_MC(ii,:) = res(2,:);

progressbar(ii/NMC)

end


%% MH hazard

clr
load('C:\Users\lakshd5\Dropbox\MultiHazards\Disf_Hazard\Resilience Hazard Paper\Data\40IMe_27IMh_300Sims.mat')

load('C:\Users\lakshd5\Dropbox\MultiHazards\Disf_Hazard\Resilience Hazard Paper\Data\Hazards data\Charleston_Haz.mat');
dIMe = 0.05; dIMh = 5;

hazr_E = exp(interp1(log(im),log(haz),log(IMe)));

hazr_H = 1-wblcdf(IMh,26.8,1.86);

hazr_diff_E = abs(Differentiation(dIMe,hazr_E));
hazr_diff_H = abs(Differentiation(dIMh,hazr_H));

tr = 1:1:T;

resH = zeros(length(tr),1);

for kk=1:length(tr)
tmp = reshape(res_REQ(:,:,kk),length(IMe),length(IMh));
for ii = 1:length(IMe)
    for jj = 1:length(IMh)
    
    resH(kk) = resH(kk)+(1-tmp(ii,jj)/N_rand)*hazr_diff_E(ii)*hazr_diff_H(jj);
    
    end
end
end

loglog(tr,resH)
hold on



load('C:\Users\lakshd5\Dropbox\MultiHazards\Disf_Hazard\Resilience Hazard Paper\Data\40IMe_27IMh_300Sims_NoMH.mat')

load('C:\Users\lakshd5\Dropbox\MultiHazards\Disf_Hazard\Resilience Hazard Paper\Data\Hazards data\Charleston_Haz.mat');
dIMe = 0.05; dIMh = 5;

hazr_E = exp(interp1(log(im),log(haz),log(IMe)));

hazr_H = 1-wblcdf(IMh,26.8,1.86);

hazr_diff_E = abs(Differentiation(dIMe,hazr_E));
hazr_diff_H = abs(Differentiation(dIMh,hazr_H));

tr = 1:1:T;

resH = zeros(length(tr),1);

for kk=1:length(tr)
tmp = reshape(res_REQ(:,:,kk),length(IMe),length(IMh));
for ii = 1:length(IMe)
    for jj = 1:length(IMh)
    
    resH(kk) = resH(kk)+(1-tmp(ii,jj)/N_rand)*hazr_diff_E(ii)*hazr_diff_H(jj);
    
    end
end
end

loglog(tr,(resH))
xlim([0 1000])