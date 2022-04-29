function fp =  sp_id_fingerprint_generate(secretKey, sp_id)
%{
get the fingerprint of service provider (sp_id)
secretKey: service provider's secret key
%}
rand_str = [ secretKey string(sp_id)  ];
fp = hex2bin(DataHash(rand_str,'MD5'));
end