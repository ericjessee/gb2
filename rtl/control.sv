module control import sm83_pkg::*;(
    input  logic      clk,
    input  logic      rst_n,
    input  ctl_op_t   ctl_op,
    
    output addr_sel_t addr_sel,
    output logic      inc_pc,
    output logic      fetch_cycle,
    output logic      mem_to_r8
);

ctl_op_t          curr_op;
ctl_state_t       current_state;
ctl_state_t [0:3] execute_sequence;
logic [0:3]       current_idx;
logic [0:3]       last_idx;


//demux the current state from the sequence vector
always_comb begin
    case (current_idx)
        0: current_state = execute_sequence[0];
        1: current_state = execute_sequence[1];
        2: current_state = execute_sequence[2];
        3: current_state = execute_sequence[3];
        default: current_state = ctl_state_t'('b111);
    endcase
end

//assign a sequence vector based on the current operation
always_comb begin
    case (ctl_op)
        CTL_LD_R8_D8: begin 
            execute_sequence = {LOAD_IMMEDIATE, IDLE, IDLE, IDLE};
            last_idx         = 0;
        end
        default: begin
            execute_sequence  = {IDLE, IDLE, IDLE, IDLE};
            last_idx = 3;
        end
    endcase
end

always_comb begin
    //output logic
    inc_pc = '0;
    fetch_cycle = '0;
    mem_to_r8 = '0;
    addr_sel = NONE;
    
    if (current_idx == last_idx) begin
        fetch_cycle = 1;
        inc_pc = 1;
        addr_sel = PC;

    end

    case (current_state)
        LOAD_IMMEDIATE: begin
            addr_sel = PC;
            inc_pc = 1;
            mem_to_r8 = 1;
        end
    endcase

end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        current_idx <= 0;
    end else begin
        if (current_idx == last_idx)
            current_idx <= 0;
        else
            current_idx <= current_idx + 1;
    end

end

endmodule