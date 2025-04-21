define success_byte equ $ffa0

SECTION "main", ROM0[$0]
;preload some data into ram for reading
ld h,$ff
ld l,$80
ld [hl],$be
inc l
ld [hl],$ef
ld l,$a0
ld [hl],$ff
;run the tests
test1:
.include "tests/regr_cp_r8.gameboy.asm"
test2: