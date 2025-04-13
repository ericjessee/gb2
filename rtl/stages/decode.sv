module decode import sm83_pkg::*;(
    input  instr_t           instr,
    input  logic             i_is_instr16,
    output logic             o_is_instr16,
    output gp_r8_sel_t [0:1] r8_sel,
    output r16_sel_t         r16_sel,
    output alu_op_t          alu_op,
    output ctl_op_t          ctl_op,
    output j_cond_t          jump_cond
);
`include "decode_luts.vh"

always_comb begin
    r8_sel = 3'hf;
    r16_sel = 2'hf;
    alu_op = ALU_NOP;
    ctl_op = CTL_NOP;
    o_is_instr16 = 0;
    case (is_instr16)
        0: begin
            //check exception cases first
            if (instr == OP_INSTR_16)
                o_is_instr16 = 1;
            else if (instr == OP_HALT)
                ctl_op = CTL_HALT;
            else if (instr == OP_STOP)
                ctl_op = CTL_STOP;
            else begin
                //decoding scheme based on https://gbdev.io/pandocs/CPU_Instruction_Set.html
                case (instr.block)
                    BLOCK_0: begin
                        if (instr.body.raw[2:0] == 3'b111) begin //is 1bit op
                            ctl_op = ALU_OP;
                            r8_sel[0] = REG_A;
                            case (instr.body.b0.op1.op)
                                B0_RLCA: alu_op = ALU_RLC;
                                B0_RRCA: alu_op = ALU_RRCA;
                                B0_RLA:  alu_op = ALU_RL;
                                B0_RRA:  alu_op = ALU_RRA;
                                B0_DAA:  alu_op = ALU_DAA;
                                B0_CPL:  alu_op = ALU_CPL;
                                B0_SCF:  alu_op = ALU_SCF;
                                B0_CCF:  alu_op = ALU_CCF;
                            endcase
                        end
                        else if (instr.body.raw[2:0] == 3'b110) begin //is 8 bit immediate load
                            ctl_op = CTL_LD_R8_D8;
                            r8_sel[0] = instr.body.b0.ldimm8.rd;
                        end
                        else if (instr.body.raw[2:1] == 2'b10) begin //is 8-bit inc or dec
                            ctl_op = ALU_OP;
                            alu_op = (instr.body.b0.inc8.dec_ninc) ? ALU_DEC : ALU_INC;
                            r8_sel[0] = instr.body.b0.inc8.r8;
                        end
                        else if (instr.body.raw == 6'b011000) begin //is unconditional jump to imm 8-bit offset
                            ctl_op = CTL_JR;
                        end
                        else if ((instr.body.raw[5] == 1'b1) && (instr.body.raw[2:0] == 3'b000)) begin //conditional relative jump
                            ctl_op    = CTL_JR_COND;
                            jump_cond = instr.body.b0.jp.cond;
                        end
                        else if (instr.body.raw == 6'b00001000) begin //load 16-bit immediate to stack pointer
                            ctl_op = CTL_LDPTR_D16_SP;
                        end
                        else begin //is other 16-bit operation
                            r16_sel = instr.body.b0.op16.r16;
                            case (instr.body.b0.op16.op)
                                B0_LD_R16_D16:   ctl_op = CTL_LD_R16_D16;
                                B0_LDPTR_R16_A:  ctl_op = CTL_LDPTR_R16_A;
                                B0_LDPTR_A_R16:  ctl_op = CTL_LDPTR_A_R16;
                                B0_INC_R16:      ctl_op = CTL_INC16;
                                B0_DEC_R16:      ctl_op = CTL_DEC16;
                                B0_ADD_HL_R16:   ctl_op = CTL_ALU_HL_R16;
                            endcase
                        end
                    end
                    BLOCK_1: begin
                        //only type for block 1 is ld r8 <- r8
                        ctl_op = CTL_LD_R8_R8;
                        r8_sel[0] = instr.body.ld_r8_r8.rd;
                        r8_sel[1] = instr.body.ld_r8_r8.rs;
                    end

                    
                endcase
            end
        end
        1: begin
            //this will be the second byte in the 16-bit instr

        end

    endcase
end

endmodule