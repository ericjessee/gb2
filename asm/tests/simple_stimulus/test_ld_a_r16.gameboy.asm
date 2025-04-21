SECTION "data", ROM0[$20]
    db $be,$ef

SECTION "main", ROM0[$0]
    ld d,$00
    ld e,$20
    ld a,[de]
    ld e,$21
    ld a,[de]
    halt
