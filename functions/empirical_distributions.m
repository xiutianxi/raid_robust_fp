function [marginals,joints] = empirical_distributions(T,s_atts_ins)
%{
get the empirical pairwise correlation between attributes in a database
s_atts_ins is the structure containing all instances of each attributes
%}
atts = T.Properties.VariableNames;

[row_num, col_num] = size(T);

% get the marginal distributions
marginals = struct();
for i = 2:col_num-1
    ins = s_atts_ins.(atts{i});
    occ = [];
    for l = 1: length(ins), occ = [occ length(find( T.(atts{i}) == ins(l) ))]; end
    marginals.(atts{i}) = occ/row_num;
end
    
% get the joint distributions
joints = struct();
for i = 2:col_num-2
    ins_i = s_atts_ins.(atts{i});
    for j  = i+1:col_num-1
        ins_j = s_atts_ins.(atts{j});
        occ_joint  = [];
        for l_i = 1: length(ins_i)
            for l_j = 1: length(ins_j)
                occ_joint = [occ_joint  length( intersect(  find( T.(atts{i}) == ins_i(l_i) ), ...
                    find( T.(atts{j}) == ins_j(l_j) )   )  )];
            end
        end
                occ_joint =    (    reshape(occ_joint, length(ins_j),  length(ins_i) )   )';
        joints.(   [atts{i} '_with_' atts{j}]   ) = occ_joint/row_num;
    end

end