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

always_comb begin
    r_data = mem[r_addr];
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        //CHEESE initialize mem with some instructions
        mem[0] <= 8'h3e; //load a with immediate
        mem[1] <= 8'h10; //immediate 10h
        mem[2] <= 8'h06; //load b with immediate
        mem[3] <= 8'h20; //immediate 20h
        mem[4] <= 8'h0e; //load c with immediate
        mem[5] <= 8'hff; //immediate ffh
        mem[6] <= 8'h16; //load d with immediate
        mem[7] <= 8'h40; //immediate 40h
        mem[8] <= 8'h3c; //increment a
        mem[9] <= 8'h04; //increment b
        mem[10] <= 8'h0c; //increment c
        mem[11] <= 8'h14; //increment d
        mem[12] <= 8'h76; //HALT

        //fill rest of memory with something for testing
        for (int i=13; i<`TEST_MEM_DEPTH; i++)
            mem[i] <= 8'hff;
            
    end else begin
        if (wen)
            mem[w_addr] <= w_data;
    end
end

endmodule