SECTION "main", ROM0[$0]
    ld c,$80
    ld a,$be
    ldh [c],a
    inc c
    ld a,$ef
    ldh [c],a

    ld c,$80
    ldh a,[c]
    ld d,a
    inc c
    ldh a,[c]
    ld e,a
    halt
