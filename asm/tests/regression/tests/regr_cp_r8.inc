cp_r8:
    ld hl, cp_r8_str
    call print_str
    ld a,$55
    ld b,$55
    cp b
    jp z,pass_case
    jp fail_case
cp_r8_str:
    db " test compare a with r8...", 0