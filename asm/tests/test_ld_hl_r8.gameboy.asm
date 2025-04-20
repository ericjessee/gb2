SECTION "main", ROM0[$0]
    ld h,$00
    ld l,$20
    ld a,$be
    ld [hl],a
    ld a,$ef
    ld l,$21
    ld [hl],a
    halt
