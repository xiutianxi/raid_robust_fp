function num_match = bits_match(fp_detect, fp)
%{

calcualte the number of mathced bits given a extracted fp and a true fp
%}

num_match = sum( fp_detect==fp   );

end