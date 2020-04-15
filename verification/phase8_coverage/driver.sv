/*
  Ryan Blushke, ryb861, 11177824
  CME 435 - 01, Fall Term 2019
  Project, December 5, 2019
*/
`include "transaction.sv"
class Driver;
  virtual downstream vif;
  mailbox gen2driv, driv2scb;
  int no_transactions;
  int debug = 0;

  function new(virtual downstream vif, mailbox gen2driv, mailbox driv2scb);
    this.vif = vif;
    this.gen2driv = gen2driv;
    this.driv2scb = driv2scb;
  endfunction

  task main;
    DownstreamTransaction trans;
    forever begin
      @vif.cb_driver;
      gen2driv.get(trans);
      if (vif.cb_driver.rcv_rdy == 1'b1) begin
        vif.cb_driver.valid_in <= 1'b1;
        vif.cb_driver.data_in <= trans.data_in;
        vif.cb_driver.addr_in <= trans.addr_in;
      end
      else begin
        vif.cb_driver.valid_in <= 1'b0;
        vif.cb_driver.data_in <= trans.data_in;
        vif.cb_driver.addr_in <= trans.addr_in;
      end
      if (debug)
        trans.display("[ Driver ]");
      driv2scb.put(trans);
      no_transactions++;
    end
  endtask
endclass
