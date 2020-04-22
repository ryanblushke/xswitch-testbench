/*
  Ryan Blushke, ryb861, 11177824
  CME 435 - 01, Fall Term 2019
  Project, December 5, 2019
*/
`include "environment.sv"
program automatic testbench(downstream.driver dstreams[4], upstream.monitor ustreams[4]);
  //declaring environment instance
  Environment #(DownstreamTransaction) env;

  initial begin
    $display("******************* Start of testcase ****************");
    repeat (2) begin
      $root.tbench_top.dut.dut.enable_dut_bugs(11177824);
      //creating environment
      env = new(dstreams, ustreams);
      //setting the repeat count of generator such as 5, means to generate 5
      //packets
      env.gen.repeat_count = 40000;
      //calling run of env, it in turns calls other main tasks.
      env.run();
    end
    $display("******************* End of testcase ****************");
    $finish;
  end
endprogram
