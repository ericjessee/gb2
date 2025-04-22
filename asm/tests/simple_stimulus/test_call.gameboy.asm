include "global_defines.inc"

SECTION "main", ROM0[$0]
ld sp,$ffff
call test_sr
halt

section "subroutine", ROM0[$1000]
test_sr:
    ld a,"g"
    ld [print_addr],a
    ld a,"o"
    ld [print_addr],a
    ld a,"o"
    ld [print_addr],a
    ld a,"d"
    ld [print_addr],a
    ld a,"\n"
    ld [print_addr],a
    ret