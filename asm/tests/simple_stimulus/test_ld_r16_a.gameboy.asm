SECTION "main", ROM0[$0]
    ld d,$c0
    ld e,$00
    ld a,$ca
    ld [de],a
    ld a,$fe
    inc e
    ld [de],a
    halt
