ld_a_r16:
    ld hl, ld_a_r16_str
    call print_str
    ld d,$30
    ld e,$00
    ld a,[de]
    ld b,$be
    cp b
    jp nz,fail_case
    inc e
    ld a,[de]
    ld b,$ef
    cp b
    jp nz,fail_case
    jp pass_case
ld_a_r16_str:
    db " test load a from r16 pointer...", 0
