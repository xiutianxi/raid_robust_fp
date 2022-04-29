function D = p_hamming_dist_incomedb(db)


D = squareform( pdist(db,  'hamming' ) );
end