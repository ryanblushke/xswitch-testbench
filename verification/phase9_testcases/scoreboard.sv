/*
  Ryan Blushke, ryb861, 11177824
  CME 435 - 01, Fall Term 2019
  Project, December 5, 2019
*/
`include "transaction.sv"
class Scoreboard #(type T=DownstreamTransaction);
  mailbox mon2scb[4];
  mailbox driv2scb[4];
  int no_transactions[4] = {0, 0, 0, 0};
  int error_count[4] = {0, 0, 0, 0};
  int debug = 0;

  function new(mailbox mon2scb[4], mailbox driv2scb[4]);
    this.mon2scb = mon2scb;
    this.driv2scb = driv2scb;
  endfunction

  task sanity_check(int port, T driv_trans, UpstreamTransaction mon_trans);
    if (mon_trans.port_out != driv_trans.addr_in) begin
      $display("mon_trans.port_out != driv_trans.addr_in\n");
      $display("driv_trans.addr_in: %0d\n", driv_trans.addr_in);
      $display("mon_trans.port_out: %0d\n", mon_trans.port_out);
      error_count[port]++;
      return;
    end
    if (driv_trans.data_in != mon_trans.data_out) begin
      $display("driv_trans.data_in != mon_trans.data_out\n");
      $display("driv_trans.data_in: %0d\n", driv_trans.data_in);
      $display("mon_trans.data_out: %0d\n", mon_trans.data_out);
      error_count[port]++;
      return;
    end
    no_transactions[port]++;
  endtask

  task poll_boxes(int port);
    T driv_trans;
    UpstreamTransaction mon_trans;
    while (1) begin
      mon2scb[port].get(mon_trans);
      if (driv2scb[mon_trans.addr_out].num() > 0) begin
        driv2scb[mon_trans.addr_out].get(driv_trans);
        sanity_check(port, driv_trans, mon_trans);
      end
      else
        error_count[port]++;
      if (debug) begin
        driv_trans.display("[ Scoreboard - Driver ]");
        mon_trans.display("[ Scoreboard - Monitor ]");
      end
    end
  endtask

  task main;
    fork
      poll_boxes(0);
      poll_boxes(1);
      poll_boxes(2);
      poll_boxes(3);
    join_none
  endtask
endclass
