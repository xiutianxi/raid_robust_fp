

clear;clc;close all
addpath('original data')
addpath('functions')
load 'incomeDB.mat'

[row_num,~]= size(incomeDB);

epsilon = 1; % change one of the epsilon least significant bits

secretKey = 'CensusIncomeDataSet';
gamma = 35; % fingerprint every 35 rows approximatedly (30)
sp_id = 100;
rnd_range = row_num;


[incomeDB_sp100_gamma30,fp_sp100] = insert_fingerprint(incomeDB, gamma,epsilon,secretKey,sp_id);



[f_detect,f_vote0,f_vote1]  = detect_fingerprint(incomeDB_sp100_gamma30, gamma,epsilon,rnd_range,secretKey);

% sum(fp_sp100 == f_detect)

num_match = bits_match(f_detect, fp_sp100)