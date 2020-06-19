function [RESULT] = SingleHazard_Rec(IM, Hazard, T)

% IMe = 0.75; IMh = 60;%[50 65 80 95 110 125 140 155];

% dtv = [50 100 150 200 250 300 350 400 450 500 550 600 650 700 750 800];
    
NH = 2;
% dt = 150;%exprnd(365,NH-1,1);
% T = 6000;

% l12 = 1/250; l23 = 1/300;



% t = 1:10:T;
tr = 1:10:T;
% tr = T;
pr(1,:) = ones(1,length(tr));
pr(2,:) = ones(1,length(tr));

if strcmp(Hazard,'E') == 1
    
    [tot_time] = Rep_dists_Li_Ell_Eq_Char_SMPRESS(tr, IM);
else
    
    [tot_time] = Rep_dists_Li_Ell_Hurr_Char_SMPRESS(tr, IM);
end

% tot_time(1,:) = logncdf(tr,log(500),0.5);
% tot_time(2,:) = logncdf(tr,log(250),0.5);

tot_time(1,1) = 0;
tot_time(2,1) = 0;

cdf23 = [tr;tot_time(2,:)];
cdf12 = [tr;tot_time(1,:)];


for ss = 1:1


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

% CDF12 = cdf12(2,:);
% r23 = cdf23(2,:);
% r22 = 1-r23;

for ii = 1:length(tr)
    
    r12(ii) = quadgk(@(x)Conv_INT(x,tr,CDF12,r22,tr(ii)),0,tr(ii),'AbsTol',1e-12);
    r13(ii) = quadgk(@(x)Conv_INT(x,tr,CDF12,r23,tr(ii)),0,tr(ii),'AbsTol',1e-12);
    
end

r11 = 1-CDF12;

c = r11+r12+r13;

r11 = r11./c;
r12 = r12./c;
r13 = r13./c;

rec_1(ss,:) = (0.5*r12+r13);
rec_2(ss,:) = (0.5*r12+r13);



%tf = 1:max(tr);
%recf = interp1(tr,rec_1,tf,'linear','extrap');


RESULT = [rec_1; tr];

% plot(recff_1)
% hold on
% plot(recff_2)

end
