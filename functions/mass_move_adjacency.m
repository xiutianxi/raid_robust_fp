function T = mass_move_adjacency(T,plans)

[row_num, col_num] = size(T);

attack_fields_list = fieldnames(plans);
for i = 1:length(attack_fields_list)
    mass_move  = plans.(attack_fields_list{i}) * row_num;
    
    s1 = size(mass_move,1);
    
    mask = ones(s1) - eye(s1);
    mask = mask - tril(mask,-2) -  triu(mask,2);
    mask(1,s1) = 1;
    mask(s1,1) = 1;
    
    mass_move = mass_move.*mask ;
    col_i = T.(attack_fields_list{i});
    
    for j = 1:length(mass_move)
        idx = find(  mass_move(j,:)>=1  );
        if isempty(idx)
            continue;
        else
            mass_content = idx -1;  % move mass of (j-1) to mass_content
            index1 = find( col_i== j-1 );
            perturb_idx_cumu = [];
            for m = 1:length(mass_content)
                index1 = setdiff(  index1, perturb_idx_cumu ) ;
                perturb_idx = datasample(  index1, floor(mass_move(j,idx(m))) , 'Replace',false)  ;
                perturb_idx_cumu = [perturb_idx_cumu; perturb_idx];
                col_i(perturb_idx)  = mass_content(m);
            end
        end
    end
    T.(attack_fields_list{i}) = col_i;
    
end
end