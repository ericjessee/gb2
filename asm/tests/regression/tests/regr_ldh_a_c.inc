;this seems to produce false positives when the read data is x...
ldh_a_c:
    ld hl,ldh_a_c_str
    call print_str
    ld h,$ff
    ld l,$80
    ld [hl],$be
    inc l
    ld [hl],$ef ;load beef to 0xff80
    ld c,$80
    ldh a,[c] ;load be from 0xff80
    ld d,a
    ld a,$be
    cp d
    jp nz,fail_case
    inc c
    ldh a,[c] ;load ef from 0xff81
    ld d,a
    ld a,$ef
    cp d
    jp nz,fail_case
    jp pass_case
ldh_a_c_str:
    db " test load from high mem + c...", 0
