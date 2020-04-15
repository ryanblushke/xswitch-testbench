/*
  Ryan Blushke, ryb861, 11177824
  CME 435 - 01, Fall Term 2019
  Project, December 5, 2019
*/
`include "transaction.sv"
class Driver;
  virtual downstream vif;
  mailbox gen2driv;
  int no_transactions;
  int debug = 1;

  //constructor
  function new(virtual downstream vif, mailbox gen2driv);
    //getting the interface
    this.vif = vif;
    //getting the mailbox handles from environment
    this.gen2driv = gen2driv;
  endfunction

  //drive the transaction items to interface signals
  task main;
    DownstreamTransaction trans;
    forever begin
      @vif.cb_driver;
      gen2driv.get(trans);
      vif.cb_driver.valid_in <= 1'b1;
      vif.cb_driver.data_in <= trans.data_in;
      vif.cb_driver.addr_in <= trans.addr_in;
      if (debug)
        trans.display("[ Driver ]");
      no_transactions++;
    end
  endtask
endclass
