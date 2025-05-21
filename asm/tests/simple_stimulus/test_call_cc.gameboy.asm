include "global_defines.inc"

SECTION "main", ROM0[$0]
    ld sp,$ffff
    call divider
    ld a,$10
    ld b,$10
    cp b
    call z,pass
    call failure
    halt

section "subroutine", ROM0[$1000]
pass:
    ld a,"p"
    ld [print_addr],a
    ld a,"a"
    ld [print_addr],a
    ld a,"s"
    ld [print_addr],a
    ld a,"s"
    ld [print_addr],a
    ld a,"\n"
    ld [print_addr],a
    call end_divider
    halt
failure:
    ld a,"f"
    ld [print_addr],a
    ld a,"a"
    ld [print_addr],a
    ld a,"i"
    ld [print_addr],a
    ld a,"l"
    ld [print_addr],a
    ld a,"\n"
    ld [print_addr],a
    call end_divider
    ret
divider:
    ld a,"\n"
    ld [print_addr],a
    ld a,">"
    ld [print_addr],a
    ld a,"\n"
    ld [print_addr],a
    ret
end_divider:
    ld a,"<"
    ld [print_addr],a
    ld a,"\n"
    ld [print_addr],a
    ld a,"\n"
    ld [print_addr],a
    ret