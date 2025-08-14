module sm83_top_tb import sm83_pkg::*;;

logic clk;
logic rst_n;

`include "lib_ej_tb.vh"
data_t r_data_out;
data_t w_data_out;
addr_t addr_out;
logic w_wen;
logic halt;

sm83_top dut(.*);

// always @(posedge clk)
//     $display("clock cycle");

initial begin
    startup();
    wait_cycles(100);
end

endmodule