// cpp testbench for verilated code
// based on ECE493 example code

#include <cstdio>
#include <cmath>

#include "verilated.h"
#include "verilated_vcd_c.h"
#include <Vsm83_top.h>

#define MAX_CYCLE_COUNT 2000

static vluint64_t time_stamp = 0;

double sc_time_stamp() {
    return static_cast<double>(time_stamp);
}

class SM83_Top_TB {
    public:
        int timeout_ctr;
        SM83_Top_TB()
            : sm83_top(new Vsm83_top)
        {
            timeout_ctr = 0;
            sm83_top->clk = 0;
            enableTrace();
        }

        void enableTrace() {
            vtrace = new VerilatedVcdC();
            sm83_top->trace(vtrace, 0);
            vtrace->open("verilated.vcd");
        }

        ~SM83_Top_TB() {
            //sm83_top->final(); //i think only needed if final statement is present?
            vtrace->flush();
            vtrace->close();
            delete sm83_top;
            delete vtrace;
        }

        void check_print(){
            if (sm83_top->w_wen) {
                if (sm83_top->w_addr == 0xffb0){
                    printf("%c", sm83_top->w_data);
                }
            }
        }

        void tick() {
            check_print();
            // Toggle clock edge once
            sm83_top->clk = !sm83_top->clk;
            sm83_top->eval();
            vtrace->dump(time_stamp);
        
            time_stamp++;

            // Repeat
            sm83_top->clk = !sm83_top->clk;
            sm83_top->eval();
            vtrace->dump(time_stamp);
            time_stamp++;
        }

        void wait_cycles(int num_cycles) {
            for (int i=0; i<num_cycles; i++){
                sm83_top->eval();
                tick();
            }
        }

        void initial() {
            sm83_top->rst_n = 0;
            wait_cycles(4);
            sm83_top->rst_n = 1;
            while ((!sm83_top->halt) && (timeout_ctr < MAX_CYCLE_COUNT)) {
                wait_cycles(1);
                timeout_ctr++;
            }
        }

    private: 
        Vsm83_top* sm83_top;
        VerilatedVcdC* vtrace;
};

int main(int argc, char* argv[]) {
    Verilated::traceEverOn(true);
    Verilated::commandArgs(argc, argv);

    SM83_Top_TB tb;

    tb.initial();
}
