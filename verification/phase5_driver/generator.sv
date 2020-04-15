/*
  Ryan Blushke, ryb861, 11177824
  CME 435 - 01, Fall Term 2019
  Project, December 5, 2019
*/
`include "transaction.sv"
class Generator;
  rand DownstreamTransaction rand_trans, drive_trans;
  int repeat_count;
  mailbox gen2driv[4];
  int no_transactions;
  int debug = 0;

  //constructor
  function new(mailbox gen2driv[4]);
    //getting the mailbox handle from env.
    this.gen2driv[0] = gen2driv[0];
    this.gen2driv[1] = gen2driv[1];
    this.gen2driv[2] = gen2driv[2];
    this.gen2driv[3] = gen2driv[3];
  endfunction

  //main task, generates (creates and randomizes) the repeat_count number of
  //transaction packets
  task main();
    rand_trans = new();
    repeat(repeat_count) begin
      if( !rand_trans.randomize() ) $fatal("Gen:: rand_trans randomization failed");
      no_transactions++;
      drive_trans = new();
      drive_trans.data_in = rand_trans.data_in;
      drive_trans.addr_in = rand_trans.addr_in;
      drive_trans.port_in = rand_trans.port_in;
      if (debug) begin
        rand_trans.display("[ RAND ]");
        drive_trans.display("[ DRIVE ]");
      end
      gen2driv[drive_trans.port_in].put(drive_trans);
    end
  endtask
endclass
