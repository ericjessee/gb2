`include "sm83_pkg.sv"
`include "mock_mem_pathed.sv"
module sm83_top import sm83_pkg::*;(
    input         clk,
    input         rst_n,
    output data_t r_data,
    output data_t w_data,
    output addr_t r_addr,
    output addr_t w_addr,
    output logic  w_wen,
    output logic  halt
);

sm83_core cpu(
    .*
);

mock_mem ROM0(
    .*,
    .wen('0)
);

addr_t wram0_local_addr;
logic wram0_wen;
always_comb begin
    wram0_local_addr = r_addr - 16'hc000; //r and w are tied together
    wram0_wen = w_wen & (r_addr >= 16'hc000);
end

mock_mem #(
    .IS_ROM(0)
) WRAM0(
    .*,
    .wen(wram0_wen)
);

`ifdef VERILATOR_SIM
logic [15:0] addr_concat;
assign addr_concat = 16'(r_addr);
`endif

endmodule