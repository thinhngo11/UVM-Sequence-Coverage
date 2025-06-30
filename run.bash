#Synopsys VCS
#vcs -licqueue -timescale=1ns/1ns +vcs+flush+all +warn=all -sverilog -lca -debug_access+all  testbench.sv

./simv +vcs_lic+wait +ntb_random_seed_automatic

urg -dir simv.vdb -format text -group show_bin_values

cat urgReport/dashboard.txt
cat urgReport/groups.txt
cat urgReport/grpinfo.txt
