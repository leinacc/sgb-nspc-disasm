.macro VCMD_END
    .db $00
.endm

.macro VCMD_RETURN
    .db $00
.endm

.macro VCMD_TIE
    .db $c8
.endm

.macro VCMD_REST
    .db $c9
.endm

.macro VCMD_SET_INSTRUMENT
    .db $e0, \1
.endm

.macro VCMD_PAN
    .db $e1, \1
.endm

.macro VCMD_MASTER_VOLUME
    .db $e5, \1
.endm

.macro VCMD_TEMPO
    .db $e7, \1
.endm

.macro VCMD_GLOBAL_TRANSPOSE
    .db $e9, \1
.endm

.macro VCMD_VOLUME
    .db $ed, \1
.endm

.macro VCMD_CALL_SUBROUTINE
    .db $ef
    .dw \1
    .db \2-1
.endm

.macro VCMD_ECHO_VBITS_VOLUME
    .db $f5, \1, \2, \3
.endm

.macro VCMD_ECHO_PARAMETERS
    .db $f7, \1, \2, \3
.endm

.macro VCMD_PERCUSSION_PATCH_BASE
    .db $fa, \1
.endm
