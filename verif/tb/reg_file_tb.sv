`define PERIOD_NS   10000
`define HALF_PERIOD (`PERIOD_NS/2)

module reg_file_tb import sm83_pkg::*;;
logic clk;
logic rst_n;

reg_wen_vec_t wen;
r8_t          w_ir;
r8_t          w_ie;
r8_t          w_a;  
r8_t          w_f;
gp_r8_sel_t   w_sel8_gp;
gp_r16_sel_t  w_sel16_gp;
r8_t          w8_gp;
r16_t         w16_gp;
r16_t         w_pc;
r16_t         w_sp;
r8_t          r_ir;
r8_t          r_ie;
r8_t          r_a;
r8_t          r_f;
gp_r8_sel_t  r_sel8_gp;
gp_r16_sel_t  r_sel16_gp;
r8_t          r8_gp;
r16_t         r16_gp;
r16_t         r_pc;
r16_t         r_sp;

register_file dut(.*);

task wait_cycles(int cycles);
    begin
        for (int i=0; i<cycles; i++)
            #`PERIOD_NS;
    end
endtask

task startup();
    begin
        clk = 0;
        rst_n = 0;
        wait_cycles(4);
        rst_n = 1;
    end
endtask

always @(posedge clk)
    $display("clock cycle");

always #`HALF_PERIOD clk = ~clk;

initial begin
    startup();
    wait_cycles(100);
    $finish;
end

endmodule