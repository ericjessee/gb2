inc_r8_test:
    ld hl, inc_r8_test_str
    call print_str
    ld a,$55
    ld b,a
    inc b
    ld a,$56
    cp b
    jp z,pass_case
    jp fail_case
inc_r8_test_str:
    db " test r8 increment...", 0