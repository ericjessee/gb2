call_test:
    ld hl, call_test_str
    call print_str
    ld a,$88
    call call_test_pass
    cp b
    jp z,pass_case
    jp fail_case

call_test_pass:
    ld b,a
    ret

call_test_str:
    db " testing call...", 0