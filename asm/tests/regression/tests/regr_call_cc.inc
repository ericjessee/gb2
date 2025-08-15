call_cc:
    ld hl, call_cc_str
    call print_str
    ld a,$23
    ld b,$23
    sub a,b
    ld a,$88
    call z, call_cc_pass
    cp b
    jp z,pass_case
    jp fail_case

call_cc_pass:
    ld b,a
    ret

call_cc_str:
    db " testing conditional call...", 0