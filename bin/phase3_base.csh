# Ryan Blushke, ryb861, 11177824
# CME 435 - 01, Fall Term 2019
# Project, December 5, 2019
source /CMC/scripts/mentor.questasim.2019.2.csh
cd ../verification/phase3_base
if (! -e work) vlib work
set lst = (../../dut/xswitch.svp ../../dut/dut_top.sv interface.sv tbench_top.sv testbench.sv environment.sv transaction.sv)
foreach itm ($lst)
  vlog +acc $itm
end
vsim -c -vopt tbench_top -do "run -all; exit"
