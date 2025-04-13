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

//unpacked to hopefully make use of block ram
data_t mem [0:`TEST_MEM_DEPTH-1];

always_comb begin
    r_data = mem[r_addr];
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        //CHEESE initialize mem with some instructions
        mem[0] <= 8'h3e; //load a with immediate
        mem[1] <= 8'hbe; //immediate = be
        mem[2] <= 8'h3c; //increment a

        //fill rest of memory with something for testing
        for (int i=3; i<`TEST_MEM_DEPTH; i++)
            mem[i] <= 8'hff;
            
    end else begin
        if (wen)
            mem[w_addr] <= w_data;
    end
end

endmodule