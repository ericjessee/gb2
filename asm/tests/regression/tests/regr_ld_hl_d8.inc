ld_hl_d8:
    ld hl, ld_hl_d8_str
    call print_str
    ld h,$c1
    ld l,$00
    ld [hl],$be
    ld l,$01
    ld [hl],$ef
    ld l,$00
    ld b,[hl]
    ld a,$be
    cp a,b
    jp nz, fail_case
    ld l,$01
    ld b,[hl]
    ld a,$ef
    cp a,b
    jp nz, fail_case
    jp pass_case

ld_hl_d8_str:
    db " test load hl pointer from d8...", 0