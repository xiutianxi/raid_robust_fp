function [f_detect,f_vote0,f_vote1] = detect_fingerprint(T, gamma,epsilon,rnd_range,secretKey)
%{
obtain the marked database for a service provider (sp_id), secretKey is the
        secret key of the database owner
epsilon: mark one of the last significant epsilon bit
gamma: mark every gamma tupple
%}

L = 128;
f_vote0 = zeros(1,L) ;
f_vote1 = zeros(1,L) ;

[row_num,col_num] = size(T);


Start = 1;
Stop = rnd_range;
for t  = 1:row_num
    primary_key_att_value = T{t,1};
%     if t== 32041
%         pause;
%     end
    
    seed = [double(secretKey) primary_key_att_value];
    rng(sum(seed));
    rnd_seq = datasample([1:Stop],5,'Replace',false);
    if ~mod(rnd_seq(1),gamma) % if Modulo is 0, then fingerprint this tuple
%         display(t)
        att_index = mod(rnd_seq(2), col_num-2)+2; % only have col_num-2 columns that can be marked
                % since the first(index) and the last (label) columns will not be marked
                % only mark column 2-14
        att_value = T{t,att_index};  %mark this attribute
        att_value_bin = dec2bin(att_value);
        
        mark_bit = str2num( att_value_bin(end)  );
        
        
        mask_bit =  mod(rnd_seq(3),2);  % set mark_bit to 0 if S[3] is even, 1 if odd
        
        fp_bit = xor(mark_bit,mask_bit);
        
        
        fp_index =  mod(rnd_seq(4),L)+1;
        
        if fp_bit==0
            f_vote0(fp_index) = f_vote0(fp_index) +1;
        else
            f_vote1(fp_index) = f_vote1(fp_index) +1;
        end
        
    end
end
f_detect =  double(  (  f_vote1./(f_vote0+f_vote1)  )>0.5   );


f_detect(  find(  (f_vote1==f_vote0)  ==1  )   ) = nan;
end