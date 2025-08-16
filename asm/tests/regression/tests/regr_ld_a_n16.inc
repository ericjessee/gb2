ld_a_n16:
    ld hl,ld_a_n16_str
    call print_str
    ld a,[$3002]
    ld b,$ca
    cp b
    jp nz,fail_case
    ld a,[$3003]
    ld b,$fe
    cp b
    jp nz,fail_case
    jp pass_case
ld_a_n16_str:
    db " test load from n16 pointer...", 0
