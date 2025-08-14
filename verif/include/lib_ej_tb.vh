`define PERIOD_NS   10000
`define HALF_PERIOD (`PERIOD_NS/2)

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

logic [2:0] halt_ctr;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        halt_ctr <= 0;
    end else begin
        if (halt) begin
            if (halt_ctr == 0)
                $display("halting in 3");
            if (halt_ctr < 3)
                halt_ctr <= halt_ctr + 1;
            else
                $finish;
        end
    end
end

always @(posedge clk) begin
    if (w_wen) begin
        if (addr_out == 16'hffb0)
            $write("%s",w_data_out);
    end
end

always #`HALF_PERIOD begin
    clk = ~clk;
end