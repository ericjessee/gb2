module decode import sm83_pkg::*;(
    input  instr_t           instr,
    input  logic             i_is_instr16,
    output logic             o_is_instr16,
    output gp_r8_sel_t [0:1] r8_sel,
    output r16_sel_t         r16_sel,
    output gp_r8_sel_t       alu_rd_sel,
    output alu_op_t          alu_op,
    output ctl_op_t          ctl_op,
    output j_cond_t          jump_cond,
    output logic [2:0]       rst_tgt
);
`include "decode_luts.vh"

alu_op_t  bit_op_base;
opcode8_t full_opcode;

always_comb begin
    r8_sel = '1;
    alu_rd_sel = gp_r8_sel_t'(4'b1111);
    r16_sel = 2'b11;
    alu_op = ALU_NOP;
    ctl_op = CTL_NOP;
    o_is_instr16 = '0;
    rst_tgt = '0;
    bit_op_base = alu_op_t'(0);
    jump_cond = j_cond_t'(0);
    full_opcode = opcode8_t'(instr);
    case (i_is_instr16)
        0: begin
            //check exception cases first
            if (instr == OP_INSTR_16)
                o_is_instr16 = 1;
            else if (instr == OP_HALT)
                ctl_op = CTL_HALT;
            else if (instr == OP_STOP)
                ctl_op = CTL_STOP;
            else begin
                //decoding scheme closely based on https://gbdev.io/pandocs/CPU_Instruction_Set.html
                case (instr.block)
                    BLOCK_0: begin
                        if (instr.body.b0.op1.const111 == 3'b111) begin //is 1bit op
                            ctl_op = CTL_ALU_A;
                            case (instr.body.b0.op1.op) //maybe could be sneakier with these enums
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
                        else if (instr.body.b0.ldimm8.const110 == 3'b110) begin //is 8 bit immediate load
                            ctl_op = CTL_LD_R8_D8;
                            alu_op = ALU_LD1;
                            alu_rd_sel = instr.body.b0.ldimm8.rd;
                            r8_sel[0]  = REG_Z;
                        end
                        else if (instr.body.b0.inc8.const10 == 2'b10) begin //is 8-bit inc or dec
                            ctl_op = CTL_ALU_R8;
                            alu_op = (instr.body.b0.inc8.dec_ninc) ? ALU_DEC : ALU_INC;
                            r8_sel[0] = instr.body.b0.inc8.r8;
                            alu_rd_sel = instr.body.b0.inc8.r8;
                        end
                        else if (instr.body.b0.jp.const000 == 3'b000) begin //is unconditional jump to imm 8-bit offset
                            if (!instr.body.b0.jp.is_cond && (instr.body.raw[4:3] == 2'b11))
                                ctl_op = CTL_JR;
                            else if (instr.body.b0.jp.is_cond) begin
                                ctl_op    = CTL_JR_COND;
                                jump_cond = instr.body.b0.jp.cond;
                            end
                        end
                        else if (full_opcode == OP_LDPTR_A16_SP) begin //load SP value to immediate pointer
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
                        alu_rd_sel = instr.body.b1.rd;
                        r8_sel[0]  = instr.body.b1.rs;
                        alu_op = ALU_LD1;
                        if (r8_sel[0] == REG_Z) begin
                            ctl_op = CTL_LDPTR_R8_HL;
                            r16_sel = R16_HL;
                        end
                        else 
                            ctl_op = CTL_LD_R8_R8;
                    end
                    BLOCK_2: begin
                        ctl_op = CTL_ALU_A;
                        r8_sel[1] = instr.body.b2.r8;
                        alu_op = map_b2_b3_alu_op(instr.body.b2.alu_op);
                    end
                    BLOCK_3: begin
                        if (instr.body.b3.alu.const110 == 3'b110) begin //alu op with 8-bit immediate
                            ctl_op = CTL_ALU_A_D8;
                            alu_op = map_b2_b3_alu_op(instr.body.b3.alu.alu_op);
                        end
                        else if (instr.body.b3.stack_op.id == 4'b0001) begin //pop 16-bit word from stack
                            ctl_op = CTL_POP_STACK;
                            r16_sel.r16stk = instr.body.b3.stack_op.r16stk;
                        end
                        else if (instr.body.b3.stack_op.id == 4'b0101) begin //push 16-bit word to stack
                            ctl_op = CTL_PUSH_STACK;
                            r16_sel.r16stk = instr.body.b3.stack_op.r16stk;
                        end
                        else if (full_opcode == OP_RET)
                            ctl_op = CTL_RET;
                        else if (full_opcode == OP_RETI)
                            ctl_op = CTL_RETI;
                        else if (full_opcode == OP_JP_A16)
                            ctl_op = CTL_JP_A16;
                        else if (full_opcode == OP_JP_HL)
                            ctl_op = CTL_JP_HL;
                        else if (full_opcode == OP_CALL_A16)
                            ctl_op = CTL_CALL_A16;
                        else if (instr.body.b3.rst.const111 == 3'b111) begin
                            ctl_op = CTL_RST;
                            rst_tgt = instr.body.b3.rst.target;
                        end
                        else if (instr.body.b3.jp_cond.id2 == 3'b000) begin
                            ctl_op = CTL_RET_COND;
                            jump_cond = instr.body.b3.jp_cond.cond;
                        end
                        else if (instr.body.b3.jp_cond.id2 == 3'b010) begin
                            ctl_op = CTL_JP_COND;
                            jump_cond = instr.body.b3.jp_cond.cond;
                        end
                        else if (instr.body.b3.jp_cond.id2 == 3'b100) begin
                            ctl_op = CTL_CALL_COND_A16;
                            jump_cond = instr.body.b3.jp_cond.cond;
                        end
                        //this is dumb also, but all sort of edge cases.
                        else if (full_opcode == OP_LDPTR_C_A)
                            ctl_op = CTL_LDPTR_C_A;
                        else if (full_opcode == OP_LDPTR_A8_A)
                            ctl_op = CTL_LDPTR_A8_A;
                        else if (full_opcode == OP_LDPTR_A16_A)
                            ctl_op = CTL_LDPTR_A16_A;
                        else if (full_opcode == OP_LDPTR_A_C)
                            ctl_op = CTL_LDPTR_A_C;
                        else if (full_opcode == OP_LDPTR_A_A8)
                            ctl_op = CTL_LDPTR_A_A8;
                        else if (full_opcode == OP_LDPTR_A_A16)
                            ctl_op = CTL_LDPTR_A_A16;
                        else if (full_opcode == OP_ADD_SP_D8)
                            ctl_op = CTL_ADD_SP_D8;
                        else if (full_opcode == OP_LD_HL_SP_S8)
                            ctl_op = CTL_LD_HL_SP_D8;
                        else if (full_opcode == OP_LD_SP_HL)
                            ctl_op = CTL_LD_SP_HL;
                        else if (full_opcode == OP_DI)
                            ctl_op = CTL_DI;
                        else if (full_opcode == OP_EI)
                            ctl_op = CTL_EI;                                                        
                    end
                endcase
            end
        end
        1: begin
            //this will be the second byte in the 16-bit instr
            ctl_op = CTL_ALU_R8;
            r8_sel = instr.body.cb.alu.r8;
            if (instr.block == 2'b00) begin
                case (instr.body.cb.alu.alu_op)
                    RLC:  alu_op = ALU_RLC; 
                    RRC:  alu_op = ALU_RRC;
                    RL:   alu_op = ALU_RL;
                    RR:   alu_op = ALU_RR;
                    SLA:  alu_op = ALU_SLA;
                    SRA:  alu_op = ALU_SRA;
                    SWAP: alu_op = ALU_SWAP;
                    SRL:  alu_op = ALU_SRL;
                endcase
            end else begin
                case (instr.block)
                    2'b01: bit_op_base = ALU_BIT_0;
                    2'b10: bit_op_base = ALU_RES_0;
                    2'b11: bit_op_base = ALU_SET_0;
                endcase
                alu_op = alu_op_t'(bit_op_base + instr.body.cb.bitop.bit_idx);
            end
        end

    endcase
end

endmodule