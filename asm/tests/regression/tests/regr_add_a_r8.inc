add_a_r8:
    ld hl,add_a_r8_str
    call print_str
    ld a,$55
    ld d,$32
    add a,d
    ld b,a ;move result to b
    ld a,$87 ;0x55 + 0x32 = 0x87
    cp b
    jp z,pass_case
    jp fail_case
add_a_r8_str:
    db " test add r8 to a...", 0