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
logic execute_last;
logic execute_cycle;

logic mem_to_a;

//register file signals
reg_wen_vec_t reg_wen_vec;

r8_t r_a;
r8_t new_a;

r16_t pc;
r16_t new_pc;
r16_t sp;
r16_t new_sp;

//idu signals
logic idu_inc_ndec;
r16_t idu_in;
r16_t idu_out;

//register file muxing
always_comb begin
    reg_wen_vec = '0;
    new_a = r_a;
    new_pc = pc;
    if (fetch_cycle || execute_last) begin
        new_pc = idu_out;
        reg_wen_vec.pc = '1;
    end

    if (mem_to_a)
        reg_wen_vec.a = '1;
        new_a = r_data;

end

register_file rf(
    .clk(clk),
    .rst_n(rst_n),
    .wen(reg_wen_vec),
    .w_ir(),
    .w_ie(),
    .w_a(new_a),
    .w_f(),
    .w_sel8_gp(),
    .w_sel16_gp(),
    .w8_gp(),
    .w16_gp(),
    .w_pc(new_pc),
    .w_sp(new_sp),
    .r_ir(),
    .r_ie(),
    .r_a(r_a),
    .r_f(),
    .r_sel8_gp(),
    .r_sel16_gp(),
    .r8_gp(),
    .r16_gp(),
    .r_pc(pc),
    .r_sp(sp)
);

//idu input muxing
always_comb begin 
    idu_in = '0;
    idu_inc_ndec = '1;
    if (fetch_cycle || execute_last) begin
        idu_inc_ndec = 1;
        idu_in       = pc;
    end
end

idu idu_0(
    .inc_ndec(idu_inc_ndec),
    .r16_in(idu_in),
    .r16_out(idu_out)
);

//address bus output decoding
always_comb begin
    r_addr = 64;
    if (fetch_cycle || execute_last) begin
        r_addr = pc;
    end
end

logic next_is_instr16;
logic is_instr16;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        is_instr16 <= '0;
    else
        if (fetch_cycle)
            is_instr16 <= next_is_instr16;
        else 
            is_instr16 <= '0;
end

//should move this inside the control
//take a step back and rethink this organization
data_t            decode_instr;
gp_r8_sel_t [0:1] decode_r8_sel;
r16_sel_t         decode_r16_sel;
alu_op_t          decode_alu_op;
ctl_op_t          decode_ctl_op;
j_cond_t          decode_jump_cond;
logic [2:0]       decode_rst_tgt;

always_comb begin
    decode_instr = OP_NOP; //DEBUG force a noop when not active
    if (fetch_cycle)
        decode_instr = r_data;
end

decode decode_0 (
    .instr(decode_instr),
    .i_is_instr16(is_instr16),
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
    .a_wen(mem_to_a),
    .fetch_cycle(fetch_cycle),
    .execute_cycle(execute_cycle),
    .execute_last(execute_last)
);

endmodule