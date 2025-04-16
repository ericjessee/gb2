module sm83_core import sm83_pkg::*;(
    input clk,
    input rst_n,
    input  data_t r_data,
    output data_t w_data,
    output addr_t r_addr,
    output addr_t w_addr,
    output logic  w_wen
);

//control signals
logic fetch_cycle;

logic inc_pc;
logic mem_to_r8;

addr_sel_t addr_sel;

//register file signals
reg_wen_vec_t reg_wen_vec;

r8_t r_ir;
r8_t new_ir;

r8_t r_a;
r8_t new_a;

r8_t r_gp8;
r8_t new_gp8;

r8_16_t r_gp16;
r8_16_t new_gp16;

addr_t pc;
addr_t new_pc;
addr_t sp;
addr_t new_sp;

//idu signals
logic idu_inc_ndec;
r16_t idu_in;
r16_t idu_out;

//decode signals

logic next_is_instr16;
logic is_instr16;

gp_r8_sel_t [0:1] decode_r8_sel;
r16_sel_t         decode_r16_sel;
alu_op_t          decode_alu_op;
ctl_op_t          decode_ctl_op;
j_cond_t          decode_jump_cond;
logic [2:0]       decode_rst_tgt;

//register file muxing
always_comb begin
    new_ir = r_ir;
    reg_wen_vec = '0;

    if (fetch_cycle) begin
        new_ir = r_data;
        reg_wen_vec.ir = 1;
    end

    if (inc_pc) begin
        new_pc = idu_out;
        reg_wen_vec.pc = 1;
    end

    new_a = r_a;
    new_gp8 = r_gp8;
    if (mem_to_r8)
        if (decode_r8_sel[0] == REG_A)
            {reg_wen_vec.a, new_a}     = {1'b1, r_data};
        else
            {reg_wen_vec.gp8, new_gp8} = {1'b1, r_data};

end

register_file rf(
    .clk(clk),
    .rst_n(rst_n),
    .wen(reg_wen_vec),
    .w_ir(new_ir),
    .w_ie(),
    .w_a(new_a),
    .w_f(),
    .w_sel8_gp(decode_r8_sel[0]),
    .w_sel16_gp(),
    .w8_gp(new_gp8),
    .w16_gp(new_gp16),
    .w_pc(new_pc),
    .w_sp(new_sp),
    .r_ir(r_ir),
    .r_ie(),
    .r_a(r_a),
    .r_f(),
    .r_sel8_gp(decode_r8_sel[1]),
    .r_sel16_gp(),
    .r8_gp(r_gp8),
    .r16_gp(r_gp16),
    .r_pc(pc),
    .r_sp(sp)
);

//idu input muxing
always_comb begin 
    idu_in = '0;
    idu_inc_ndec = '1;
    if (inc_pc) begin
        idu_inc_ndec = 1;
        idu_in       = pc;
    end
end

idu idu_0(
    .inc_ndec(idu_inc_ndec),
    .r16_in(idu_in),
    .r16_out(idu_out)
);

//address bus output demuxing
always_comb begin
    r_addr = 64; //chosen at random for debug
    case (addr_sel)
        PC:   r_addr = pc;
        SP:   r_addr = sp;
        GP16: r_addr = addr_t'(r_gp16);
    endcase
end

decode decode_0 (
    .instr(r_ir),
    .i_is_instr16('0),
    .o_is_instr16(next_is_instr16),
    .r8_sel(decode_r8_sel),
    .r16_sel(decode_r16_sel),
    .alu_op(decode_alu_op),
    .ctl_op(decode_ctl_op),
    .jump_cond(decode_jump_cond),
    .rst_tgt(decode_rst_tgt)
);

control ctl(
    .clk(clk),
    .rst_n(rst_n),
    .ctl_op(decode_ctl_op),
    .addr_sel(addr_sel),
    .inc_pc(inc_pc),
    .fetch_cycle(fetch_cycle),
    .mem_to_r8(mem_to_r8)
);

endmodule