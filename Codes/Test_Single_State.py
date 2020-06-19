## Imports
import numpy as np
import statsmodels
import seaborn as sns
from matplotlib import pyplot as plt
import pandas as pd
import pystan
from sklearn.kernel_ridge import KernelRidge
import os
import xlrd
os.chdir('C:\\Users\\lakshd5\\Dropbox\\Heteroscedasticity\\Final Data')
import statsmodels
import random
from numpy import random,argsort,sqrt
from scipy.stats import norm
from sklearn.neighbors import KernelDensity
from sklearn import neighbors
from scipy.interpolate import interp1d
from matplotlib.pyplot import figure
import matplotlib as mpl
from matplotlib.collections import LineCollection
from scipy.integrate import simps
from scipy.integrate import trapz
from scipy.integrate import cumtrapz


def multiline(xs, ys, c, ax=None, **kwargs):
    """Plot lines with different colorings

    Parameters
    ----------
    xs : iterable container of x coordinates
    ys : iterable container of y coordinates
    c : iterable container of numbers mapped to colormap
    ax (optional): Axes to plot on.
    kwargs (optional): passed to LineCollection

    Notes:
        len(xs) == len(ys) == len(c) is the number of line segments
        len(xs[i]) == len(ys[i]) is the number of points for each line (indexed by i)

    Returns
    -------
    lc : LineCollection instance.
    """

    # find axes
    ax = plt.gca() if ax is None else ax

    # create LineCollection
    segments = [np.column_stack([x, y]) for x, y in zip(xs, ys)]
    lc = LineCollection(segments, **kwargs)

    # set coloring of line segments
    #    Note: I get an error if I pass c as a list here... not sure why.
    lc.set_array(np.asarray(c))

    # add lines to axes and rescale 
    #    Note: adding a collection doesn't autoscalee xlim/ylim
    ax.add_collection(lc)
    ax.autoscale()
    return lc

def kernel(distances):
    # distances is an array of size K containing distances of neighbours
    weights = 1/np.sqrt(2*np.pi) * np.exp(-distances**2/2) # Compute an array of weights however you want
    return distances

mpl.rcParams['axes.linewidth'] = 2
mpl.rcParams['xtick.major.size'] = 4
mpl.rcParams['ytick.major.width'] = 2.5
mpl.rcParams['xtick.minor.size'] = 4
mpl.rcParams['ytick.minor.width'] = 2.5

## Data

wb = xlrd.open_workbook('RC_PD_SF2.xlsx') 
sheet = wb.sheet_by_index(0)
# sheet.cell_value(1, 0)
count = 0
IM = []
PD = []
for ii in np.arange(1,333,1):
    if sheet.cell_value(ii,0)>0 and sheet.cell_value(ii,1)<0.1 and sheet.cell_value(ii,1)>0:
        count = count + 1
        IM.append(sheet.cell_value(ii,0))
        PD.append(sheet.cell_value(ii,1))
        
lnIM = np.array(np.log(IM))
lnPD = np.array(np.log(PD))    

X_plot = np.log(np.linspace(0.05, 2, 100)[:, None])
X_plot1 = np.log(np.linspace(0.05, 2.04, 101)[:, None])

## StatsModel Fit
KRR = statsmodels.nonparametric.kernel_regression.KernelReg(lnPD, lnIM, 'c',reg_type = 'll',bw='cv_ls') # np.array([1e20])
KRR_fit = KRR.fit(X_plot)
KRR_fit_res = KRR.fit(lnIM)

KRR1 = statsmodels.nonparametric.kernel_regression.KernelReg(lnPD, lnIM, 'c',reg_type = 'lc',bw='cv_ls') # np.array([1e20])
KRR_fit1 = KRR1.fit(X_plot)
KRR_fit_res1 = KRR1.fit(lnIM)
# ## KNN function
# 
# from pylab import plot,show
# 
# def knn_search(x, D, K):
#  dis = sqrt((lnIM-x)**2)
#  idx = argsort(dis) # sorting
#  # return the indexes of K nearest neighbours
#  return idx[:K]
# 
# 
# ## Estimate standard deviation (sampling)
# 
# N_samps = 30
# 
# for ii in np.arange(0,len(X_plot),1):
#     ID = knn_search(X_plot[ii], lnIM, N_samps)
#     std_req[ii] = np.std(lnPD[ID])
# 
# plt.plot(X_plot,KRR_fit[0],X_plot,KRR_fit[0]+std_req,X_plot,KRR_fit[0]-std_req)
# plt.scatter(lnIM,lnPD)
# plt.show()

## Cloud
KRRC = statsmodels.nonparametric.kernel_regression.KernelReg((lnPD), lnIM, 'c',reg_type = 'll',bw=np.array([1000]))
KRR_C_res = KRRC.fit(lnIM)
resCl = lnPD-KRR_C_res[0]
stdC = np.std(resCl)

font = {'family' : 'serif',
        'weight' : 'normal',
        'size'   : 26}
figure(num=None, figsize=(8, 7), facecolor='w', edgecolor='k')
plt.rc('font', **font)
ax = plt.gca()
ax.scatter(IM,PD,color = (41/255,51/255,92/255,0.5),s=200,marker="d")
ax.plot(np.exp(X_plot),np.exp(KRRC.fit(X_plot)[0]),color = 'k',linewidth=3.0,lineStyle = '--')
ax.plot(np.exp(X_plot),np.exp(KRR_fit[0]),color = 'k',linewidth=3.0,lineStyle = '-')
ax.plot(np.exp(X_plot),np.exp(KRR_fit1[0]),color = 'k',linewidth=3.0,lineStyle = '-.')
ax.set_yscale('log')
ax.set_xscale('log')
plt.xlabel('Sa(1.33s) [g]')
plt.ylabel('Peak Interstory Drift')
plt.title('Steel moment frame')
# plt.legend(frameon=False)
plt.show()

## Compute risk

Dr1 = np.log(0.01)
Dr2 = np.log(0.02)
Dr3 = np.log(0.04)

prob1_1 = np.zeros(len(X_plot))

prob1_2 = np.zeros(len(X_plot))

prob1_3 = np.zeros(len(X_plot))

pdf1 = np.zeros(len(X_plot))
pdf2 = np.zeros(len(X_plot))



for ii in np.arange(0,len(X_plot),1):
    fit_valC = KRRC.fit(X_plot[ii])
    resN_Cl = (Dr1-fit_valC[0])/stdC
    prob1_1[ii] = 1-norm.cdf(resN_Cl)
    pdf1[ii] = norm.pdf(resN_Cl)
    
    fit_valC = KRRC.fit(X_plot[ii])
    resN_Cl = (Dr2-fit_valC[0])/stdC
    prob1_2[ii] = 1-norm.cdf(resN_Cl)
    
    fit_valC = KRRC.fit(X_plot[ii])
    resN_Cl = (Dr3-fit_valC[0])/stdC
    prob1_3[ii] = 1-norm.cdf(resN_Cl)
    


P1_oo = 1-prob1_1
P1_io = prob1_1-prob1_2
P1_ls = prob1_2-prob1_3
P1_cp = prob1_3

## Seismic hazard

wb = xlrd.open_workbook('Sa053_LA.xlsx') 
sheet = wb.sheet_by_index(0)
# sheet.cell_value(1, 0)
count = 0
IM_haz = []
Haz = []
for ii in np.arange(1,51,1):
    count = count + 1
    IM_haz.append(sheet.cell_value(ii,0))
    Haz.append(sheet.cell_value(ii,1))

int_fun = interp1d(np.log(IM_haz),np.log(Haz))
Haz_int = np.exp(int_fun(X_plot1))

Haz_diff = np.abs(np.array([Haz_int[i + 1] - Haz_int[i] for i in range(len(Haz_int)-1)]))

## Loss of functionality single time

time_1 = 20
time_2 = 90
time_3 = 360

med_times = np.array([time_1,time_2,time_3])

std_rec = 0.75

time_req =  [180] #(np.linspace(10, 2000, 1)[:, None])

time_im1 = np.zeros(len(X_plot))

time_only = np.zeros((len(time_req),0))

for ii in np.arange(0,len(time_req),1):
    for kk in np.arange(0,len(X_plot),1):
        
        time_im1[kk] = (1-norm.cdf((np.log(time_req[ii])-np.log(time_1))/std_rec)) * P1_io[kk] + (1-norm.cdf((np.log(time_req[ii])-np.log(time_2))/std_rec)) * P1_ls[kk] + (1-norm.cdf((np.log(time_req[ii])-np.log(time_3))/std_rec)) * P1_cp[kk]
        
font = {'family' : 'serif',
        'weight' : 'normal',
        'size'   : 26}

plt.rc('font', **font)

# plt.plot(np.exp(X_plot),time_im1,color = (219/255,43/255,57/255,0.3),lineStyle = (0,(3,5,1,5,1,5)),linewidth=4.0,label = 'Case 1')
plt.scatter(np.exp(X_plot),time_im1,color = (80/255,114/255,60/255,0.3),s=50,label = 'Case 1',marker='o')
        
# plt.legend(frameon=False,loc='lower right')
plt.title('Wood shear wall ($T^* = 180$ days)')
plt.xlabel('Sa(0.53s) [g]')
plt.ylabel('Exceedance probability')
plt.ylim((0, 1))
plt.show()


## Loss of functionality hazard

time_1 = 20
time_2 = 90
time_3 = 360

med_times = np.array([time_1,time_2,time_3])

std_rec = 0.75

time_req =  (np.linspace(10, 2000, 200)[:, None])

time_haz1 = np.zeros(len(time_req))

for ii in np.arange(0,len(time_req),1):
    
    time_im1 = np.zeros(len(X_plot))

    for kk in np.arange(0,len(X_plot),1):
        time_im1[kk] = (1-norm.cdf((np.log(time_req[ii])-np.log(time_1))/std_rec)) * P1_io[kk] + (1-norm.cdf((np.log(time_req[ii])-np.log(time_2))/std_rec)) * P1_ls[kk] + (1-norm.cdf((np.log(time_req[ii])-np.log(time_3))/std_rec)) * P1_cp[kk]
        
    time_haz1[ii] = np.sum(time_im1 * np.rot90(Haz_diff))
        
ax = plt.gca()

font = {'family' : 'serif',
        'weight' : 'normal',
        'size'   : 26}

plt.rc('font', **font)

plt.plot(time_req,time_haz1,linewidth=4.0,label = 'Case 1')

# plt.legend(frameon=False,loc='lower left')
plt.title('Wood shear wall')
plt.xlabel('Time [days]')
plt.ylabel('Exceedance probability in 50 years')
# plt.ylim((0, 1))

ax.set_xscale('log')
ax.set_yscale('log')
plt.show()

## Recovery curves

time_1 = 20
time_2 = 90
time_3 = 360

med_times = np.array([time_1,time_2,time_3])

std_rec = 0.75

time_req =  (np.linspace(10, 2000, 200)[:, None])

time_im1 = np.zeros(len(time_req))

KK = []

for kk in np.arange(0,len(X_plot),1):
    
    time_im1 = (norm.cdf((np.log(time_req)-np.log(time_1))/std_rec)) * P1_io[kk] + (norm.cdf((np.log(time_req)-np.log(time_2))/std_rec)) * P1_ls[kk] + (norm.cdf((np.log(time_req)-np.log(time_3))/std_rec)) * P1_cp[kk]
    
    # KK = np.vstack((KK, np.rot90(time_im1)))
    KK = np.array([[KK],[time_im1]])

# time_only = np.zeros((len(time_req),0))
# 
# for ii in np.arange(0,len(time_req),1):
#     for kk in np.arange(0,len(X_plot),1):
#         
#         time_im1[kk] = (1-norm.cdf((np.log(time_req[ii])-np.log(time_1))/std_rec)) * P1_io[kk] + (1-norm.cdf((np.log(time_req[ii])-np.log(time_2))/std_rec)) * P1_ls[kk] + (1-norm.cdf((np.log(time_req[ii])-np.log(time_3))/std_rec)) * P1_cp[kk]
        
# font = {'family' : 'serif',
#         'weight' : 'normal',
#         'size'   : 26}
# 
# plt.rc('font', **font)
# 
# # plt.plot(np.exp(X_plot),time_im1,color = (219/255,43/255,57/255,0.3),lineStyle = (0,(3,5,1,5,1,5)),linewidth=4.0,label = 'Case 1')
# plt.scatter(np.exp(X_plot),time_im1,color = (80/255,114/255,60/255,0.3),s=50,label = 'Case 1',marker='o')
#         
# # plt.legend(frameon=False,loc='lower right')
# plt.title('Wood shear wall ($T^* = 180$ days)')
# plt.xlabel('Sa(0.53s) [g]')
# plt.ylabel('Exceedance probability')
# plt.ylim((0, 1))
# plt.show()

