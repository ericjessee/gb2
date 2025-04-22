second attempt at a verilog model of an sm83 cpu, with lessons learned from various projecsts in the meantime.

references:\
https://gekkio.fi/files/gb-docs/gbctr.pdf \
https://meganesu.github.io/generate-gb-opcodes/ \
https://gbdev.io/pandocs/CPU_Instruction_Set.html \
https://rgbds.gbdev.io/docs/v0.5.1/gbz80.7

instructions currently implemented and tested:\
ld r8,r8 \
ld r8,d8 \
ld r8,[hl] \
ld [hl],r8 \
ld [hl],d8 \
ld a,[bc] \
ld a,[de] \
ld [bc],a \
ld [de],a \
ld a,[n16] \
ld [n16],a \
ldh a,[c] \
jp a16 \
jp cc, a16 \
call a16 \
cp r8 \
inc r8 \
dec r8 \
halt