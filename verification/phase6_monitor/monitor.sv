/*
  Ryan Blushke, ryb861, 11177824
  CME 435 - 01, Fall Term 2019
  Project, December 5, 2019
*/
`include "transaction.sv"
class Monitor;
  UpstreamTransaction trans;
  virtual upstream vif;
  int port;
  int no_transactions;
  int debug = 0;

  function new(virtual upstream vif, int port);
    this.vif = vif;
    this.port = port;
  endfunction

  task main;
    forever begin
      @vif.cb_monitor;
      if (vif.cb_monitor.valid_out) begin
        trans = new();
        vif.cb_monitor.data_rd <= 1'b1;
        trans.port_out = port;
        trans.data_out = vif.cb_monitor.data_out;
        trans.addr_out = vif.cb_monitor.addr_out;
        if (debug)
          trans.display("[ Monitor ]");
        no_transactions++;
      end
      else
        vif.cb_monitor.data_rd <= 1'b0;
    end
  endtask
endclass
