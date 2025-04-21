SECTION "main", ROM0[$0]
ld a,$01
dec a
jp z,label2
label1:
inc a
label2:
jp nz, label4
label3:
inc a
label4:
halt
;a should be 1 by the end if jumps were correct