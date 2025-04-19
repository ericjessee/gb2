module alu import sm83_pkg::*;(
    input  data_t   op1,
    input  data_t   op2,
    input  flags_t  in_flags,
    input  alu_op_t alu_op,
    output flags_t  out_flags,
    output data_t   result
);

function bit_mask(alu_op_t alu_op);
    begin
        case (alu_op)
            ALU_BIT_0, ALU_RES_0, ALU_SET_0: bit_mask = (1 << 0);
            ALU_BIT_1, ALU_RES_1, ALU_SET_1: bit_mask = (1 << 1); 
            ALU_BIT_2, ALU_RES_2, ALU_SET_2: bit_mask = (1 << 2);
            ALU_BIT_3, ALU_RES_3, ALU_SET_3: bit_mask = (1 << 3);
            ALU_BIT_4, ALU_RES_4, ALU_SET_4: bit_mask = (1 << 4);
            ALU_BIT_5, ALU_RES_5, ALU_SET_5: bit_mask = (1 << 5);
            ALU_BIT_6, ALU_RES_6, ALU_SET_6: bit_mask = (1 << 6);
            ALU_BIT_7, ALU_RES_7, ALU_SET_7: bit_mask = (1 << 7);
        endcase
    end
endfunction

logic [8:0] full_result;
logic overflow_from_bit_3;
logic borrow_from_bit_4;

always_comb begin

    full_result = '0;
    out_flags   = '0;
    
    //used for half carry flags
    overflow_from_bit_3 = full_result[4] & !full_result[3]; //??
    borrow_from_bit_4   = full_result[3] & !full_result[4]; //??

    case(alu_op)
        ALU_NOP: ;
        ALU_ADC: begin
            full_result = op1 + op2 + in_flags.c;
            out_flags.h = overflow_from_bit_3;
        end
        ALU_ADD: begin
            full_result = op1 + op2;
            out_flags.h = overflow_from_bit_3;
        end
        ALU_AND: begin
            full_result = op1 & op2;
            out_flags.h = 1;
        end
        ALU_CP: begin 
            full_result = op1 - op2;
            out_flags.n = 1;
            out_flags.h = borrow_from_bit_4;
        end
        ALU_DEC: begin 
            full_result = op1 - 1;
            out_flags.n = 1;
            out_flags.h = borrow_from_bit_4;
        end
        ALU_INC: begin
            full_result = op1 + 1;
            out_flags.h = overflow_from_bit_3;
        end
        ALU_OR: begin
            full_result = op1 | op2;
        end
        ALU_SBC: begin
            full_result = op1 - op2 - in_flags.c;
            out_flags.n = 1;
            out_flags.h = borrow_from_bit_4;
        end
        ALU_SUB: begin
            full_result = op1 - op2;
            out_flags.n = 1;
            out_flags.h = borrow_from_bit_4;
        end
        ALU_XOR: begin
            full_result = op1 ^ op2;
        end
        ALU_BIT_0, ALU_BIT_1, ALU_BIT_2, ALU_BIT_3,
        ALU_BIT_4, ALU_BIT_5, ALU_BIT_6, ALU_BIT_7: begin
            full_result = ((op1 & bit_mask(alu_op)) != 0);
            out_flags.h = 1;
        end
        ALU_RES_0, ALU_RES_1, ALU_RES_2, ALU_RES_3,
        ALU_RES_4, ALU_RES_5, ALU_RES_6, ALU_RES_7: begin
            full_result = op1 & ~bit_mask(alu_op);
        end
        ALU_SET_0, ALU_SET_1, ALU_SET_2, ALU_SET_3,
        ALU_SET_4, ALU_SET_5, ALU_SET_6, ALU_SET_7: begin
            full_result = op1 | bit_mask(alu_op);
        end
        ALU_SWAP: begin
            full_result = {op1[3:0], op1[7:4]};
        end
        ALU_RL: begin
            full_result = {op1, in_flags.c} << 1;
        end
        ALU_RLC: begin
            full_result = {op1, op1[7]} << 1;
        end
        ALU_RR: begin
            {full_result[7:0], full_result[8]} = {in_flags.c, op1} >> 1;
        end
        ALU_RRC: begin
            {full_result[7:0], full_result[8]} = {op1[0], op1} >> 1; 
        end
        ALU_SLA: begin
            full_result = op1 << 1;
        end
        ALU_SRA: begin
            {full_result[7:0], full_result[8]} = {op1[7], op1} >> 1;
        end
        ALU_SRL: begin
            {full_result[7:0], full_result[8]} = {1'b0, op1} >> 1;
        end
        ALU_SCF: begin
            full_result[8] = 1;
        end
        ALU_CCF: begin
            full_result[8] = !in_flags.c;
        end
        ALU_CPL: begin
            full_result = {1'b0, ~op1};
        end
        ALU_DAA: begin //what the is this for?
            if ((op1[3:0] > 4'd9) || in_flags.h)
                full_result = (!in_flags.n) ? (op1 + 8'h6)  : (op1 - 8'h6);
            else if (op1[7:4] > 4'd9 || in_flags.c)
                full_result = (!in_flags.n) ? (op1 + 8'h60) : (op1 - 8'h60);
        end 
    endcase


    result = full_result[7:0];

    out_flags.z = (result == 0);
    out_flags.c = full_result[8];

end



endmodule