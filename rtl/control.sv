module control import sm83_pkg::*;(
    input  logic    clk,
    input  logic    rst_n,
    input  ctl_op_t ctl_op,
    
    output logic    a_wen,
    output logic    fetch_cycle,
    output logic    execute_cycle,
    output logic    execute_last
);

ctl_op_t curr_op;

always_comb begin
    a_wen      = '0;
    if (execute_cycle)
        case (curr_op)
            CTL_LD_R8_D8: begin
                
            end
            // CTL_ALU_R8: begin
            //     case ()
            // end
        endcase
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        fetch_cycle <= '1;
        execute_cycle <= '0;
        execute_last <= '0;
        curr_op <= CTL_NOP;
    end
    else begin
        if (execute_last) begin
            fetch_cycle <= '1;
        end
        else begin
            fetch_cycle <= '0;
        end

        if (fetch_cycle) begin
            execute_cycle <= '1;
            execute_last <= '1;
            curr_op <= ctl_op;
        end
        else 
            {execute_cycle, execute_last} = 2'b00;
    end

end

endmodule