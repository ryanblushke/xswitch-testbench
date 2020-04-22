#!/bin/csh
# Ryan Blushke, ryb861, 11177824
# CME 435 - 01, Fall Term 2019
# Project, December 5, 2019
source /CMC/scripts/mentor.questasim.2019.2.csh
cd ../verification

if (! -e work) vlib work

set testbench_lst = (../../dut/xswitch.svp ../../dut/dut_top.sv interface.sv tbench_top.sv environment.sv transaction.sv generator.sv driver.sv monitor.sv scoreboard.sv assertions.sv coverage.sv)

if ($#argv == 0) then
  echo "Syntax: csh testcases.csh <option> <test_name>"
endif
if ($#argv == 1) then
  if ("$argv[1]" != "-l") then
    echo "Syntax: csh testcases.csh <option> <test_name>"
    exit 0
  endif
  echo "Testcases: test_sanity_check, test_reset, test_valid_in"
endif
if ($#argv == 2) then
  if ("$argv[1]" != "-t") then
    echo "Syntax: csh testcases.csh <option> <test_name>"
    exit 0
  endif

  if (! -e $argv[2].sv) then
    echo "Specified test does not exist!"
    exit 0
  endif

  foreach itm ($testbench_lst)
    vlog +cover=t +acc $itm
  end

  vlog +cover=t +acc $argv[2].sv
  vsim -c -coverage -vopt tbench_top -do "coverage exclude -du downstream -togglenode {addr_in[7:2]};coverage exclude -du upstream -togglenode {addr_out[7:2]};coverage exclude -du xswitch -togglenode {addr_in[31:26]};coverage exclude -du xswitch -togglenode {addr_in[23:18]};coverage exclude -du xswitch -togglenode {addr_in[15:10]};coverage exclude -du xswitch -togglenode {addr_in[7:2]};coverage exclude -du xswitch -togglenode {addr_out[31:26]};coverage exclude -du xswitch -togglenode {addr_out[23:18]};coverage exclude -du xswitch -togglenode {addr_out[15:10]};coverage exclude -du xswitch -togglenode {addr_out[7:2]};coverage save -onexit ../../report/$argv[2].ucdb;run -all; exit"

  vcover report -details ../../report/$argv[2].ucdb -output ../../report/$argv[2].rpt
  vcover report -details -html ../../report/$argv[2].ucdb -output ../../report/$argv[2]_html
endif
