/*
  Ryan Blushke, ryb861, 11177824
  CME 435 - 01, Fall Term 2019
  Project, December 5, 2019
*/
interface downstream(input logic clk, reset);
  logic [7:0] data_in;
  logic [7:0] addr_in;
  logic rcv_rdy;
  logic valid_in;

  clocking cb_driver @(posedge clk);
    output data_in;
    output addr_in;
    input rcv_rdy;
    output valid_in;
  endclocking

  modport dut(
    input clk,
    input reset,
    input data_in,
    input addr_in,
    output rcv_rdy,
    input valid_in
  );

  modport driver(
    input clk,
    input reset,
    clocking cb_driver
  );
endinterface

interface upstream(input logic clk, reset);
  logic [7:0] data_out;
  logic [7:0] addr_out;
  logic data_rd;
  logic valid_out;

  clocking cb_monitor @(posedge clk);
    input data_out;
    input addr_out;
    output data_rd;
    input valid_out;
  endclocking

  modport dut(
    input clk,
    input reset,
    output data_out,
    output addr_out,
    input data_rd,
    output valid_out
  );

  modport monitor(
    input clk,
    input reset,
    clocking cb_monitor
  );
endinterface
