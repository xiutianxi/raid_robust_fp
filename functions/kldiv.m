

function kldist=kldiv(d1,d2)




kl = d1.*log(d1./ (d2+eps));
% kl(find(isinf(kl)==1))=0;
kl(find(isnan(kl)==1))=0;

kldist = sum(kl(:));

end