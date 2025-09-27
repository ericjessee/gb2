ld_hl_r8:
    ld hl, ld_hl_r8_str
    call print_str
    ld hl, $c100
    ld a, $4d
    ld [hl], a
    ld b, [hl]
    cp a,b
    jp nz,fail_case
    jp pass_case
ld_hl_r8_str:
    db " test load hl pointer from r8...", 0