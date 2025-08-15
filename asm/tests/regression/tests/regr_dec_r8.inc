dec_r8_test:
    ld hl, dec_r8_test_str
    call print_str
    ld a,$55
    ld b,a
    dec b
    ld a,$54
    cp b
    jp z,pass_case
    jp fail_case
dec_r8_test_str:
    db " test r8 decrement...", 0