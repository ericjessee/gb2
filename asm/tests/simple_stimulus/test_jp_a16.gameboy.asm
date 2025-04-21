SECTION "main", ROM0[$0]
ld a,$00
jp label2
label1:
inc a
label2:
inc a
halt
;a should be 1 if the jump worked, 2 if not