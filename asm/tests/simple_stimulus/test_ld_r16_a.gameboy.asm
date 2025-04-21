SECTION "main", ROM0[$0]
    ld d,$00
    ld e,$20
    ld a,$be
    ld [de],a
    ld a,$ef
    ld e,$21
    ld [de],a
    halt
