/*
  Ryan Blushke, ryb861, 11177824
  CME 435 - 01, Fall Term 2019
  Project, December 5, 2019
*/
`timescale 1ns/1ns
module tbench_top;

  // clock and reset signal declaration
  bit clk;
  bit reset;

  // clock generation
  always #10 clk = ~clk;

  // reset Generation
  initial begin
    reset = 0;
  end

  // creating array of interfaces, in order to connect DUT and testcase
  downstream dstreams[4](clk, reset);

  // creating array of interfaces, in order to connect DUT and testcase
  upstream ustreams[4](clk, reset);

  // Testcase instance, interface handle is passed to test as an argument
  testbench test(dstreams, ustreams);

  // DUT instance, interface signals are connected to the DUT ports
  dut_top dut(
    .dstreams(dstreams),
    .ustreams(ustreams)
  );

  bind dut_top assertions assert_dut(
    .dstreams(dstreams),
    .ustreams(ustreams)
  );

  // enabling the wave dump
  initial begin
    $dumpfile("dump.vcd"); $dumpvars;
  end
endmodule
