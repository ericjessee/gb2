`define TEST_MEM_DEPTH 128;
module mock_mem (
    input logic clk,
    input logic rst_n,
    input logic wen,
    input addr_t read_addr,
    input addr_t write_addr,
    input data_t write_data,
    output data_t read_data
);

//unpacked to hopefully make use of block ram
data_t mem [`TEST_MEM_DEPTH-1:0];

always_comb begin
    read_data = mem[read_addr];
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mem <= '0;
        //CHEESE initialize mem with some instructions
        mem[0] <= 8'h00;
        mem[1] <= 8'h01;
    end else begin
        if (wen)
            mem[write_addr] <= write_data;
    end
end

endmodule