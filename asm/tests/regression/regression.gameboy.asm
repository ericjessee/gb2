include "global_defines.inc"

SECTION "main", ROM0[$0]
    call print_str
test:
    ;preload some data into ram for reading
    ld h,$ff
    ld l,$80
    ld [hl],$be
    inc l
    ld [hl],$ef
    ld l,$a0
    ld [hl],$ff
    ;run the tests
    

section "subroutines", ROM0[$1000]
print_str:
    ld h,$20
    ld l,$00
    ld b,[hl]
    inc l
    ld a,[hl]
str_loop:
    ld [print_addr],a
    inc l
    ld a,[hl]
    dec b
    jp nz,str_loop
    ret


section "string_1", ROM0[$2000]
    db 20 ;string length
    db "starting regression\n"
    

