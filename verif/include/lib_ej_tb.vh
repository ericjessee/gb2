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

always #`HALF_PERIOD clk = ~clk;