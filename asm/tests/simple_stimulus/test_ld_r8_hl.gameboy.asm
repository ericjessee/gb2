SECTION "data", ROM0[$20]
    db $be,$ef

SECTION "main", ROM0[$0]
    ld h,$00
    ld l,$20
    ld d,[hl]
    ld l,$21
    ld e,[hl]
    halt
