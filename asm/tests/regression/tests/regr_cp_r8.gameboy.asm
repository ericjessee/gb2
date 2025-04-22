    ld a,$55
    ld b,$55
    cp b
    jp z,done1
nojp:
    ld h,$ff
    ld l,$a0
    ld a,[hl]
    dec a
    ld [hl],a
done1:
