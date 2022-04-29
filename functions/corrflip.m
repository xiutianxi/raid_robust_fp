function [attack_history , num_flips_history] = corrflip( ...
    R,joints_public, s_atts_ins, diff_thr_list)

rounds = length(diff_thr_list);

attack_history = cell(1,rounds);

num_flips_history = zeros(1,rounds);

r = 1;
R_marked_flip  = R;

high_suspect = [];

while r<= rounds
    [marginals_marked,joints_marked] = empirical_distributions(R_marked_flip,s_atts_ins);
    
    diff_thr = diff_thr_list(r);
    [select_row, select_col] = ...
        obtain_suspicious_row_col(joints_public, joints_marked,R_marked_flip,diff_thr,s_atts_ins);
    
    unique_row = unique(select_row);
    high_suspect_new = [];
    for i = 1:length(unique_row)
        idx = find( select_row==unique_row(i) );
        sus_col =    select_col(idx,:)   ;
        
        high_suspect_new = [high_suspect_new;  [unique_row(i)  mode(sus_col(:))  ]  ];
    end
    
    if isempty(high_suspect)
        high_suspect = [high_suspect; high_suspect_new];
        
    else
        high_suspect_new = setdiff( high_suspect_new,high_suspect, 'row');
        high_suspect = [high_suspect; high_suspect_new];
    end


% ppp = [    [select_row  select_col(:,1)]   ; [select_row  select_col(:,2)] ];
% [ii,jj,kk]=unique(ppp,'rows','stable');
% out=[ii,accumarray(kk,1)];
% [val,idx] = sort(out(:,3),'descend');
% high_suspect_new = out( idx(1:10000), [1,2] );
% 
%     if isempty(high_suspect)
%         high_suspect = [high_suspect; high_suspect_new];
%         
%     else
%         high_suspect_new = setdiff( high_suspect_new,high_suspect, 'row');
%         high_suspect = [high_suspect; high_suspect_new];
%     end


    
    
    R_marked_flip = flipping_attack(R_marked_flip, s_atts_ins, high_suspect_new);
    
    num_flips = size(high_suspect,1);
    
    attack_history{r} = R_marked_flip;
    
    num_flips_history(r) = num_flips;
    
    r = r+1
    
    
    
    
end


end