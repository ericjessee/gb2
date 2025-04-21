module sm83_core import sm83_pkg::*;(
    input clk,
    input rst_n,
    input  data_t r_data,
    output data_t w_data,
    output addr_t r_addr,
    output addr_t w_addr,
    output logic  w_wen,
    output logic halt
);

//control signals
alu_op_t ctl_alu_op;
logic inc_pc;
logic mem_to_z;
logic mem_to_w;
logic mem_to_ir;
logic mem_to_r8;
logic capture_alu_res;
logic r8_to_alu_op1;
logic update_flags;
logic r8_to_mem;
logic z_to_mem;

//WZ register
r16_t r_wz;

addr_sel_t addr_sel;

//register file signals
reg_wen_vec_t reg_wen_vec;

r8_t r_ir;
r8_t new_ir;

r8_t r_a;
r8_t new_a;

r8_t r_f;
r8_t new_f;

r8_t r_gp8;
r8_t new_gp8;

gp_r8_sel_t r_sel8_gp;
r8_16_t r_gp16;
r8_16_t new_gp16;

addr_t pc;
addr_t new_pc;
addr_t sp;
addr_t new_sp;

//alu signals
data_t alu_op1;
data_t alu_op2;
data_t alu_res;

//idu signals
logic idu_inc_ndec;
r16_t idu_in;
r16_t idu_out;

//decode signals
logic next_is_instr16;
logic is_instr16;

gp_r8_sel_t [0:1] decode_r8_sel;
r16_sel_t         decode_r16_sel;
gp_r8_sel_t       decode_alu_rd_sel;
alu_op_t          decode_alu_op;
ctl_op_t          decode_ctl_op;
j_cond_t          decode_jump_cond;
logic [2:0]       decode_rst_tgt;

//flopping for reg wz
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        r_wz = 0;
    else
        if (mem_to_z)
            r_wz.lsb = r_data;
        else if (mem_to_w)
            r_wz.msb = r_data;
end


//register file muxing
always_comb begin
    new_ir = r_data; //ir only takes instructions from memory
    reg_wen_vec = '0;

    new_a = alu_res;
    new_gp8 = alu_res;

    //gp8 selection comes straight from decode. just need wen
    if (capture_alu_res) begin
        case (decode_alu_rd_sel) 
            REG_A: reg_wen_vec.a = 1;
            REG_Z: ;
            default: reg_wen_vec.gp8 = 1;
        endcase
    end

    //only control gets to decide when to update flags
    reg_wen_vec.f = update_flags;

    if (mem_to_ir) begin
        reg_wen_vec.ir = 1;
    end

    if (inc_pc) begin
        new_pc         = idu_out;
        reg_wen_vec.pc = 1;
    end
    else if (wz_to_pc) begin
        new_pc         = r_wz;
        reg_wen_vec.pc = 1;
    end

end

register_file rf(
    .clk(clk),
    .rst_n(rst_n),
    .wen(reg_wen_vec),
    .w_ir(new_ir),
    .w_ie(),
    .w_a(new_a),
    .w_f(new_f),
    .w_sel8_gp(decode_alu_rd_sel),
    .w_sel16_gp(),
    .w8_gp(new_gp8),
    .w16_gp(new_gp16),
    .w_pc(new_pc),
    .w_sp(new_sp),
    .r_ir(r_ir),
    .r_ie(),
    .r_a(r_a),
    .r_f(r_f),
    .r_sel8_gp(decode_r8_sel[0]),
    .r_sel16_gp(decode_r16_sel.r16),
    .r8_gp(r_gp8),
    .r16_gp(r_gp16),
    .r_pc(pc),
    .r_sp(sp)
);

//alu input mixing
always_comb begin
    alu_op1 = 0;
    alu_op2 = 0;
    if (r8_to_alu_op1) begin
        if (decode_r8_sel[0] == REG_A)
            alu_op1 = r_a;
        else if (decode_r8_sel[0] == REG_Z)
            alu_op1 = r_wz.lsb;
        else
            alu_op1 = r_gp8;
    end
    if (decode_r8_sel[1] == REG_Z)
        alu_op2 = r_wz.lsb;
end

alu alu_0(
    .op1(alu_op1),
    .op2(alu_op2),
    .in_flags(r_f),
    .alu_op(ctl_alu_op),
    .out_flags(new_f),
    .result(alu_res)
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
    case (addr_sel) //w_addr may not be needed for some of these
        PC:   {r_addr, w_addr} = {pc, pc};
        SP:   {r_addr, w_addr} = {sp, sp};
        GP16: {r_addr, w_addr} = {addr_t'(r_gp16), addr_t'(r_gp16)};
        WZ:   {r_addr, w_addr} = {addr_t'(r_wz), addr_t'(r_wz)};
        FF_C: {r_addr, w_addr} = {addr_t'({8'hff, r_gp8}), addr_t'({8'hff, r_gp8})};
    endcase
end

//data bus output and write enable
always_comb begin
    w_wen = '0;
    if (r8_to_mem) begin
        w_wen = '1;
        if (decode_r8_sel[0] == REG_A)
            w_data = r_a;
        else
            w_data = r_gp8;
    end
    else if (z_to_mem) begin
        w_wen = '1;
        w_data = r_wz.lsb;
    end
end

decode decode_0 (
    .instr(r_ir),
    .i_is_instr16('0),
    .o_is_instr16(next_is_instr16),
    .r8_sel(decode_r8_sel),
    .r16_sel(decode_r16_sel),
    .alu_rd_sel(decode_alu_rd_sel),
    .alu_op(decode_alu_op),
    .ctl_op(decode_ctl_op),
    .jump_cond(decode_jump_cond),
    .rst_tgt(decode_rst_tgt)
);

control ctl(
    .clk(clk),
    .rst_n(rst_n),
    .ctl_op(decode_ctl_op),
    .decoded_alu_op(decode_alu_op),
    .alu_op(ctl_alu_op),
    .addr_sel(addr_sel),
    .inc_pc(inc_pc),
    .wz_to_pc(wz_to_pc),
    .mem_to_z(mem_to_z),
    .mem_to_w(mem_to_w),
    .mem_to_ir(mem_to_ir),
    .mem_to_r8(mem_to_r8),
    .capture_alu_res(capture_alu_res),
    .r8_to_alu_op1(r8_to_alu_op1),
    .update_flags(update_flags),
    .r8_to_mem(r8_to_mem),
    .z_to_mem(z_to_mem),
    
    .halt(halt)
);

endmodule