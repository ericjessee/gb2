`include "mock_mem_pathed.sv"
module sm83_top import sm83_pkg::*;(
    input         clk,
    input         rst_n,
    output data_t r_data_out,
    output data_t w_data_out,
    output addr_t addr_out,
    output logic  w_wen,
    output logic  halt
);

logic [7:0] rom0_data;
logic [7:0] wram0_data;

always_comb begin
    r_data_out = '0;
    if (addr_out < 16'ha000)
        r_data_out = rom0_data;
    else if (addr_out >= 16'hc000)
        r_data_out = wram0_data;
end

sm83_core cpu(
    .clk(clk),
    .rst_n(rst_n),
    .r_data(r_data_out),
    .w_data(w_data_out),
    .r_addr(addr_out),
    .w_addr(),
    .w_wen(w_wen),
    .halt(halt)
);

mock_mem #(
    .MEM_DEPTH(16'h4000) //i think this should be up to 3fff?
) ROM0(
    .clk(clk),
    .rst_n(rst_n),
    .wen('0),
    .r_addr(addr_out),
    .w_addr(addr_out),
    .w_data('0),
    .r_data(rom0_data)
);

addr_t wram0_local_addr;
logic wram0_wen;
always_comb begin
    wram0_local_addr = addr_out - 16'hc000; //r and w are tied together
    wram0_wen = w_wen & (addr_out >= 16'hc000);
end

mock_mem #(
    .MEM_DEPTH(16'h100),
    .IS_ROM(0)
) WRAM0(
    .clk(clk),
    .rst_n(rst_n),
    .wen(wram0_wen),
    .r_addr(wram0_local_addr),
    .w_addr(wram0_local_addr),
    .w_data(w_data_out),
    .r_data(wram0_data)
);

`ifdef VERILATOR_SIM
logic [15:0] addr_concat;
assign addr_concat = 16'(addr_out);
`endif

endmodule