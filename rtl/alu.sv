module alu import sm83_pkg::*;(
    input  r8_t      op1,
    input  r8_t      op2,
    input  flags_t   in_flags,
    input  alu_op_t  alu_op,
    output flags_t   out_flags,
    output alu_res_t result
);

always_comb begin
    out_flags = in_flags;

    case(alu_op)
        OP_NOP: ;
        OP_ADC: result = op1 + op2 + in_flags.c; //add with carry
        OP_ADD:
        OP_AND:
        OP_CP:
        OP_DEC:
        OP_INC:
        OP_OR:
        OP_SBC:
        OP_SUB:
        OP_XOR:
        OP_BIT:
        OP_RES:
        OP_SET:
        OP_SWAP:
        OP_RL:
        OP_RLA:
        OP_RLC:
        OP_RR:
        OP_RRA:
        OP_RRC:
        OP_RRCA:
        OP_SLA:
        OP_SRA:
        OP_SRL:
        OP_CCF:
        OP_CPL:
        OP_DAA: 
    endcase

end



endmodule