/*
  Ryan Blushke, ryb861, 11177824
  CME 435 - 01, Fall Term 2019
  Project, December 5, 2019
*/
module assertions(downstream.dut dstreams[4], upstream.dut ustreams[4]);
  int debug = 0;
  int debug_addr_out = 0;
  int debug_data_rd_rcv_rdy = 0;
  int debug_rcv_rdy_eq_data_rd = 0;

  default clocking cb @(posedge dstreams[0].clk);
  endclocking

  sequence s_valid_in1(port_in, port_out);
    dstreams[port_in].valid_in == 1'b1 && dstreams[port_in].addr_in == port_out;
  endsequence

  // if port_in is driven then valid_in must go high
  // port_out valid_out must go high same clock cycle
  property p_valid1(port_in, port_out);
   disable iff (dstreams[port_in].reset) @(cb) s_valid_in1(port_in, port_out) |-> s_valid_out1(port_in, port_out);
  endproperty

  generate
  for (genvar port_in = 0; port_in < 4; port_in++)
    for (genvar port_out = 0; port_out < 4; port_out++) begin
      a_valid1: assert property(p_valid1(port_in, port_out));
      c_valid1: cover property(p_valid1(port_in, port_out));
    end
  endgenerate

  sequence s_valid_in0(port_in, port_out);
    dstreams[port_in].valid_in == 1'b0 && dstreams[port_in].addr_in == port_out;
  endsequence

  sequence s_valid_out0(port_out);
    ustreams[port_out].valid_out == 1'b0;
  endsequence

  // if port_in is driven with valid_in low
  // port_out valid_out must stay low same clock cycle
  property p_valid0(port_in, port_out);
   disable iff (dstreams[port_in].reset) @(cb) s_valid_in0(port_in, port_out) |-> s_valid_out0(port_out);
  endproperty

  generate
  for (genvar port_in = 0; port_in < 4; port_in++)
    for (genvar port_out = 0; port_out < 4; port_out++) begin
      a_valid0: assert property(p_valid0(port_in, port_out));
      c_valid0: cover property(p_valid0(port_in, port_out));
    end
  endgenerate

  sequence s_data_out(port_in, port_out);
    ustreams[port_out].data_out == dstreams[port_in].data_in;
  endsequence

  // if port_in is driven then valid_in must go high
  // port_out data_out must be correct same clock cycle
  property p_data_in_out(port_in, port_out);
   disable iff (dstreams[port_in].reset) @(cb) s_valid_in1(port_in, port_out) |-> s_data_out(port_in, port_out);
  endproperty

  generate
  for (genvar port_in = 0; port_in < 4; port_in++)
    for (genvar port_out = 0; port_out < 4; port_out++) begin
      a_data_in_out: assert property(p_data_in_out(port_in, port_out));
      c_data_in_out: cover property(p_data_in_out(port_in, port_out));
    end
  endgenerate

  sequence s_addr_out(port_in, port_out);
    ustreams[port_out].addr_out == port_in;
  endsequence

  // if port_in is driven then valid_in must go high
  // port_out addr_out must be correct same clock cycle
  property p_addr_out(port_in, port_out);
   disable iff (dstreams[port_in].reset) @(cb) s_valid_in1(port_in, port_out) |-> s_addr_out(port_in, port_out);
  endproperty

  generate
  for (genvar port_in = 0; port_in < 4; port_in++)
    for (genvar port_out = 0; port_out < 4; port_out++) begin
      a_addr_out: assert property(p_addr_out(port_in, port_out));
      c_addr_out: cover property(p_addr_out(port_in, port_out));
    end
  endgenerate

  sequence s_data_rd(port_in, port_out);
    ustreams[port_out].data_rd == 1'b1 && ustreams[port_out].addr_out == port_in;
  endsequence

  sequence s_rcv_rdy(port_in, port_out);
    dstreams[port_in].rcv_rdy == 1'b1;
  endsequence

  // if data_rd is set then rcv_rdy must go high
  property p_data_rd_rcv_rdy(port_in, port_out);
   disable iff (dstreams[port_in].reset) @(cb) s_data_rd(port_in, port_out) |-> s_rcv_rdy(port_in, port_out);
  endproperty

  generate
  for (genvar port_in = 0; port_in < 4; port_in++)
    for (genvar port_out = 0; port_out < 4; port_out++) begin
      a_data_rd_rcv_rdy: assert property(p_data_rd_rcv_rdy(port_in, port_out));
      c_data_rd_rcv_rdy: cover property(p_data_rd_rcv_rdy(port_in, port_out));
    end
  endgenerate

  sequence s_valid_out1(port_in, port_out);
    ustreams[port_out].valid_out == 1'b1 && ustreams[port_out].addr_out == port_in;
  endsequence

  sequence s_data_rd_test(port_in, port_out, value);
    ustreams[port_out].data_rd == value;
  endsequence

  sequence s_rcv_rdy_test(port_in, port_out, value);
    dstreams[port_in].rcv_rdy == value;
  endsequence

  // if valid_out is set then next clock cycle data_rd must equal rcv_rdy
  property p_rcv_rdy_eq_data_rd(port_in, port_out, value);
   disable iff (dstreams[port_in].reset) @(cb) s_valid_out1(port_in, port_out) |=> s_data_rd_test(port_in, port_out, value) |-> s_rcv_rdy_test(port_in, port_out, value);
  endproperty

  generate
  for (genvar port_in = 0; port_in < 4; port_in++)
    for (genvar port_out = 0; port_out < 4; port_out++) begin
      a_rcv_rdy_eq_data_rd1: assert property(p_rcv_rdy_eq_data_rd(port_in, port_out, 1));
      c_rcv_rdy_eq_data_rd1: cover property(p_rcv_rdy_eq_data_rd(port_in, port_out, 1));
    end
  endgenerate

endmodule
