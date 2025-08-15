;this my "print" subroutine. expects a pointer to a null-terminated string in hl.
;max string length is 255 chars.
print_str:
;    push de ;TODO implement stack ops
    ld de, print_addr
print_loop:
    ld a, [hl]
    inc l
    ld [de], a
    and a
    jr nz, print_loop
    ret