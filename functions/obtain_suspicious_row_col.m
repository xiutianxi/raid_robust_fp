function [select_row, select_col] = ...
    obtain_suspicious_row_col(joints_public, joints_marked,R_marked,diff_thr,s_atts_ins)


atts = fieldnames(joints_public);
select_row = [];
select_col = [];

att_list = fieldnames(s_atts_ins);


for i  = 1:length(atts)
    joint_pub = joints_public.(atts{i});
    joint_mar = joints_marked.(atts{i});
    joint_diff = abs((joint_mar - joint_pub)./joint_pub);
end

for i  = 1:length(atts)
    joint_pub = joints_public.(atts{i});
    joint_mar = joints_marked.(atts{i});
    joint_diff = abs((joint_mar - joint_pub)./joint_pub);
    [idx_x,idx_y] = ind2sub(size(joint_diff),find(joint_diff>=diff_thr));


% [idx_x,idx_y] = ind2sub(  size(joint_pub),find(  (  (joint_pub==0) & (joint_mar~=0) )));






    att_names = strsplit(atts{i},'_with_');
    att1 = att_names{1};
    att2 = att_names{2};
    [~,idx1]=ismember(att1,att_list);
    [~,idx2]=ismember(att2,att_list);
    for j  = 1:length(idx_x)
        select_row = [select_row;
            find(  R_marked.(att1)==  idx_x(j)-1 &  R_marked.(att2)==  idx_y(j)-1)  ];
        l  =  length( find(  R_marked.(att1)==  idx_x(j)-1 &  R_marked.(att2)==  idx_y(j)-1) );
        select_col = [select_col   ;   repmat(  [idx1+1 idx2+1],l,1)  ];
    end
end

% select_row = unique(select_row);

end