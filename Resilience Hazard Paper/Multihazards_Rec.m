function [RESULT] = Multihazards_Rec(IMe, IMh, dt)

% IMe = 0.75; IMh = 60;%[50 65 80 95 110 125 140 155];

% dtv = [50 100 150 200 250 300 350 400 450 500 550 600 650 700 750 800];

sims = 1;
count = 0;

    
for mm = 1:sims

   
    
NH = 2;
% dt = 150;%exprnd(365,NH-1,1);
T = 2000;
dt = [0;dt;T];

% l12 = 1/250; l23 = 1/300;



% t = 1:10:T;
tr = 1:10:T;

pr(1,:) = ones(1,length(tr));
pr(2,:) = ones(1,length(tr));

[tot_time] = Rep_dists_Li_Ell_Hurr_Char_SMPRESS(tr, IMh);

tot_time(1,1) = 0;
tot_time(2,1) = 0;

cdf23 = [tr;tot_time(2,:)];
cdf12 = [tr;tot_time(1,:)];

cumtim = dt(1);

for ss = 1:NH

if ss == 1

    pdf12 = Find_PDF(tr,pr(1,:),tot_time(1,:));
    pdf23 = Find_PDF(tr,pr(2,:),tot_time(2,:));
    
for ii = 2:length(tr)
    
    r23(ii) = trapz(tr(1:ii),pdf23(1:ii));
    CDF12(ii) = trapz(tr(1:ii),pdf12(1:ii));
    
end

% fd = expcdf(t,1/ld1);
% 

% c23 = quadgk(@(x)Func_CONST(x,tr,pr(2,:),cdf23),0,T);
% r23 = r23/c23;
% 
% 
% 
% fdd = interp1(tr,pr(2,:),t,'linear','extrap');
% Phi23 = interp1(cdf23(1,:),cdf23(2,:),t,'linear','extrap');
r22 = 1-r23;

for ii = 1:length(tr)
    
    r12(ii) = quadgk(@(x)Conv_INT(x,tr,CDF12,r22,tr(ii)),0,tr(ii));
    r13(ii) = quadgk(@(x)Conv_INT(x,tr,CDF12,r23,tr(ii)),0,tr(ii));
    
end

r11 = 1-CDF12;

c = r11+r12+r13;

r11 = r11./c;
r12 = r12./c;
r13 = r13./c;

rec_1(ss,:) = (0.5*r12+r13);
rec_2(ss,:) = (0.5*r12+r13);

cumtim(ss+1) = cumtim(ss)+dt(ss+1);



else

    clearvars pr
    
pr1(1,:) = interp1(tr,1-r11,dt(ss)+tr,'linear','extrap');
pr1(2,:) = interp1(tr,1-r22,dt(ss)+tr,'linear','extrap');

pr2(1,:) = ones(1,length(tr));
pr2(2,:) = ones(1,length(tr));

[tot_time] = Rep_dists_Li_Ell_Eq_Char_SMPRESS(tr, IMe);

tot_time(1,1) = 0;
tot_time(2,1) = 0;

pr1(1,1) = 0; pr1(2,1) = 0;

%% STRATEGY 1

% pdf12_1 = Find_PDF(tr,pr1(1,:),tot_time(1,:));
% pdf23_1 = Find_PDF(tr,pr1(2,:),tot_time(2,:));
% 
% pdf12_2 = Find_PDF(tr,pr2(1,:),tot_time(1,:));
% pdf23_2 = Find_PDF(tr,pr2(2,:),tot_time(2,:));
% 
% for ii = 2:length(tr)
%     
%     r23_1(ii) = trapz(1:tr(ii),pdf23_1(1:ii));
%     r23_2(ii) = trapz(1:tr(ii),pdf23_2(1:ii));
%     CDF12_1(ii) = trapz(1:tr(ii),pdf12_1(1:ii));
%     CDF12_2(ii) = trapz(1:tr(ii),pdf12_2(1:ii));
%     
% end
% 
% % fd = expcdf(t,1/ld1);
% % 
% 
% r22_1 = 1-r23_1;
% r22_2 = 1-r23_2;

%% STRATEGY 2

Weight = 1;

t1 = my_random(tot_time(1,:),tr,100000);
t2 = my_random(pr1(1,:),tr,100000);
[y,x] = ecdf(t1+Weight*t2);
% pdf12_1 = Differentiation(x,y);
[x, index] = unique(x);
% pdf12_1 = interp1(x,pdf12_1(index),tr,'linear');
% pdf12_1(isnan(pdf12_1)) = 0;
% pdf12_1 = pdf12_1/trapz(tr,pdf12_1);
CDF12_1 = interp1(x,y(index),tr,'linear','extrap');

t1 = my_random(tot_time(2,:),tr,100000);
t2 = my_random(pr1(2,:),tr,100000);
[y,x] = ecdf(t1+Weight*t2);
% pdf23_1 = Differentiation(x,y);
[x, index] = unique(x);
% pdf23_1 = interp1(x,pdf23_1(index),tr,'linear');
% pdf23_1(isnan(pdf23_1)) = 0;
% pdf23_1 = pdf23_1/trapz(tr,pdf23_1);
CDF23_1 = interp1(x,y(index),tr,'linear','extrap');
 
pdf12_2 = Find_PDF(tr,pr2(1,:),tot_time(1,:));
pdf23_2 = Find_PDF(tr,pr2(2,:),tot_time(2,:));

r23_1 = CDF23_1;
r22_1 = 1-r23_1;

for ii = 2:length(tr)
    
    r23_2(ii) = trapz(tr(1:ii),pdf23_2(1:ii));
    CDF12_2(ii) = trapz(tr(1:ii),pdf12_2(1:ii));
    
end

r22_2 = 1-r23_2;

%% REST

for ii = 1:length(tr)
    
    r12_1(ii) = quadgk(@(x)Conv_INT(x,tr,CDF12_1,r22_1,tr(ii)),0,tr(ii));
    r13_1(ii) = quadgk(@(x)Conv_INT(x,tr,CDF12_1,r23_1,tr(ii)),0,tr(ii));
    r12_2(ii) = quadgk(@(x)Conv_INT(x,tr,CDF12_2,r22_2,tr(ii)),0,tr(ii));
    r13_2(ii) = quadgk(@(x)Conv_INT(x,tr,CDF12_2,r23_2,tr(ii)),0,tr(ii));
    
end

r11_1 = 1-CDF12_1;
r11_2 = 1-CDF12_2;

c1 = r11_1+r12_1+r13_1;
c2 = r11_2+r12_2+r13_2;

r11_1 = r11_1./c1;
r12_1 = r12_1./c1;
r13_1 = r13_1./c1;

r11_2 = r11_2./c2;
r12_2 = r12_2./c2;
r13_2 = r13_2./c2;

rec_1(ss,:) = (0.5*r12_1+r13_1);
rec_2(ss,:) = (0.5*r12_2+r13_2);

cumtim(ss+1) = cumtim(ss)+dt(ss+1);

end
end
ind1 = 1;
ind2 = 0;
for ii = 1:NH
    
   tf = tr(1):dt(ii+1);
   ind2 = ind2+length(tf);
   recfw_1(ind1:ind2) = interp1(tr,rec_1(ii,:),tf,'linear','extrap');
   recfw_2(ind1:ind2) = interp1(tr,rec_2(ii,:),tf,'linear','extrap');
   ind1 = ind2+1;
    
end

tff = 1:3000;
recff_1 = interp1(1:length(recfw_1),recfw_1,tff,'linear','extrap');
recff_2 = interp1(1:length(recfw_2),recfw_2,tff,'linear','extrap');

% ind1 = find(recff_1(mm,:)>1);
% ind2 = find(recff_2(mm,:)>1);
% recff_1(ind1) = 1;
% recff_2(ind2) = 1;

r_mc1(mm,:) = recff_1;
r_mc2(mm,:) = recff_2;

progressbar(mm/sims)

end

RESULT = [recff_1;recff_2;tff];

% plot(recff_1)
% hold on
% plot(recff_2)

end