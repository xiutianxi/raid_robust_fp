

function [R_marked,fp,marked_row,marked_col,marked_chg_row,marked_chg_col] = insert_fingerprint(T, gamma,epsilon,secretKey,sp_id)
%{
obtain the marked database for a service provider (sp_id), secretKey is the
        secret key of the database owner
epsilon: mark one of the last significant epsilon bit
gamma: mark every gamma tupple
%}

[row_num,col_num] = size(T);
fp =  sp_id_fingerprint_generate(secretKey, sp_id);
L = length(fp);
Start = 1;
Stop = row_num;


marked_row = [];
marked_chg_row = [];
marked_col = [];
marked_chg_col = [];
for t  = 1:row_num
    primary_key_att_value = T{t,1};
    seed = [double(secretKey) primary_key_att_value];
    rng(sum(seed));
    rnd_seq = datasample([1:Stop],5,'Replace',false);
    if ~mod(rnd_seq(1),gamma) % if Modulo is 0, then fingerprint this tuple
%         display(t)
        marked_row = [marked_row;t];
        att_index = mod(rnd_seq(2), col_num-2)+2; % only have col_num-2 columns that can be marked
                % since the first(index) and the last (label) columns will not be marked
                % only mark column 2-14
        marked_col = [marked_col;att_index];
        att_value = T{t,att_index};  %mark this attribute
        mask_bit =  mod(rnd_seq(3),2);  % set mark_bit to 0 if S[3] is even, 1 if odd
        fp_index =  mod(rnd_seq(4),L)+1;
        fp_bit = fp(fp_index);
        mark_bit = xor(mask_bit,fp_bit);  % update mark_bit using xor operator
        att_value_bin  = dec2bin(att_value);
        if mark_bit, att_value_bin(end) = '1'; else, att_value_bin(end) = '0'; end
        att_value_update = bin2dec(att_value_bin);
        T{t,att_index} = att_value_update;
        
        if att_value~=att_value_update, 
            marked_chg_row = [marked_chg_row; t]; marked_chg_col = [marked_chg_col; att_index];
        end
        
    end
end
R_marked = T;
end



