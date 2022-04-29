function div  =kl_divergence(P,Q)

%{
P is the original distribution, and Q is the new distribution
%}

P = P(:);
Q = Q(:);
r = log(P./Q);
r(isnan(r))=0;
r(isinf(r)) =0;
div = dot(P,r);
end