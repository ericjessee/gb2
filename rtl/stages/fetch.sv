module fetch (
    input clk,
    input rst_n,

    //memory interface
    output addr_t pc_addr,
    input  data_t instr_data,

    //RF interface
    input r16_t r_pc,
    output r16_t new_pc,
    output logic pc_wen,

);

always_comb begin
    pc_addr = r_pc;
    new_pc = r_pc + 1;
    if (fetch_cycle)
        pc_wen = 1;
end



endmodule