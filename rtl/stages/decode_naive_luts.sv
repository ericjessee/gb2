module decode import sm83_pkg::*;(
    input  data_t            instr,
    input  logic             is_instr16,
    output logic             is_instr16,
    output gp_r8_sel_t [0:1] opn_sel,
    output gp_r16_sel_t      gp16_sel,
    output alu_op_t          alu_op,
    output ctl_op_t          ctl_op
);
`include "decode_luts.vh"

always_comb begin
    gp8_sel = 3'hf;
    gp16_sel = 2'hf;
    alu_op = ALU_NOP;
    ctl_op = CTL_NOP;
    case (is_instr16)
        1: begin
        case (instr)
            OP_INSTR_16: is_instr16 = 1;; //16-bit instruction - need another byte (TBD)
            OP_NOP: ;
            //8-bit register to register loads
            OP_LD_B_B, OP_LD_C_B, OP_LD_D_B, OP_LD_E_B, 
            OP_LD_B_C, OP_LD_C_C, OP_LD_D_C, OP_LD_E_C,
            OP_LD_B_D, OP_LD_C_D, OP_LD_D_D, OP_LD_E_D,
            OP_LD_B_E, OP_LD_C_E, OP_LD_D_E, OP_LD_E_E,
            OP_LD_B_H, OP_LD_C_H, OP_LD_D_H, OP_LD_E_H,
            OP_LD_B_L, OP_LD_C_L, OP_LD_D_L, OP_LD_E_L,
            OP_LD_B_A, OP_LD_C_A, OP_LD_D_A, OP_LD_E_A,
            OP_LD_H_B, OP_LD_L_B, OP_LD_A_B,
            OP_LD_H_C, OP_LD_L_C, OP_LD_A_C,
            OP_LD_H_D, OP_LD_L_D, OP_LD_A_D,
            OP_LD_H_E, OP_LD_L_E, OP_LD_A_E,
            OP_LD_H_H, OP_LD_L_H, OP_LD_A_H,
            OP_LD_H_L, OP_LD_L_L, OP_LD_A_L,
            OP_LD_H_A, OP_LD_L_A, OP_LD_A_A:
                begin
                    op_sel = d_ld_r8_r8(instr);
                    ctl_op = CTL_LD_R8_R8;
                end
            //8-bit accumulator alu arithmetic
            OP_ADD_A_B, OP_ADC_A_B, OP_SUB_A_B, OP_SBC_A_B,
            OP_ADD_A_C, OP_ADC_A_C, OP_SUB_A_C, OP_SBC_A_C,
            OP_ADD_A_D, OP_ADC_A_D, OP_SUB_A_D, OP_SBC_A_D,
            OP_ADD_A_E, OP_ADC_A_E, OP_SUB_A_E, OP_SBC_A_E,
            OP_ADD_A_H, OP_ADC_A_H, OP_SUB_A_H, OP_SBC_A_H,
            OP_ADD_A_L, OP_ADC_A_L, OP_SUB_A_L, OP_SBC_A_L,
            OP_ADD_A_A, OP_ADC_A_A, OP_SUB_A_A, OP_SBC_A_A,
            OP_SBC_A_B, OP_AND_A_B, OP_XOR_A_B, OP_OR_A_B, 
            OP_SBC_A_C, OP_AND_A_C, OP_XOR_A_C, OP_OR_A_C, 
            OP_SBC_A_D, OP_AND_A_D, OP_XOR_A_D, OP_OR_A_D, 
            OP_SBC_A_E, OP_AND_A_E, OP_XOR_A_E, OP_OR_A_E, 
            OP_SBC_A_H, OP_AND_A_H, OP_XOR_A_H, OP_OR_A_H, 
            OP_SBC_A_L, OP_AND_A_L, OP_XOR_A_L, OP_OR_A_L, 
            OP_SBC_A_A, OP_AND_A_A, OP_XOR_A_A, OP_OR_A_A, 
            OP_CP_A_B,
            OP_CP_A_C,
            OP_CP_A_D,
            OP_CP_A_E,
            OP_CP_A_H,
            OP_CP_A_L,
            OP_CP_A_A:
                begin
                    op_sel = d_alu_a_r8(instr);
                    ctl_op = CTL_ALU_R8_R8;
                end
        endcase
        end
        2: begin
            //this will be the second byte in the 16-bit instr

        end
    endcase
end

endmodule