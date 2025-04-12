module register_file import sm83_pkg::*;(
    input  logic         clk,
    input  logic         rst_n,

    input  reg_wen_vec_t wen,

    input  r8_t          w_ir,
    input  r8_t          w_ie,

    input  r8_t          w_a,  
    input  r8_t          w_f,

    input  gp_r8_sel_t   w_sel8_gp,
    input  gp_r16_sel_t  w_sel16_gp,
    input  r8_t          w8_gp,
    input  r16_t         w16_gp,

    input  r16_t         w_pc,
    input  r16_t         w_sp,

    output r8_t          r_ir,
    output r8_t          r_ie,

    output r8_t          r_a,
    output r8_t          r_f,
    
    input  gp_r8_sel_t   r_sel8_gp,
    input  gp_r16_sel_t  r_sel16_gp,
    output r8_t          r8_gp,
    output r16_t         r16_gp,

    output r16_t         r_pc,
    output r16_t         r_sp
);

reg_vec_t reg_vec; //eventually replace with bram

always_comb begin
    //output muxing for 8-bit gp regs
    case (r_sel8_gp)
        REG_B:   r8_gp = reg_vec.b_c.r8[0];
        REG_C:   r8_gp = reg_vec.b_c.r8[1];
        REG_D:   r8_gp = reg_vec.d_e.r8[0];
        REG_E:   r8_gp = reg_vec.d_e.r8[1];
        REG_H:   r8_gp = reg_vec.h_l.r8[0];
        REG_L:   r8_gp = reg_vec.h_l.r8[1];
        default: r8_gp = 0;
    endcase

    //output muxing for 16-bit gp regs
    case (r_sel16_gp)
        REG_BC:  r16_gp = reg_vec.b_c.r16;
        REG_DE:  r16_gp = reg_vec.d_e.r16;
        REG_HL:  r16_gp = reg_vec.h_l.r16;
        default: r16_gp = 0;
    endcase

    //non-gp registers have bespoke read ports
    r_ir = reg_vec.ir;
    r_ie = reg_vec.ie;
    r_a  = reg_vec.a;
    r_f  = reg_vec.f;
    r_pc = reg_vec.pc;
    r_sp = reg_vec.sp;
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        reg_vec <= '0;
    end else begin
        if (wen.ir) reg_vec.ir <= w_ir;
        if (wen.ie) reg_vec.ie <= w_ie;
        if (wen.a)  reg_vec.a  <= w_a;
        if (wen.f)  reg_vec.f  <= w_f;
        if (wen.gp8) begin
            case (w_sel8_gp)
                REG_B: reg_vec.b_c.r8[0] <= w8_gp;
                REG_C: reg_vec.b_c.r8[1] <= w8_gp;
                REG_D: reg_vec.d_e.r8[0] <= w8_gp;
                REG_E: reg_vec.d_e.r8[1] <= w8_gp;
                REG_H: reg_vec.h_l.r8[0] <= w8_gp;
                REG_L: reg_vec.h_l.r8[1] <= w8_gp;
                default: ;
            endcase
        end
        else if (wen.gp16) begin
            case (w_sel16_gp)
                REG_BC: reg_vec.b_c.r16 <= w16_gp;
                REG_DE: reg_vec.d_e.r16 <= w16_gp;
                REG_HL: reg_vec.h_l.r16 <= w16_gp;
                default: ;
            endcase
        end
        if (wen.pc) reg_vec.pc <= w_pc;
        if (wen.sp) reg_vec.sp <= w_sp;
    end
end

endmodule