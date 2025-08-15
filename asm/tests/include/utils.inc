;this my "print" subroutine. expects a pointer to a null-terminated string in hl.
;max string length is 255 chars.
print_str:
;    push de ;TODO implement stack ops
    ld de, print_addr
    ld b,$1
print_loop:
    ld a, [hl]
    and a
    jr z, done_print ;check for null termination
    ld [de], a ;load the byte to the print address
    ld a,l
    add a,b ;cludgy way to to do 16-bit increment until implemented
    jr c, inc_h
continue_print:
    ld l,a
    jp print_loop
    ret

inc_h:
    inc h
    jp continue_print

done_print:
    ret
