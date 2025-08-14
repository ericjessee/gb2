module idu import sm83_pkg::*;(
    input logic inc_ndec,
    input logic bypass,
    input r16_t r16_in,
    output r16_t r16_out
);

always_comb begin
    if (!bypass)
        r16_out = (inc_ndec) ? (r16_in + 1) : (r16_in - 1);
    else
        r16_out = r16_in;
end

endmodule