module sm83_top_tb import sm83_pkg::*;;
`include "lib_ej_tb.vh"

logic clk;
logic rst_n;

data_t r_data;
data_t w_data;
addr_t r_addr;
addr_t w_addr;

sm83_top dut(.*);

// always @(posedge clk)
//     $display("clock cycle");

initial begin
    startup();
    wait_cycles(10);
    $finish;
end

endmodule