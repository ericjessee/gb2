SECTION "main", ROM0[$0]
    ld a,$be
    ld [$20],a
    ld a,$ef
    ld [$21],a
    halt
