SECTION "data", ROM0[$20]
    db $be,$ef

SECTION "main", ROM0[$0]
    ld c,1
    ld e,2
    ld l,3
    ld a,4
    ld b,5
    ld d,6
    ld h,$00
    ld l,$20
loads:
    ld c,[hl]
    halt
;    ld e,[hl]
;    ld l,[hl]
;    ld l,0
;    ld b,[hl]
;    ld d,[hl]
;    ld h,[hl]
;    ld a,[hl]
;    jp loads
;    halt
