
%{
how many flipping can break the fingerprints, and cause the accuse of an
inconnect sp
try both random flipping and correlation based attack proposed in the paper
%}

%%
clear;clc;close all
addpath('functions')

addpath('original data')
% load 'fp_sp100.mat';
load 's_atts_ins.mat';
load 'joints_public.mat'

addpath('saved data')
load 'incomeDB_sp100_gamma30.mat'

[M,N] = size(incomeDB_sp100_gamma30);

secretKey = 'CensusIncomeDataSet';
gamma = 30;
sp_id = 100;
epsilon= 1;
rnd_range = M;

%% correlation attack (row-wise attack followed by column-wise attack)

tic;
diff_thr_list = [0.01  0.1  0.1  0.1  0.06 0.01  0.01 0.001 0.001 0.001];
[corrflip_attack_history_incomeDB_sp100_gamma30 , corrflip_num_flips_history_incomeDB_sp100_gamma30] ...
    = corrflip(incomeDB_sp100_gamma30,joints_public, s_atts_ins, diff_thr_list);
toc;


%%
corrflip_num_match  = [];
corrflip_innocent_accuse = [];
for r  = 1:8
[f_detect,f_vote0,f_vote1]  = detect_fingerprint(...
    corrflip_attack_history_incomeDB_sp100_gamma30{r},...
    gamma,epsilon,rnd_range,secretKey);
num_match = bits_match(fp_sp100, f_detect);
corrflip_num_match = [ corrflip_num_match  num_match];


tal = 0;
for cnt = 1:100
    other_sp_ids = randi([300 200000000],1,100);
    Match= [];
    for i = 1:length(other_sp_ids)
        sp_id = other_sp_ids(i);
        fp =  sp_id_fingerprint_generate(secretKey, sp_id);
        Match = [Match bits_match(f_detect, fp)];
    end
    tal = tal+sum(Match>=num_match);
end
corrflip_innocent_accuse = [corrflip_innocent_accuse tal/cnt];


r

end


cmp_bits_atk_col = 128-corrflip_num_match;
display("number of compromised fingerprint bits (out of 128)")
cmp_bits_atk_col

display("% of accussed innocent SPs")
corrflip_innocent_accuse


%%   random flipping


rndflip_attack_history_incomeDB_sp100_gamma30 = cell(1,8);
for i  = 1:8
    row_select = datasample([1:M],corrflip_num_flips_history_incomeDB_sp100_gamma30(i));
    col_select = datasample([2:14],corrflip_num_flips_history_incomeDB_sp100_gamma30(i) );
    rndflip_attack_history_incomeDB_sp100_gamma30{i} = flipping_attack(...
        incomeDB_sp100_gamma30, s_atts_ins, [row_select' col_select']);
    i
end


rndflip_num_match  = [];
rndflip_innocent_accuse = [];
for r  = 1:8
[f_detect,f_vote0,f_vote1]  = detect_fingerprint(...
    rndflip_attack_history_incomeDB_sp100_gamma30{r},...
    gamma,epsilon,rnd_range,secretKey);
num_match = bits_match(fp_sp100, f_detect);
rndflip_num_match = [ rndflip_num_match  num_match];


tal = 0;
for cnt = 1:100
    other_sp_ids = randi([300 200000000],1,100);
    Match= [];
    for i = 1:length(other_sp_ids)
        sp_id = other_sp_ids(i);
        fp =  sp_id_fingerprint_generate(secretKey, sp_id);
        Match = [Match bits_match(f_detect, fp)];
    end
    tal = tal+sum(Match>=num_match);
end
rndflip_innocent_accuse = [rndflip_innocent_accuse tal/cnt];


r

end

cmp_bits_atk_rnd = 128-rndflip_num_match;
display("number of compromised fingerprint bits (out of 128) by random flipping")
cmp_bits_atk_rnd

display("% of accussed innocent SPs by random flipping")
rndflip_innocent_accuse


