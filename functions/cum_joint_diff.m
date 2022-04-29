function diff = cum_joint_diff(joints_moved,joints_public)



fields_list = fieldnames(joints_public);
diff = 0;
for i  = 1: length(fields_list)
    
    % diff = [diff ; norm( joints_marked.(fields_list{i}) -  joints_public.(fields_list{i}) ,'fro' )];
    
    diff = diff + norm( joints_moved.(fields_list{i}) -  joints_public.(fields_list{i}) ,'fro' );
end



end