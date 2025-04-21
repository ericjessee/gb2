SECTION "main", ROM0[$0]
ld a,$10
ld b,$20
cp b
ld b,$10
cp b
halt
