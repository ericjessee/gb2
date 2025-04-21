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

mock_mem mem(
    .*,
    .wen(w_wen)
);

endmodule