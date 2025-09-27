ld_r16_a:
    ld hl,ld_r16_a_str
    call print_str
    ld bc,$c200
    ld a,$ca
    ld [bc],a
    ld a,$fe
    ld bc,$c201
    ld [bc],a
    ld hl,$c200
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

ld_r16_a_str:
    db " test load r16 pointer from a...", 0