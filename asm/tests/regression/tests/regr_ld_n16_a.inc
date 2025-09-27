ld_n16_a:
    ld hl,ld_n16_a_str
    call print_str
    ld a,$ca
    ld [$c100],a
    ld a,$fe
    ld [$c101],a
    ld hl,$c100
    ld a,$ca
    ld b,[hl]
    cp a,b
    jp nz,fail_case
    ld l,$01
    ld a,$fe
    ld b,[hl]
    cp a,b
    jp nz,fail_case
    jp pass_case

ld_n16_a_str:
    db " test load n16 pointer from a...", 0