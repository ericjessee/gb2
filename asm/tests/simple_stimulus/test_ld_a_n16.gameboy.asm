SECTION "data", ROM0[$20]
    db $be,$ef

SECTION "main", ROM0[$0]
    ld a,[$20]
    ld b,a
    ld a,[$21]
    ld c,a
    halt
