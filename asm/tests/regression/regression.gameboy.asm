;at this point, this is just the load example from the rgbasm docs. 
;i don't support hli, or dec/inc of 16 bit registers yet, so I had to modify it.
;this means that load sections can't be longer than 255 bytes (yet)

include "global_defines.inc"

SECTION "main", ROM0
    ld hl, string1 ; "Beginning regression..."
    call print_str
    call cp_r8
    call ld_r8_r8
    call add_a_r8
    ;call call_cc
    halt

;helper subroutines here
include "utils.inc"

fail_case:
    ld hl, fail_str
    call print_str
    ret
pass_case:
    ld hl, pass_str
    call print_str
    ret

;regression tests here
include "regr_cp_r8.inc"
include "regr_ld_r8_r8.inc"
include "regr_add_a_r8.inc"
include "regr_call_cc.inc"

string1:
    db "Beginning regression...\n", 0
pass_str:
    db "pass!\n", 0
fail_str:
    db "fail!\n", 0
