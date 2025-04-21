module control import sm83_pkg::*;(
    input  logic      clk,
    input  logic      rst_n,
    input  ctl_op_t   ctl_op,
    input  alu_op_t   decoded_alu_op,
    output alu_op_t   alu_op,

    output addr_sel_t addr_sel,
    output logic      inc_pc,
    output logic      mem_to_z,
    output logic      mem_to_w,
    output logic      mem_to_ir,
    output logic      mem_to_r8,
    output logic      capture_alu_res,
    output logic      r8_to_alu_op1,
    output logic      update_flags,
    output logic      r8_to_mem,
    output logic      z_to_mem,

    output logic      halt
);
logic last;
logic to_halt;
ctl_op_t          curr_op;
ex_state_t        current_state;
ex_state_t [0:3]  execute_sequence;
logic [0:3]       current_idx;
logic [0:3]       last_idx;

//demux the current state from the sequence vector
always_comb begin
    case (current_idx)
        0: current_state = execute_sequence[0];
        1: current_state = execute_sequence[1];
        2: current_state = execute_sequence[2];
        3: current_state = execute_sequence[3];
        default: current_state = ex_state_t'('b111);
    endcase
end

//assign a sequence vector based on the current operation
always_comb begin
    last_idx = 0;
    case (ctl_op)
        CTL_LD_R8_D8: begin 
            execute_sequence = {EX_MEM_TO_Z, EX_ALU_LD1, EX_IDLE, EX_IDLE};
            last_idx = 1;
        end
        CTL_LD_R8_R8: begin
            execute_sequence = {EX_ALU_LD1, EX_IDLE, EX_IDLE, EX_IDLE};
        end
        CTL_ALU_R8: begin
            execute_sequence = {EX_ALU_R8, EX_IDLE, EX_IDLE, EX_IDLE};
        end
        CTL_LDPTR_A_R16, //can likely consolidate these
        CTL_LDPTR_R8_HL: begin
            execute_sequence = {EX_MEM_TO_Z, EX_ALU_LD1, EX_IDLE, EX_IDLE};
            last_idx = 1;
        end
        CTL_LDPTR_R16_A, //can likely consolidate these
        CTL_LDPTR_HL_R8: begin
            execute_sequence = {EX_R8_TO_MEM, EX_IDLE, EX_IDLE, EX_IDLE};
            last_idx = 1;
        end
        CTL_LDPTR_HL_D8: begin
            execute_sequence = {EX_MEM_TO_Z, EX_Z_TO_MEM, EX_IDLE, EX_IDLE};
            last_idx = 2;
        end
        CTL_LDPTR_A_A16: begin
            execute_sequence = {EX_MEM_TO_Z, EX_MEM_TO_W, EX_MEM_WZ_TO_Z, EX_ALU_LD1};
            last_idx = 3;
        end
        CTL_LDPTR_A16_A: begin
            execute_sequence = {EX_MEM_TO_Z, EX_MEM_TO_W, EX_A_TO_WZ_MEM, EX_IDLE};
            last_idx = 3;
        end
        CTL_LDPTRH_A_C: begin
            execute_sequence = {EX_MEM_TO_Z, EX_ALU_LD1, EX_IDLE, EX_IDLE};
            last_idx = 1;
        end
        CTL_LDPTRH_C_A: begin
            execute_sequence = {EX_A_TO_C_MEM, EX_IDLE, EX_IDLE, EX_IDLE};
            last_idx = 1;
        end
        CTL_HALT: begin //not sure about one cycle delay before halt
            execute_sequence = {EX_IDLE, EX_HALT, EX_IDLE, EX_IDLE};
            last_idx = 1;
        end
        default: begin
            execute_sequence  = {EX_IDLE, EX_IDLE, EX_IDLE, EX_IDLE};
        end
    endcase
end

always_comb begin
    //output logic
    alu_op = decoded_alu_op;
    inc_pc = '0;
    mem_to_z = '0;
    mem_to_w = '0;
    mem_to_ir = '0;
    mem_to_r8 = '0;
    capture_alu_res = '0;
    r8_to_alu_op1 = '0;
    update_flags = '0;
    r8_to_mem = '0;
    z_to_mem  = '0;
    to_halt = '0;

    addr_sel = PC;
    last = 0;
    //if it is the last execution cycle, fetch the next instruction.
    //special cases should override this.
    if (current_idx >= last_idx) begin 
        last = 1;
        mem_to_ir = 1;
        inc_pc = 1;
    end

    case (current_state)
        EX_ALU_R8: begin
            capture_alu_res = 1;
            r8_to_alu_op1   = 1;
            update_flags    = 1;
        end
        EX_ALU_LD1: begin
            r8_to_alu_op1   = 1;
            capture_alu_res = 1;
        end
        EX_MEM_TO_Z: begin
            mem_to_z = 1;
            case (ctl_op)
                //loading z indirect from 16-bit reg
                CTL_LDPTR_R8_HL,
                CTL_LDPTR_A_R16: addr_sel = GP16;
                //loading z from 8-bit immediate
                CTL_LDPTR_HL_D8,
                CTL_LD_R8_D8,
                CTL_LDPTR_A_A16: inc_pc   = 1;
                CTL_LDPTRH_A_C:  addr_sel = FF_C;
            endcase
        end
        EX_MEM_TO_W: begin
            mem_to_w = 1;
            inc_pc   = 1;
        end
        EX_MEM_WZ_TO_Z: begin //for when MEM_TO_Z alreay used to load WZ pointer
            mem_to_z = 1;
            addr_sel = WZ;
        end
        EX_Z_TO_MEM: begin
            z_to_mem = '1;
            addr_sel = GP16; //always true?
        end
        EX_R8_TO_MEM: begin
            r8_to_mem = '1;
            addr_sel  = GP16;
        end
        EX_A_TO_WZ_MEM: begin
            r8_to_mem = '1;
            addr_sel  = WZ;
        end
        EX_A_TO_C_MEM: begin
            r8_to_mem = '1;
            addr_sel  = FF_C;
        end
        EX_HALT: begin
            to_halt = 1;
        end
    endcase

end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        current_idx <= 0;
        halt <= 0;
    end else begin
        if (to_halt)
            halt <= 1;
        if (last)
            current_idx <= 0;
        else
            current_idx <= current_idx + 1;
    end

end

endmodule