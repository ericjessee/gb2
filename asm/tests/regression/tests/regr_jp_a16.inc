jp_a16:
    ld hl, jp_a16_str
    call print_str
    ld a,0
    jp jp_a16_inc_a
jp_a16_check:
    ld b,a
    ld a,$1
    cp b
    jp z,pass_case
    jp fail_case
jp_a16_inc_a:
    inc a
    jp jp_a16_check
jp_a16_str:
    db " test jump to n16 pointer...", 0
