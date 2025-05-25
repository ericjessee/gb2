;at this point, this is just the load example from the rgbasm docs. 
;i don't support hli, or dec/inc of 16 bit registers yet, so I had to modify it.
;this means that load sections can't be longer than 255 bytes (yet)

include "global_defines.inc"

SECTION "LOAD example", ROM0

call CopyCode
halt

CopyCode:
    ld de, RAMCode
    ld hl, RAMLocation
    ld c, RAMLocation.end - RAMLocation
.loop
    ld a, [de]
    inc e
    ld [hl], a
    inc l
    dec c
    jp nz, .loop
    ret
    
;this is the code that we are copying into the work ram
;the LOAD block allows offsets, labels etc to be calculated as if they are inside WRAM0 (for this example)
;meaning when we copy the code to WRAM0 (done by CopyCode) it will execute correctly
RAMCode:
  LOAD "RAM code", WRAM0
RAMLocation:
    ld hl, .string
    ld de, $9864
.copy
    ld a, [hli]
    ld [de], a
    inc e
    and a
    jr nz, .copy
    ret

.string
    db "Hello World!", 0
.end
  ENDL
