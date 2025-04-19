second attempt at a verilog model of an sm83 cpu, with lessons learned from various projecsts in the meantime.

references:\
https://gekkio.fi/files/gb-docs/gbctr.pdf \
https://meganesu.github.io/generate-gb-opcodes/ \
https://gbdev.io/pandocs/CPU_Instruction_Set.html \
https://rgbds.gbdev.io/docs/v0.5.1/gbz80.7

instructions currently implemented and tested:\
LD A, D8\
LD B, D8\
LD C, D8\
LD D, D8\
INC A\
INC B\
INC C\
INC D\
HALT

