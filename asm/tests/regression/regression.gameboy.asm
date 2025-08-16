;at this point, this is just the load example from the rgbasm docs. 
;i don't support hli, or dec/inc of 16 bit registers yet, so I had to modify it.
;this means that load sections can't be longer than 255 bytes (yet)

include "global_defines.inc"

SECTION "main", ROM0[$100] ;before $100 are the reset vectors and ISRs
    jp EntryPoint
    db 0
    NINTENDO_LOGO
    ds $150 - @, 0 ; $100-$150 is the cartridge header, must be untouched

EntryPoint:
    ld hl, begin_str ; "Beginning regression..."
    call print_str
    call cp_r8
    call ld_r8_r8
    call add_a_r8
    call call_test
    call call_cc
    call dec_r8_test
    call inc_r8_test
    call jp_a16
    call ldh_a_c
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
include "regr_call.inc"
include "regr_call_cc.inc"
include "regr_dec_r8.inc"
include "regr_inc_r8.inc"
include "regr_jp_a16.inc"
include "regr_ldh_a_c.inc"

begin_str:
    db "Beginning regression...\n", 0
pass_str:
    db "pass!\n", 0
fail_str:
    db "fail!\n", 0
