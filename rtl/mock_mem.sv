`include "global_defines.vh"
module mock_mem import sm83_pkg::*;
#(parameter logic IS_ROM = 1)
(
    input  logic clk,
    input  logic rst_n,
    input  logic wen,
    input  addr_t r_addr,
    input  addr_t w_addr,
    input  data_t w_data,
    output data_t r_data
);
/* verilator lint_off WIDTHTRUNC */
//unpacked to hopefully make use of block ram at some point
data_t mem [0:`TEST_MEM_DEPTH-1];


initial begin
    if (IS_ROM)
        $readmemh(>>mempath<<, mem);  //mempath must be replaced by script!
end

always_comb begin
    r_data = mem[r_addr];
end

always @(posedge clk) begin
    if (wen)
        mem[w_addr] <= w_data;
end

/* verilator lint_on WIDTHTRUNC */
endmodule
