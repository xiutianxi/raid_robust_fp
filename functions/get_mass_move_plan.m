function plans = get_mass_move_plan(...
    marginals_public,joints_public,marginals_marked,joints_marked,thr,lambda)
%{
first, get the attribute columns whose mass is need to be moved based on
the difference between pairwise joint distributions

second, get the mass move plans using the regularized optimal transport
%}



fields_list = fieldnames(joints_public);
diff = {};
for i  = 1: length(fields_list)
    
    % diff = [diff ; norm( joints_marked.(fields_list{i}) -  joints_public.(fields_list{i}) ,'fro' )];
    
    if norm( joints_marked.(fields_list{i}) -  joints_public.(fields_list{i}) ,'fro' )>=thr
        diff = [diff strsplit(fields_list{i},'_with_')];
    end
end
diff = unique(diff);

% lambda = 10;
res = 10^(-8);

plans = struct();

for i = 1:length(diff)
    p1 = marginals_marked.(diff{i});
    
    p2 = marginals_public.(diff{i});

    P = sinkhorn_dist(p1,p2,lambda,res);
    plans.(diff{i}) = P;
end
end





function P = sinkhorn_dist(p1,p2,lambda,res)
%{
p1 is the marked marginal
p2 is the original marginal
move the mass of p1 to make it close to p2

%}

n = length(p1);
M = squareform( pdist(  [1:n]' ,  'squaredeuclidean' ) );
M = M./max(M(:));

P = exp(-lambda*M);
P = P./(sum(P(:)));

u = zeros(1,n);
while max(  abs(u-sum(P,1))  )>=res
    max(  abs(u-sum(P,1))  );
    u = sum(P,1);
    % scale the rows to  match p2
    P = P.*repmat(   p2./sum(P,1),  n, 1  );
    
    % scale the columns to match p1
    P = P.*repmat(   (p1)' ./ sum(P,2) ,  1, n  );
%     P = P./(sum(P(:)));

end
end