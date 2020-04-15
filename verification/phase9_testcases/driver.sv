/*
  Ryan Blushke, ryb861, 11177824
  CME 435 - 01, Fall Term 2019
  Project, December 5, 2019
*/
`include "transaction.sv"
class Driver #(type T=DownstreamTransaction);
  virtual downstream vif;
  mailbox gen2driv, driv2scb;
  int no_transactions;
  int debug = 0;
  int debug_discard = 0;

  function new(virtual downstream vif, mailbox gen2driv, mailbox driv2scb);
    this.vif = vif;
    this.gen2driv = gen2driv;
    this.driv2scb = driv2scb;
  endfunction

  task main;
    T trans;
    forever begin
      @vif.cb_driver;
      gen2driv.get(trans);
      if (vif.cb_driver.rcv_rdy == 1'b1) begin
        vif.cb_driver.data_in <= trans.data_in;
        vif.cb_driver.addr_in <= trans.addr_in;
        vif.cb_driver.valid_in <= trans.valid_in;
        if (debug)
          trans.display("[ Driver ]");
        if (trans.valid_in == 1'b1 && trans.addr_in <= 3 && trans.addr_in >= 0)
          driv2scb.put(trans);
        no_transactions++;
      end
      else begin
        vif.cb_driver.valid_in <= 1'b0;
        if (debug_discard)
          trans.display("[ Driver ] [ DISCARDED ]");
      end
    end
  endtask
endclass
