function alu_op_t map_b2_b3_alu_op(
    input b2_3_alu_op_t alu_op
);
begin
    case (alu_op)
        ADD: map_b2_b3_alu_op = ALU_ADD;
        ADC: map_b2_b3_alu_op = ALU_ADC;
        SUB: map_b2_b3_alu_op = ALU_SUB;
        SBC: map_b2_b3_alu_op = ALU_SBC;
        AND: map_b2_b3_alu_op = ALU_AND;
        XOR: map_b2_b3_alu_op = ALU_XOR;
        OR:  map_b2_b3_alu_op = ALU_OR;
        CP:  map_b2_b3_alu_op = ALU_CP;
    endcase
end
endfunction

function gp8_sel_t[0:1] d_ld_r8_r8(
    input data_t instr
);
begin
    case (instr)
        OP_LD_B_B: d_ld_r8_r8 = {REG_B, REG_B};
        OP_LD_B_C: d_ld_r8_r8 = {REG_B, REG_C};
        OP_LD_B_D: d_ld_r8_r8 = {REG_B, REG_D};
        OP_LD_B_E: d_ld_r8_r8 = {REG_B, REG_E};
        OP_LD_B_H: d_ld_r8_r8 = {REG_B, REG_H};
        OP_LD_B_L: d_ld_r8_r8 = {REG_B, REG_L};
        OP_LD_B_A: d_ld_r8_r8 = {REG_B, REG_A};
        OP_LD_C_B: d_ld_r8_r8 = {REG_C, REG_B};
        OP_LD_C_C: d_ld_r8_r8 = {REG_C, REG_C};
        OP_LD_C_D: d_ld_r8_r8 = {REG_C, REG_D};
        OP_LD_C_E: d_ld_r8_r8 = {REG_C, REG_E};
        OP_LD_C_H: d_ld_r8_r8 = {REG_C, REG_H};
        OP_LD_C_L: d_ld_r8_r8 = {REG_C, REG_L};
        OP_LD_C_A: d_ld_r8_r8 = {REG_C, REG_A};
        OP_LD_D_B: d_ld_r8_r8 = {REG_D, REG_B};
        OP_LD_D_C: d_ld_r8_r8 = {REG_D, REG_C};
        OP_LD_D_D: d_ld_r8_r8 = {REG_D, REG_D};
        OP_LD_D_E: d_ld_r8_r8 = {REG_D, REG_E};
        OP_LD_D_H: d_ld_r8_r8 = {REG_D, REG_H};
        OP_LD_D_L: d_ld_r8_r8 = {REG_D, REG_L};
        OP_LD_D_A: d_ld_r8_r8 = {REG_D, REG_A};
        OP_LD_E_B: d_ld_r8_r8 = {REG_E, REG_B};
        OP_LD_E_C: d_ld_r8_r8 = {REG_E, REG_C};
        OP_LD_E_D: d_ld_r8_r8 = {REG_E, REG_D};
        OP_LD_E_E: d_ld_r8_r8 = {REG_E, REG_E};
        OP_LD_E_H: d_ld_r8_r8 = {REG_E, REG_H};
        OP_LD_E_L: d_ld_r8_r8 = {REG_E, REG_L};
        OP_LD_E_A: d_ld_r8_r8 = {REG_E, REG_A};
        OP_LD_H_B: d_ld_r8_r8 = {REG_H, REG_B};
        OP_LD_H_C: d_ld_r8_r8 = {REG_H, REG_C};
        OP_LD_H_D: d_ld_r8_r8 = {REG_H, REG_D};
        OP_LD_H_E: d_ld_r8_r8 = {REG_H, REG_E};
        OP_LD_H_H: d_ld_r8_r8 = {REG_H, REG_H};
        OP_LD_H_L: d_ld_r8_r8 = {REG_H, REG_L};
        OP_LD_H_A: d_ld_r8_r8 = {REG_H, REG_A};
        OP_LD_L_B: d_ld_r8_r8 = {REG_L, REG_B};
        OP_LD_L_C: d_ld_r8_r8 = {REG_L, REG_C};
        OP_LD_L_D: d_ld_r8_r8 = {REG_L, REG_D};
        OP_LD_L_E: d_ld_r8_r8 = {REG_L, REG_E};
        OP_LD_L_H: d_ld_r8_r8 = {REG_L, REG_H};
        OP_LD_L_L: d_ld_r8_r8 = {REG_L, REG_L};
        OP_LD_L_A: d_ld_r8_r8 = {REG_L, REG_A};
        OP_LD_A_B: d_ld_r8_r8 = {REG_A, REG_B};
        OP_LD_A_C: d_ld_r8_r8 = {REG_A, REG_C};
        OP_LD_A_D: d_ld_r8_r8 = {REG_A, REG_D};
        OP_LD_A_E: d_ld_r8_r8 = {REG_A, REG_E};
        OP_LD_A_H: d_ld_r8_r8 = {REG_A, REG_H};
        OP_LD_A_L: d_ld_r8_r8 = {REG_A, REG_L};
        OP_LD_A_A: d_ld_r8_r8 = {REG_A, REG_A};
    endcase
end
endfunction

function gp8_sel_t[0:1] d_alu_a_r8(
    input data_t instr
);
begin
    d_alu_r8_r8[0] = REG_A;
    case (instr)
            OP_ADD_A_B: d_alu_r8_r8[1] = REG_B; 
            OP_ADD_A_C: d_alu_r8_r8[1] = REG_C; 
            OP_ADD_A_D: d_alu_r8_r8[1] = REG_D; 
            OP_ADD_A_E: d_alu_r8_r8[1] = REG_E; 
            OP_ADD_A_H: d_alu_r8_r8[1] = REG_H; 
            OP_ADD_A_L: d_alu_r8_r8[1] = REG_L; 
            OP_ADD_A_A: d_alu_r8_r8[1] = REG_A;
            OP_ADC_A_B: d_alu_r8_r8[1] = REG_B; 
            OP_ADC_A_C: d_alu_r8_r8[1] = REG_C; 
            OP_ADC_A_D: d_alu_r8_r8[1] = REG_D; 
            OP_ADC_A_E: d_alu_r8_r8[1] = REG_E; 
            OP_ADC_A_H: d_alu_r8_r8[1] = REG_H; 
            OP_ADC_A_L: d_alu_r8_r8[1] = REG_L; 
            OP_ADC_A_A: d_alu_r8_r8[1] = REG_A; 
            OP_SUB_A_B: d_alu_r8_r8[1] = REG_B; 
            OP_SUB_A_C: d_alu_r8_r8[1] = REG_C; 
            OP_SUB_A_D: d_alu_r8_r8[1] = REG_D; 
            OP_SUB_A_E: d_alu_r8_r8[1] = REG_E; 
            OP_SUB_A_H: d_alu_r8_r8[1] = REG_H; 
            OP_SUB_A_L: d_alu_r8_r8[1] = REG_L;
            OP_SUB_A_A: d_alu_r8_r8[1] = REG_A;
            OP_SBC_A_B: d_alu_r8_r8[1] = REG_B;
            OP_SBC_A_C: d_alu_r8_r8[1] = REG_C;
            OP_SBC_A_D: d_alu_r8_r8[1] = REG_D;
            OP_SBC_A_E: d_alu_r8_r8[1] = REG_E;
            OP_SBC_A_H: d_alu_r8_r8[1] = REG_H;
            OP_SBC_A_L: d_alu_r8_r8[1] = REG_L;             
            OP_SBC_A_A: d_alu_r8_r8[1] = REG_A;
            OP_SBC_A_B: d_alu_r8_r8[1] = REG_B;  
            OP_SBC_A_C: d_alu_r8_r8[1] = REG_C;  
            OP_SBC_A_D: d_alu_r8_r8[1] = REG_D;  
            OP_SBC_A_E: d_alu_r8_r8[1] = REG_E;  
            OP_SBC_A_H: d_alu_r8_r8[1] = REG_H;  
            OP_SBC_A_L: d_alu_r8_r8[1] = REG_L;  
            OP_SBC_A_A: d_alu_r8_r8[1] = REG_A;
            OP_AND_A_B: d_alu_r8_r8[1] = REG_B; 
            OP_AND_A_C: d_alu_r8_r8[1] = REG_C; 
            OP_AND_A_D: d_alu_r8_r8[1] = REG_D; 
            OP_AND_A_E: d_alu_r8_r8[1] = REG_E; 
            OP_AND_A_H: d_alu_r8_r8[1] = REG_H; 
            OP_AND_A_L: d_alu_r8_r8[1] = REG_L; 
            OP_AND_A_A: d_alu_r8_r8[1] = REG_A; 
            OP_XOR_A_B: d_alu_r8_r8[1] = REG_B;
            OP_XOR_A_C: d_alu_r8_r8[1] = REG_C;
            OP_XOR_A_D: d_alu_r8_r8[1] = REG_D;
            OP_XOR_A_E: d_alu_r8_r8[1] = REG_E;
            OP_XOR_A_H: d_alu_r8_r8[1] = REG_H;
            OP_XOR_A_L: d_alu_r8_r8[1] = REG_L;
            OP_XOR_A_A: d_alu_r8_r8[1] = REG_A;
            OP_OR_A_B:  d_alu_r8_r8[1] = REG_B;
            OP_OR_A_C:  d_alu_r8_r8[1] = REG_C;
            OP_OR_A_D:  d_alu_r8_r8[1] = REG_D;
            OP_OR_A_E:  d_alu_r8_r8[1] = REG_E;
            OP_OR_A_H:  d_alu_r8_r8[1] = REG_H;
            OP_OR_A_L:  d_alu_r8_r8[1] = REG_L;
            OP_OR_A_A:  d_alu_r8_r8[1] = REG_A;  
            OP_CP_A_B:  d_alu_r8_r8[1] = REG_B;
            OP_CP_A_C:  d_alu_r8_r8[1] = REG_C;
            OP_CP_A_D:  d_alu_r8_r8[1] = REG_D;
            OP_CP_A_E:  d_alu_r8_r8[1] = REG_E;
            OP_CP_A_H:  d_alu_r8_r8[1] = REG_H;
            OP_CP_A_L:  d_alu_r8_r8[1] = REG_L;
            OP_CP_A_A:  d_alu_r8_r8[1] = REG_A;
    endcase
end
endfunction
