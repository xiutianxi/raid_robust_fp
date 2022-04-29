
clear;clc;close all
addpath('saved data')
addpath('functions')
addpath('original data')
load('incomeDB.mat')
load('s_atts_ins.mat')
[o_marginals,o_joints] = empirical_distributions(incomeDB,s_atts_ins);

[row_num,col_num]= size(incomeDB);
db_og = incomeDB.Variables;
db_og = db_og(:,[2:col_num-1]);
comm = 10;
rng(123)
affiliation = kmeans( db_og ,comm );

%% column wise joint distribution utility
tau = 0.001;
col_utility_corr = [];
for i = 1:10
    db = incomeDB_sp100_gamma30_moving_history{1,i};
    [marginals,joints] = empirical_distributions(db,s_atts_ins);
    
    cum_kl = 0;
    names = fieldnames(joints);
    for l = 1:length(names)
        j = joints.(names{l});
        o_j = o_joints.(names{l});
        
        cum_kl = cum_kl + prod(size(j)) - sum(sum(abs(  (j-o_j) )>tau));
        
    end
    col_utility_corr = [col_utility_corr cum_kl];
    i
end
col_utility_corr/joint_size


joint_size = 0;
for l = 1:length(names)
    j = joints.(names{l});
    o_j = o_joints.(names{l});
    
    joint_size = joint_size + prod(size(j)) ;
    
end

baseline = 0;
tau=1e-3;
db_mark = incomeDB_sp100_gamma30;
[marginals,joints] = empirical_distributions(db_mark,s_atts_ins);
names = fieldnames(joints);
for l = 1:length(names)
    j = joints.(names{l});
    o_j = o_joints.(names{l});
    
    baseline = baseline + prod(size(j)) - sum(sum(abs(  (j-o_j) )>tau));
    
end
baseline/joint_size
%% row wise similarity score utility
tau = 1e-1;
row_utility_corr = [];row_utility_rnd=[];
sim_size = 0;
for c = 1:comm
    db_og_sub = db_og(find(affiliation==c),:);
    sim_size = sim_size + size(db_og_sub,1)*(size(db_og_sub,1)-1);
end
for i = 1:10
    db = incomeDB_sp100_gamma30_moving_history{1,i};
    db = db.Variables;
    db = db(:,[2:col_num-1]);
    cum =0;
    for c = 1:comm
        db_og_sub = db_og(find(affiliation==c),:);
        D_og = squareform( pdist(db_og_sub,  'hamming' ) ) * 13;
        D_og = exp(-D_og/13)-eye(size(db_og_sub,1));
        
        db_sub = db(find(affiliation==c),:);
        D = squareform( pdist(db_sub,  'hamming' ) ) * 13;
        D = exp(-D/13)-eye(size(db_sub,1));
        cum = cum + size(db_sub,1)*(size(db_sub,1)-1) - sum(sum( abs(D-D_og)>tau   ));
        [i c]
    end
    row_utility_corr = [row_utility_corr cum];
end
row_utility_corr/sim_size



baseline_row = 0;
tau=0.1;
db_mark = incomeDB_sp100_gamma30;
db_mark = db_mark.Variables;
db_mark = db_mark(:,[2:col_num-1]);
cum =0;
for c = 1:comm
    db_og_sub = db_og(find(affiliation==c),:);
    D_og = squareform( pdist(db_og_sub,  'hamming' ) ) * 13;
    D_og = exp(-D_og/13)-eye(size(db_og_sub,1));
    
    db_mark_sub = db_mark(find(affiliation==c),:);
    D = squareform( pdist(db_mark_sub,  'hamming' ) ) * 13;
    D = exp(-D/13)-eye(size(db_mark_sub,1));
    baseline_row = baseline_row + size(db_mark_sub,1)*(size(db_mark_sub,1)-1) - sum(sum( abs(D-D_og)>0.01   ));
    c
end
baseline_row/sim_size

%% covariance matrix
cov_matrix_corr = [];
for i = 1:10
    db = incomeDB_sp100_gamma30_moving_history{1,i};
    db = db.Variables;
    db = db(:,[2:col_num-1]);
    
    temp = sqrt(norm(db'*db/row_num - db_og'*db_og/row_num,'fro')/norm(db_og'*db_og/row_num,'fro'));
    cov_matrix_corr = [cov_matrix_corr 1-temp];
    i
end



baseline_cov_matrix = 1-sqrt(norm(db_mark'*db_mark/row_num - db_og'*db_og/row_num,'fro')...
    /norm(db_og'*db_og/row_num,'fro'));

