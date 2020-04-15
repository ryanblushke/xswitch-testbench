/*
  Ryan Blushke, ryb861, 11177824
  CME 435 - 01, Fall Term 2019
  Project, December 5, 2019
*/
`include "transaction.sv"
class Coverage;
  DownstreamTransaction trans;

  covergroup trans_cg;
    data_in : coverpoint trans.data_in {
      bins min = {0};
      bins between = {[1:254]};
      bins max = {255};
    }
    addr_in : coverpoint trans.addr_in {
      bins port_out_0 = {0};
      bins port_out_1 = {1};
      bins port_out_2 = {2};
      bins port_out_3 = {3};
    }
    port_in : coverpoint trans.port_in {
      bins port_in_0 = {0};
      bins port_in_1 = {1};
      bins port_in_2 = {2};
      bins port_in_3 = {3};
    }
    cross data_in, addr_in, port_in;
  endgroup

  function void sample_trans(DownstreamTransaction trans);
    this.trans = trans;
    trans_cg.sample();
  endfunction

  function new();
    trans_cg = new();
  endfunction
endclass
