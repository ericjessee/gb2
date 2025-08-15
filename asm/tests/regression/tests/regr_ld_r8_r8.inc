ld_r8_r8:
    ld hl, ld_r8_r8_str
    call print_str
    ld b,$45
    ld c,b
    ld a,$45
    cp c
    jp z,pass_case
    jp fail_case
ld_r8_r8_str:
    db " test load r8<-r8...", 0
