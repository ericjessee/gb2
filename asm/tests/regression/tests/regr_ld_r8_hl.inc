ld_r8_hl:
    ld hl,ld_r8_hl_str
    call print_str
    ld hl,$c200
    ld a,$ca
    ld [hl],a
    ld b,[hl]
    cp a,b
    jp nz,fail_case
    jp pass_case

ld_r8_hl_str:
    db " test load r8 from hl pointer...", 0