def print_addr   equ  $ffb0

SECTION "main", ROM0[$0]
call test_sr
halt

test_sr:
    ld a,"o"
    ld [print_addr],a
    ret