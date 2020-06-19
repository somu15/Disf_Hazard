clr

im_io = 0.5; im_ls = 1; im_cp = 1.5; std_im = 0.5;

time_1 = 20;
time_2 = 90;
time_3 = 360;

std_rec = 0.75;

t_req = 10:10:4000;
im = 0.01:0.01:2;

dat = importdata('C:\Users\lakshd5\Dropbox\Heteroscedasticity\Final Data\Sa133_LA.txt');
haz = exp(interp1(log(dat(:,1)),log(dat(:,2)),log(im)));

diff_haz = Differentiation(0.01,haz);

IO = normcdf(log(im),log(im_io),std_im);
LS = normcdf(log(im),log(im_ls),std_im);
CP = normcdf(log(im),log(im_cp),std_im);

P_io = IO-LS;
P_ls = LS-CP;
P_cp = CP;

for ii = 1:length(im)
    for jj = 1:length(t_req)
        fra_tim(ii,jj) = (1-normcdf(log(t_req(jj)),log(time_1),std_rec)) * P_io(ii) + (1-normcdf(log(t_req(jj)),log(time_2),std_rec)) * P_ls(ii) + (1-normcdf(log(t_req(jj)),log(time_3),std_rec)) * P_cp(ii);
    end
end

for ii = 1:length(t_req)
    T_haz(ii) = sum(fra_tim(:,ii).*abs(diff_haz)'*0.01);
end

loglog(t_req,T_haz)

%% Two states

clr

IM = 0.01:0.01:2;

for ii = 1:length(IM)
    
    [res] = SingleHazard_Rec(IM(ii), 'E');
    
    % resilience(ii) = trapz(res(2,:),res(1,:));
    
    resil(ii,:) = res(1,:);
    
    progressbar(ii/length(IM))
    
end

dat = importdata('C:\Users\lakshd5\Dropbox\Heteroscedasticity\Final Data\Sa133_LA.txt');
haz = exp(interp1(log(dat(:,1)),log(dat(:,2)),log(IM)));

diff_haz = Differentiation(0.01,haz);

t_req = 1:10:6000;

for ii = 1:length(t_req)
    T_haz(ii) = sum((1-resil(:,ii)).*abs(diff_haz)'*0.01);
end

loglog(t_req,T_haz)
