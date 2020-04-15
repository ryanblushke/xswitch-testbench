/*
  Ryan Blushke, ryb861, 11177824
  CME 435 - 01, Fall Term 2019
  Project, December 5, 2019
*/
module dut_top(downstream.dut dstreams[4], upstream.dut ustreams[4]);
  xswitch dut(
    .clk(dstreams[0].clk),
    .reset(dstreams[0].reset),
    .data_in({
      dstreams[3].data_in,
      dstreams[2].data_in,
      dstreams[1].data_in,
      dstreams[0].data_in}),
    .addr_in({
      dstreams[3].addr_in,
      dstreams[2].addr_in,
      dstreams[1].addr_in,
      dstreams[0].addr_in}),
    .rcv_rdy({
      dstreams[3].rcv_rdy,
      dstreams[2].rcv_rdy,
      dstreams[1].rcv_rdy,
      dstreams[0].rcv_rdy}),
    .valid_in({
      dstreams[3].valid_in,
      dstreams[2].valid_in,
      dstreams[1].valid_in,
      dstreams[0].valid_in}),
    .data_out({
      ustreams[3].data_out,
      ustreams[2].data_out,
      ustreams[1].data_out,
      ustreams[0].data_out}),
    .addr_out({
      ustreams[3].addr_out,
      ustreams[2].addr_out,
      ustreams[1].addr_out,
      ustreams[0].addr_out}),
    .data_rd({
      ustreams[3].data_rd,
      ustreams[2].data_rd,
      ustreams[1].data_rd,
      ustreams[0].data_rd}),
    .valid_out({
      ustreams[3].valid_out,
      ustreams[2].valid_out,
      ustreams[1].valid_out,
      ustreams[0].valid_out})
  );
endmodule
