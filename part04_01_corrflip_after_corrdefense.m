


clear;clc;close all
addpath('functions')

addpath('original data')
addpath('saved data')
load 'incomeDB.mat'
load 'fp_sp100.mat';
load 's_atts_ins.mat';
load 'joints_public.mat'
load 'marginals_public.mat'


secretKey = 'CensusIncomeDataSet';
gamma = 30;
sp_id = 100;
epsilon= 1;


[incomeDB_sp100_gamma30,fp_sp100,marked_row,marked_col,~,~] = insert_fingerprint(incomeDB, gamma,epsilon,secretKey,sp_id);

[M,N] = size(incomeDB_sp100_gamma30);


%% solve the OT problem
thr = 0.0001;
lambda_list = [100:100:1000];
[marginals_marked,joints_marked] = empirical_distributions(incomeDB_sp100_gamma30,s_atts_ins);

num_chg_by_corrdefense = zeros(1,length(lambda_list));
joint_diff_list = [];

incomeDB_sp100_gamma30_moving_history = cell(1,10);
for i  = 1:length(lambda_list)
    lambda = lambda_list(i);
    plans = get_mass_move_plan(marginals_public,joints_public,marginals_marked,joints_marked,thr,lambda);
    
    incomeDB_sp100_gamma30_mass_moved = mass_move_all(incomeDB_sp100_gamma30,plans);
    
    
    content_moved = incomeDB_sp100_gamma30_mass_moved.Variables;
    content_marked =  incomeDB_sp100_gamma30.Variables;
    content_moved(marked_row,marked_col)  = content_marked(marked_row,marked_col) ;
    incomeDB_sp100_gamma30_mass_moved = ...
        array2table(content_moved,'VariableNames',incomeDB_sp100_gamma30.Properties.VariableNames);
    
    incomeDB_sp100_gamma30_moving_history{i} = incomeDB_sp100_gamma30_mass_moved;
    
    [marginals_moved,joints_moved] = ...
        empirical_distributions(incomeDB_sp100_gamma30_mass_moved,s_atts_ins);
    
    joint_diff = cum_joint_diff(joints_moved,joints_public);
    
    joint_diff_list = [joint_diff_list joint_diff];
    
    chg_idx = find(incomeDB_sp100_gamma30.Variables~=incomeDB_sp100_gamma30_mass_moved.Variables);
    num_chg_by_corrdefense(i) = length(chg_idx);
    i
end


%% when lambda = 400


incomeDB_sp100_gamma30_mass_moved = incomeDB_sp100_gamma30_moving_history{4};
tic;
diff_thr_list = [0.01  0.1  0.1  0.1  0.06 0.01  0.01 0.001 ];
[corrdefense_corrflip_db_lambda600 , corrdefense_corrflip_numflip_lambda500] ...
    = corrflip(incomeDB_sp100_gamma30_mass_moved,joints_public, s_atts_ins, diff_thr_list);
toc;


corrdef_corrflip_num_match  = [];
corrdef_corrflip_innocent_accuse = [];
rnd_range=M;
for r  = 1:8
    [f_detect,f_vote0,f_vote1]  = detect_fingerprint(...
        corrdefense_corrflip_db_lambda600{r},...
        gamma,epsilon,rnd_range,secretKey);
    
    
    num_match = bits_match(fp_sp100, f_detect);
    corrdef_corrflip_num_match = [ corrdef_corrflip_num_match  num_match];
    
    
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
    corrdef_corrflip_innocent_accuse = [corrdef_corrflip_innocent_accuse tal/cnt];
    
    
    r
    
end

128 - corrdef_corrflip_num_match

corrdef_corrflip_innocent_accuse