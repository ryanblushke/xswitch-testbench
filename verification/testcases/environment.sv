/*
  Ryan Blushke, ryb861, 11177824
  CME 435 - 01, Fall Term 2019
  Project, December 5, 2019
*/
`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"
class Environment #(type T=DownstreamTransaction);
  Generator #(T) gen;
  Driver #(T) driv[4];
  Monitor mon[4];
  Scoreboard #(T) scb;
  mailbox gen2driv[4];
  mailbox mon2scb[4];
  mailbox driv2scb[4];
  virtual downstream dstreams[4];
  virtual upstream ustreams[4];
  int debug = 1;
  int test_is_finished = 0;

  function new(virtual downstream dstreams[4], virtual upstream ustreams[4]);
    this.dstreams = dstreams;
    this.ustreams = ustreams;

    for (int i = 0; i < 4; i++) begin
      gen2driv[i] = new();
      mon2scb[i] = new();
      driv2scb[i] = new();
      driv[i] = new(this.dstreams[i], gen2driv[i], driv2scb[i]);
      mon[i] = new(this.ustreams[i], i, mon2scb[i]);
    end

    gen = new(gen2driv);
    scb = new(mon2scb, driv2scb);
  endfunction

  task pre_test();
    $display("%0d : Environment : start of pre_test()", $time);
    reset();
    $display("%0d : Environment : end of pre_test()", $time);
  endtask

  task reset();
    $root.tbench_top.reset = 1'b1;
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
    @dstreams[0].cb_driver;
    @dstreams[0].cb_driver;
    $root.tbench_top.reset = 1'b0;
    $display("[ ENVIRONMENT ] ----- Reset Ended -----");
  endtask

  task test();
    $display("%0d : Environment : start of test()", $time);
    gen.main();
    wait(gen.no_transactions == gen.repeat_count);
    if (debug) begin
      $display("%0d : Generated Packets: %0d", $time, gen.repeat_count);
      $display("%0d : Mailbox Port 0: %0d", $time, gen2driv[0].num());
      $display("%0d : Mailbox Port 1: %0d", $time, gen2driv[1].num());
      $display("%0d : Mailbox Port 2: %0d", $time, gen2driv[2].num());
      $display("%0d : Mailbox Port 3: %0d", $time, gen2driv[3].num());
    end
    fork
      timeout_check();
      driv[0].main();
      driv[1].main();
      driv[2].main();
      driv[3].main();
      mon[0].main();
      mon[1].main();
      mon[2].main();
      mon[3].main();
      scb.main();
    join_none
    wait(test_is_finished == 1 || scb.no_transactions.sum() + scb.error_count.sum() == gen.repeat_count);
    // wait(scb.no_transactions.sum() + scb.error_count.sum() == gen.repeat_count);
    $display("%0d : Driven Packets: %0d", $time, driv[0].no_transactions + driv[1].no_transactions + driv[2].no_transactions + driv[3].no_transactions);
    $display("%0d : Monitored Packets: %0d", $time, mon[0].no_transactions + mon[1].no_transactions + mon[2].no_transactions + mon[3].no_transactions);
    $display("%0d : Scored Packets: %0d", $time, scb.no_transactions.sum() + scb.error_count.sum());
    $display("%0d : Environment : end of test()", $time);
  endtask

  task timeout_check();
    int test_timeout = gen.repeat_count / 4 * 20 * 2;
    #test_timeout;
    test_is_finished = 1;
  endtask

  task post_test();
    $display("%0d : Environment : start of post_test()", $time);
    if (scb.error_count.sum())
      $display("Test FAILED! scb.error_count: %0d\n", scb.error_count.sum());
    else
      $display("Test PASSED! scb.error_count: %0d\n", scb.error_count.sum());
    $display("%0d : Environment : end of post_test()", $time);
  endtask

  task run;
    $display("%0d : Environment : start of run()", $time);
    pre_test();
    test();
    post_test();
    $display("%0d : Environment : end of run()", $time);
  endtask
endclass
