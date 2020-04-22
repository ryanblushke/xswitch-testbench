#!/bin/csh
# Ryan Blushke, ryb861, 11177824
# CME 435 - 01, Fall Term 2019
# Project, December 5, 2019

if ($#argv != 1) then
  echo "Syntax: csh regression_test.csh <option>"
  exit 0
endif

if ("$argv[1]" != "-fc" && "$argv[1]" != "-cc") then
  echo "Syntax: csh regression_test.csh <option>"
  exit 0
endif
source /CMC/scripts/mentor.questasim.2019.2.csh
cd ../verification

if (! -e work) vlib work

set testbench_lst = (../../dut/xswitch.svp ../../dut/dut_top.sv interface.sv tbench_top.sv environment.sv transaction.sv generator.sv driver.sv monitor.sv scoreboard.sv assertions.sv coverage.sv)

set testcase_lst = (test_sanity_check test_reset test_valid_in)

foreach itm ($testbench_lst)
  vlog +cover=t +acc $itm
end
if ("$argv[1]" == "-fc") then
  set coverage = "fc"
  foreach testcase ($testcase_lst)
    vlog +cover=t +acc $testcase.sv
    vsim -c -coverage -vopt tbench_top -do "coverage save -cvg -directive -assert -onexit ../../report/$testcase.ucdb;run -all; exit"
  end
endif
if ("$argv[1]" == "-cc") then
  set coverage = "cc"
  foreach testcase ($testcase_lst)
    vlog +cover=t +acc $testcase.sv
    vsim -c -coverage -vopt tbench_top -do "coverage exclude -du downstream -togglenode {addr_in[7:2]};coverage exclude -du upstream -togglenode {addr_out[7:2]};coverage exclude -du xswitch -togglenode {addr_in[31:26]};coverage exclude -du xswitch -togglenode {addr_in[23:18]};coverage exclude -du xswitch -togglenode {addr_in[15:10]};coverage exclude -du xswitch -togglenode {addr_in[7:2]};coverage exclude -du xswitch -togglenode {addr_out[31:26]};coverage exclude -du xswitch -togglenode {addr_out[23:18]};coverage exclude -du xswitch -togglenode {addr_out[15:10]};coverage exclude -du xswitch -togglenode {addr_out[7:2]};coverage save -codeAll -onexit ../../report/$testcase.ucdb;run -all; exit"
  end
endif

vcover merge -64 ../../report/xswitch_$coverage.ucdb ../../report/test_sanity_check.ucdb ../../report/test_reset.ucdb ../../report/test_valid_in.ucdb
vcover report -details ../../report/xswitch_$coverage.ucdb -output ../../report/xswitch_$coverage.rpt
vcover report -details -html ../../report/xswitch_$coverage.ucdb -output ../../report/xswitch_"$coverage"_html
