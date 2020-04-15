/*
  Ryan Blushke, ryb861, 11177824
  CME 435 - 01, Fall Term 2019
  Project, December 5, 2019
*/
`ifndef TRANS
`define TRANS
class DownstreamTransaction;
  rand bit [7:0] data_in;
  randc bit [7:0] addr_in;
  randc bit [7:0] port_in;

  constraint addr_in_c {
    soft addr_in inside {[0:3]};
  }

  constraint port_in_c {
    soft port_in inside {[0:3]};
  }

  function void display(string name);
    $display("- %s ", name);
    $display("-------------------------");
    $display("- data_in = %0h, addr_in = %0h, port_in = %0h", data_in, addr_in, port_in);
  endfunction
endclass

class UpstreamTransaction;
  bit [7:0] data_out;
  bit [7:0] addr_out;
  bit [7:0] port_out;

  function void display(string name);
    $display("- %s ", name);
    $display("-------------------------");
    $display("- data_out = %0h, addr_out = %0h, port_out = %0h", data_out, addr_out, port_out);
  endfunction
endclass
`endif
