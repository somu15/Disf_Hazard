%% Multihazards

clr

t_tot = 3000;

IMe = exp(linspace(-4.6052,0.6931,20));
IMh = exp(linspace(2.9957,5.0106,20));
dt = exp(linspace(3.4012,6.5511,20));

count = 0;
for ii = 1:length(IMe)
    for jj = 1:length(IMh)
        for kk = 1:length(dt)
            
            res = ResHaz_MH(IMe(ii), IMh(jj), dt(kk));
            
            resF_wd(ii,jj,kk,:) = res(1,:);
            resF_wod(ii,jj,kk,:) = res(2,:);
            count = count + 1;
            progressbar(count/(length(IMe)*length(IMh)*length(dt)))
            
            
        end
    end
end
    
   
    
    
    

%% Single hazard

IM = 0.01:0.01:2;
T = 3000;

for ii = 1:length(IM)
    
    [res] = SingleHazard_Rec(IM(ii), 'E', T);
    
    % resilience(ii) = trapz(res(2,:),res(1,:));
    
    resil(ii,:) = res(1,:);
    
    progressbar(ii/length(IM))
    
end

haz = importdata('C:\Users\lakshd5\Dropbox\Site Response IM Selection\Hazard Info\Hazard curve\Sa0.2.txt');

hazr = exp(interp1(log(haz(:,1)),log(haz(:,2)),log(IM)));
hazr_diff = abs(Differentiation(0.01,hazr));

tr = 1:10:T;
for ii = 1:length(tr)
    
    resH(ii) = trapz(IM,(1-resil(:,ii)).*hazr_diff');
    
end

ressto = resil;
clearvars -except IM resH tr ressto

T = 6000;

for ii = 1:length(IM)
    
    [res] = SingleHazard_Rec(IM(ii), 'E', T);
    
    % resilience(ii) = trapz(res(2,:),res(1,:));
    
    resil(ii,:) = res(1,:);
    
    progressbar(ii/length(IM))
    
end

haz = importdata('C:\Users\lakshd5\Dropbox\Site Response IM Selection\Hazard Info\Hazard curve\Sa0.2.txt');

hazr = exp(interp1(log(haz(:,1)),log(haz(:,2)),log(IM)));
hazr_diff = abs(Differentiation(0.01,hazr));

tr1 = 1:10:T;
for ii = 1:length(tr1)
    
    resH1(ii) = trapz(IM,(1-resil(:,ii)).*hazr_diff');
    
end

loglog(tr,resH,'o')
hold on
loglog(tr1,resH1)

%% Process MH data

clr
load('C:\Users\lakshd5\Dropbox\MultiHazards\Resilience Hazard Paper\MH_1.mat')

for ii = 1:length(IMe)
    
    plot(reshape(resF_wd(ii,1,1,:),3000,1))
    hold on
    plot(reshape(resF_wd(ii,1,10,:),3000,1))
    hold on
    plot(reshape(resF_wd(ii,1,20,:),3000,1))

% sto1(ii) = resF_wd(ii,1,1,300);
% sto2(ii) = resF_wd(ii,1,10,300);
% sto3(ii) = resF_wd(ii,1,20,300);
    
end

% plot(IMe,1-sto1)
% hold on
% plot(IMe,1-sto2)
% hold on
% plot(IMe,1-sto3)

%% Single hazard
clr
% IM = 0.01:0.01:4;
IM =exp(-9.2103:0.01:1.3863);
for ii = 1:length(IM)
    
    [res] = SingleHazard_Rec(IM(ii), 'E');
    
    % resilience(ii) = trapz(res(2,:),res(1,:));
    
    resil(ii,:) = res(1,:);
    
    progressbar(ii/length(IM))
    
end

haz = importdata('C:\Users\lakshd5\Dropbox\Site Response IM Selection\Hazard Info\Hazard curve\Sa0.2.txt');

hazr = exp(interp1(log(haz(:,1)),log(haz(:,2)),log(IM)));
hazr_diff = abs(Differentiation(0.01,hazr));

resil(resil>0.9999) = 1;

prob_res = 1-resil;

for ii = 1:600
    mul = prob_res(:,ii);%cumsum(prob_res(:,ii)/sum(prob_res(:,ii)));
    cdfs(ii,:) = cumsum(prob_res(:,ii)/sum(prob_res(:,ii)));
    resH(ii) = trapz(IM,mul.*hazr_diff');
    
end

loglog(res(2,:),resH)
