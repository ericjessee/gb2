jp_cc_a16:
    ld hl, jp_cc_a16_str
    call print_str
    ld a,0
    and a
    jp z,jp_a16_inc_a
jp_cc_a16_check:
    ld b,a
    ld a,$1
    cp b
    jp z,pass_case
    jp fail_case
jp_cc_a16_inc_a:
    inc a
    jp jp_a16_check
jp_cc_a16_str:
    db " test conditional jump to n16 pointer...", 0
