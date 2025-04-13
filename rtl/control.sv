module control import sm83_pkg::*;(
    input clk,
    input rst_n,
    output logic fetch_cycle,
    output logic execute_cycle
);

logic execute_last;

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        fetch_cycle <= '0;
        execute_cycle <= '0;
        execute_last <= '1;
    end
    else begin
        if (execute_last)
            fetch_cycle <= '1;
        if (fetch_cycle) begin
            execute_cycle <= '1;
            execute_last <= '1;
        end
    end

end

endmodule