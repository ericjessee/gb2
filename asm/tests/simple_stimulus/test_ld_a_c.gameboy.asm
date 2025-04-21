SECTION "main", ROM0[$0]
    ld h,$ff
    ld l,$80
    ld [hl],$be
    inc l
    ld [hl],$ef
    ld c,$80
    ldh a,[c]
    ld d,a
    inc c
    ldh a,[c]
    ld e,a
    halt
