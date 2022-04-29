MATLAB implementation of "The Curse of Correlations for Robust Fingerprinting of Relational Databases", 24th International Symposium on Research in Attacks, Intrusions and Defenses (RAID'21)

Folder "functions" records the functions used in this work, e.g., the random bit flipping attack, row- and column-wise correlation attacks, vanilla fingerprinting scheme, and the row- and column-wise mitigation techniques.

Folder “save data” records some of the intermediate results.

Use the following scripts to reproduce similar results reported in the paper

part02_mark_db.m performs the vanilla fingerprinting

part03_01_corrflip_vs_rndflip.m --------------  part of the results in Table 2 and results in Table 3

part03_02_utility_atk_col_vs_atk_rnd.m -------------- results in Figure 4

part04_01_corrflip_after_corrdefense.m -------------- results in Figure 5 and 6 (a)

part04_02_utilities_corrflip_after_corrdefense.m -------------- results in Figure 6 (b)

part05_atk_row.m -------------- part of the results in Table 2

part05_atk_row_vs_dfs_row.m -------------- results in Table 4
