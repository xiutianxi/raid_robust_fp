function R_marked_flip = flipping_attack(R_marked, s_atts_ins, high_suspect)
%{
each row of high_suspect is a 3 field tuple, [sus_row sus_col
#of_occurrence], where sus_col is in the order of the original columns
ranged 2~14

s_atts_ins: original states of attributes subject to fingerprinting, 13 files
%}


fp_att_list = R_marked.Properties.VariableNames;

fp_att_list = fp_att_list(2:end-1); % fingerprinted attribute list (exclude id and label)

flip_length = size(high_suspect,1);

for i = 1:flip_length
    row = high_suspect(i,1);
    col = high_suspect(i,2)-1;
    % the original col index is in the order of R_mark which contains id
    % and label, thus we need to reduce by it by 1
%     marginal_distr = marginals_public.(fp_att_list{col})
    all_states =  s_atts_ins.(fp_att_list{col}) ;
    sus_entry_bin  = dec2bin(   R_marked{ row, high_suspect(i,2) }   );
    mark_bit_m = sus_entry_bin(end);
    if mark_bit_m == '1'
        new_sus_entry_bin = sus_entry_bin;
        new_sus_entry_bin(end) = '0';
        new_sus_entry = bin2dec(new_sus_entry_bin);
    else
        new_sus_entry_bin = sus_entry_bin;
        new_sus_entry_bin(end) = '1';
        new_sus_entry = bin2dec(new_sus_entry_bin);
        if new_sus_entry>max(all_states)
            new_sus_entry = new_sus_entry-2;
        end
    end
    R_marked{ row, high_suspect(i,2) }  = new_sus_entry;
end
    
    R_marked_flip = R_marked;
    
    
    
end