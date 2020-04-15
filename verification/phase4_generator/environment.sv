/*
  Ryan Blushke, ryb861, 11177824
  CME 435 - 01, Fall Term 2019
  Project, December 5, 2019
*/
`include "generator.sv"
class Environment;
  Generator gen;
  mailbox gen2driv[4];
  //virtual interface
  virtual downstream dstreams[4];
  virtual upstream ustreams[4];

  int debug = 0;

  //constructor
  function new(virtual downstream dstreams[4], virtual upstream ustreams[4]);
    //get the interface from test
    this.dstreams = dstreams;
    this.ustreams = ustreams;

    for (int i = 0; i < 4; i++) begin
      gen2driv[i] = new();
    end

    gen = new(gen2driv);
  endfunction

  task pre_test();
    $display("%0d : Environment : start of pre_test()", $time);
    reset();
    $display("%0d : Environment : end of pre_test()", $time);
  endtask

  task reset();
    wait(dstreams[0].reset);
    $display("[ ENVIRONMENT ] ----- Reset Started -----");
    dstreams[0].cb_driver.data_in <= 8'b0;
    dstreams[1].cb_driver.data_in <= 8'b0;
    dstreams[2].cb_driver.data_in <= 8'b0;
    dstreams[3].cb_driver.data_in <= 8'b0;
    dstreams[0].cb_driver.addr_in <= 8'b0;
    dstreams[1].cb_driver.addr_in <= 8'b0;
    dstreams[2].cb_driver.addr_in <= 8'b0;
    dstreams[3].cb_driver.addr_in <= 8'b0;
    dstreams[0].cb_driver.valid_in <= 1'b0;
    dstreams[1].cb_driver.valid_in <= 1'b0;
    dstreams[2].cb_driver.valid_in <= 1'b0;
    dstreams[3].cb_driver.valid_in <= 1'b0;
    ustreams[0].cb_monitor.data_rd <= 1'b0;
    ustreams[1].cb_monitor.data_rd <= 1'b0;
    ustreams[2].cb_monitor.data_rd <= 1'b0;
    ustreams[3].cb_monitor.data_rd <= 1'b0;
    wait(!dstreams[0].reset);
    $display("[ ENVIRONMENT ] ----- Reset Ended -----");
  endtask

  task test();
    $display("%0d : Environment : start of test()", $time);
    gen.main();
    wait(gen.no_transactions == gen.repeat_count);
    $display("%0d : Generated Packets: %0d", $time, gen.no_transactions);
    $display("%0d : Environment : end of test()", $time);
  endtask

  task post_test();
    $display("%0d : Environment : start of post_test()", $time);
    $display("%0d : Environment : end of post_test()", $time);
  endtask

  //run task
  task run;
    $display("%0d : Environment : start of run()", $time);
    pre_test();
    test();
    post_test();
    $display("%0d : Environment : end of run()", $time);
    $finish;
  endtask
endclass
