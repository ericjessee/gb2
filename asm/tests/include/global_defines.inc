def success_byte equ  $ffa0
def print_addr   equ  $ffb0


MACRO NINTENDO_LOGO
    DB  $7F,$CF,$CC,$0C,$FF,$11,$CC,$88,$7F,$E7,$8C,$00,$CE,$FD,$37,$FB
    DB  $13,$31,$E3,$3E,$33,$03,$EF,$3F,$FC,$F7,$C1,$DC,$19,$FF,$88,$80
    DB  $38,$F7,$CC,$C8,$DD,$CC,$BB,$33,$33,$31,$F3,$3E,$30,$33,$F3,$FE
ENDM