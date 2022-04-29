

clear;clc;close all
addpath('original data')
% addpath('functions')
load 'incomeDB.mat'
%
[row_num,col_num]= size(incomeDB);
db = incomeDB.Variables;
db = db(:,[2:col_num-1]);

addpath('saved data')
load 'incomeDB_sp100_gamma30.mat'
db_mark = incomeDB_sp100_gamma30.Variables;
db_mark = db_mark(:,[2:col_num-1]);


comm = 10; %[10:1:20];
rng(123)
affiliation = kmeans( db ,comm );
gamma = 30;


%%
sus = [];

for j  = 1:comm
    individual_id =  find(affiliation==j);
    num_individual = length(individual_id);
    individual_of_comm_i = db( individual_id ,:   );
    D_og = squareform( pdist(individual_of_comm_i,  'hamming' ) ) * 13;
    
    D_og = exp(-D_og/13)-eye(num_individual);

    individual_of_comm_i_mark = db_mark(   find(affiliation==j),:   );
    D_mark = squareform( pdist(individual_of_comm_i_mark,  'hamming' ) ) * 13;
    D_mark = exp(-D_mark/13)-eye(num_individual);
    abs_diff = abs(D_og-D_mark) ;
    [val,id_diff] = sort(sum(abs_diff,2),'descend');
    if isempty(id_diff)
        continue
    else
        %             [x,y] = ind2sub(   size(D_mark),  id_diff );
        sus = [sus   ;     individual_id(id_diff([1:ceil(  num_individual/(10)    )])   )   ];
    end
    j
end


load 's_atts_ins.mat'
addpath('functions')
high_suspect = [repmat(sus,13,1)  ,  kron(  ([2:col_num-1])' , ones(length(sus),1)      )    ];
R_marked_flip = flipping_attack(incomeDB_sp100_gamma30, s_atts_ins, high_suspect);


epsilon = 1; % change one of the epsilon least significant bits

secretKey = 'CensusIncomeDataSet';
gamma = 30;
sp_id = 100;
rnd_range = row_num;

fp_og =  sp_id_fingerprint_generate(secretKey, sp_id);
[f_detect,f_vote0,f_vote1] = detect_fingerprint(R_marked_flip, gamma,epsilon,rnd_range,secretKey);
num_match = bits_match(f_detect, fp_og)




