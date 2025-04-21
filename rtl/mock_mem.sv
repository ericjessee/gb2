`include "global_defines.vh"

module mock_mem import sm83_pkg::*;(
    input  logic clk,
    input  logic rst_n,
    input  logic wen,
    input  addr_t r_addr,
    input  addr_t w_addr,
    input  data_t w_data,
    output data_t r_data
);

//unpacked to hopefully make use of block ram at some point
data_t mem [0:`TEST_MEM_DEPTH-1];

initial begin
    $readmemh("/home/eric/Projects/gb2/asm/scripts/build_dir/test_jp_a16.mem", mem);
end

always_comb begin
    r_data = mem[r_addr];
end

always @(posedge clk) begin
    if (wen)
        mem[w_addr] <= w_data;
end

endmodule
