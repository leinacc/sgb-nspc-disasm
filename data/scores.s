; Song -> Phrase -> Track
; Phrase: a block of music to play for all channels
; Track: a block of music to play for 1 channel

    .dw Music1_IntroJingle
    .dw Music2toF_Credits
    .dw Music2toF_Credits
    .dw Music2toF_Credits
    .dw Music2toF_Credits
    .dw Music2toF_Credits
    .dw Music2toF_Credits
    .dw Music2toF_Credits
    .dw Music2toF_Credits
    .dw Music2toF_Credits
    .dw Music2toF_Credits
    .dw Music2toF_Credits
    .dw Music2toF_Credits
    .dw Music2toF_Credits
    .dw Music2toF_Credits


Music1_IntroJingle:
    .dw IntroJinglePhrase0
    .dw $0000
    

IntroJinglePhrase0:
    .dw IntroJingleTrack0
    .dw IntroJingleTrack1
    .dw $2b5a
    .dw $2b6e
    .dw $2b79
    .dw $2b84
    .dw $2b8f
    .dw $2b9a


IntroJingleTrack0:
    VCMD_PERCUSSION_PATCH_BASE $27                                                  ; $2b32 : $fa, $27
    VCMD_TEMPO $2d                                                  ; $2b34 : $e7, $2d
    VCMD_MASTER_VOLUME $fa                                                  ; $2b36 : $e5, $fa
    VCMD_VOLUME $96                                                  ; $2b38 : $ed, $96
    VCMD_ECHO_VBITS_VOLUME $fb, $28, $28                                       ; $2b3a : $f5, $fb, $28, $28
    VCMD_ECHO_PARAMETERS $02, $5a, $02                                         ; $2b3e : $f7, $02, $5a, $02
    VCMD_PAN $0a                                                  ; $2b42 : $e1, $0a
    VCMD_SET_INSTRUMENT $24                                                  ; $2b44 : $e0, $24
    VCMD_GLOBAL_TRANSPOSE $0a                                                  ; $2b46 : $e9, $0a
    .db $60                                                  ; $2b48 : $60
    VCMD_REST                                                  ; $2b49 : $c9
    .db $60                                                  ; $2b4a : $60
    .db $7f                                                  ; $2b4b : $7f
    .db $a4                                                  ; $2b4c : $a4
    VCMD_TIE                                                  ; $2b4d : $c8
    VCMD_END                                                  ; $2b4e : $00


IntroJingleTrack1:
    VCMD_CALL_SUBROUTINE Block_2ba6, $02                                 ; $2b4f : $ef, $a6, $2b, $01

    or A, $c9                                                  ; $2b53 : $04, $c9
    lsr A                                                  ; $2b55 : $5c
    reti                                                  ; $2b56 : $7f


    sbc A, #$60                                                  ; $2b57 : $a8, $60
    cmp X, #$ed                                                  ; $2b59 : $c8, $ed
    ei                                                  ; $2b5b : $a0
    tcall 14                                                  ; $2b5c : $e1
    or1 c, $1be0.6                                                  ; $2b5d : $0a, $e0, $db
    bmi $7f                                                  ; $2b60 : $30, $7f

    adc A, [$f9]+Y                                                  ; $2b62 : $97, $f9
    nop                                                  ; $2b64 : $00
    clrc                                                  ; $2b65 : $60
    inc $c8+X                                                  ; $2b66 : $bb, $c8
    pop Y                                                  ; $2b68 : $ee
    clrc                                                  ; $2b69 : $60
    cmp X, !$c860                                                  ; $2b6a : $1e, $60, $c8
    cmp X, #$ef                                                  ; $2b6d : $c8, $ef
    sbc A, (X)                                                  ; $2b6f : $a6
    rol $01                                                  ; $2b70 : $2b, $01
    asl !$54c9                                                  ; $2b72 : $0c, $c9, $54
    reti                                                  ; $2b75 : $7f


    pop A                                                  ; $2b76 : $ae
    clrc                                                  ; $2b77 : $60
    cmp X, #$ef                                                  ; $2b78 : $c8, $ef
    sbc A, (X)                                                  ; $2b7a : $a6
    rol $01                                                  ; $2b7b : $2b, $01
    bpl -$37                                                  ; $2b7d : $10, $c9

    bvc $7f                                                  ; $2b7f : $50, $7f

    clr1 $60.5                                                  ; $2b81 : $b2, $60
    cmp X, #$ef                                                  ; $2b83 : $c8, $ef
    sbc A, (X)                                                  ; $2b85 : $a6
    rol $01                                                  ; $2b86 : $2b, $01
    or A, $c9+X                                                  ; $2b88 : $14, $c9
    lsr !$b57f                                                  ; $2b8a : $4c, $7f, $b5
    clrc                                                  ; $2b8d : $60
    cmp X, #$ef                                                  ; $2b8e : $c8, $ef
    sbc A, (X)                                                  ; $2b90 : $a6
    rol $01                                                  ; $2b91 : $2b, $01
    or $48, #$c9                                                  ; $2b93 : $18, $c9, $48
    reti                                                  ; $2b96 : $7f


    sbc (X), (Y)                                                  ; $2b97 : $b9
    clrc                                                  ; $2b98 : $60
    cmp X, #$ef                                                  ; $2b99 : $c8, $ef
    sbc A, (X)                                                  ; $2b9b : $a6
    rol $01                                                  ; $2b9c : $2b, $01
    or A, #$c9                                                  ; $2b9e : $08, $c9
    eor $ab, #$7f                                                  ; $2ba0 : $58, $7f, $ab
    clrc                                                  ; $2ba3 : $60
    cmp X, #$00                                                  ; $2ba4 : $c8, $00


Block_2ba6:
    VCMD_VOLUME $96                                                  ; $2ba6 : $ed, $96
    VCMD_PAN $0a                                                  ; $2ba8 : $e1, $0a
    VCMD_SET_INSTRUMENT $24                                                  ; $2baa : $e0, $24
    .db $60                                                  ; $2bac : $60
    VCMD_REST                                                  ; $2bad : $c9
    VCMD_RETURN                                                  ; $2bae : $00
    
    
Music2toF_Credits:
    .dw $2c6b
@loop:
    .dw $2bfb
    .dw $2c0b
    .dw $2bfb
    .dw $2c1b
    .dw $2c2b
    .dw CreditsPhrase6
    .dw $2bfb
    .dw $2c1b
    .dw $2c3b
    .dw CreditsPhraseA
    .dw $00ff, @loop
    .dw $0000


; unused
Phrase_2bcb:
    .dw track_2c7b
    nop                                                  ; $2bcd : $00
    nop                                                  ; $2bce : $00
    nop                                                  ; $2bcf : $00
    nop                                                  ; $2bd0 : $00
    nop                                                  ; $2bd1 : $00
    nop                                                  ; $2bd2 : $00
    nop                                                  ; $2bd3 : $00
    nop                                                  ; $2bd4 : $00
    nop                                                  ; $2bd5 : $00
    nop                                                  ; $2bd6 : $00
    nop                                                  ; $2bd7 : $00
    nop                                                  ; $2bd8 : $00
    nop                                                  ; $2bd9 : $00
    nop                                                  ; $2bda : $00


; unused
Phrase_2bdb:
    .dw track_2c90

    inc !$bd2c                                                  ; $2bdd : $ac, $2c, $bd
    rol !$2ccc                                                  ; $2be0 : $2c, $cc, $2c
    movw $2c, YA                                                  ; $2be3 : $da, $2c
    mov X, !$002c                                                  ; $2be5 : $e9, $2c, $00
    nop                                                  ; $2be8 : $00


;
    nop                                                  ; $2be9 : $00
    nop                                                  ; $2bea : $00


CreditsPhraseA:
    tcall 15                                                  ; $2beb : $f1
    rol !$2d0e                                                  ; $2bec : $2c, $0e, $2d
    decw $2d                                                  ; $2bef : $1a, $2d
    and A, [$2d+X]                                                  ; $2bf1 : $27, $2d
    set1 $2d.2                                                  ; $2bf3 : $42, $2d
    bvc $2d                                                  ; $2bf5 : $50, $2d

    nop                                                  ; $2bf7 : $00
    nop                                                  ; $2bf8 : $00
    nop                                                  ; $2bf9 : $00
    nop                                                  ; $2bfa : $00
    cmp Y, !$742d                                                  ; $2bfb : $5e, $2d, $74
    push A                                                  ; $2bfe : $2d
    pop PSW                                                  ; $2bff : $8e
    push A                                                  ; $2c00 : $2d
    sbc $cc, #$2d                                                  ; $2c01 : $b8, $2d, $cc
    push A                                                  ; $2c04 : $2d
    bpl $2e                                                  ; $2c05 : $10, $2e

    eor A, $2e+X                                                  ; $2c07 : $54, $2e
    clrc                                                  ; $2c09 : $60
    cbne $88, $2e                                                  ; $2c0a : $2e, $88, $2e

    mov1 c, $042e.6                                                  ; $2c0d : $aa, $2e, $c4
    cbne $ee, $2e                                                  ; $2c10 : $2e, $ee, $2e

    nop                                                  ; $2c13 : $00
    bra $35                                                  ; $2c14 : $2f, $35

    bra $6a                                                  ; $2c16 : $2f, $6a

    bra $00                                                  ; $2c18 : $2f, $00

    nop                                                  ; $2c1a : $00
    xcn A                                                  ; $2c1b : $9f
    bra -$3b                                                  ; $2c1c : $2f, $c5

    bra -$21                                                  ; $2c1e : $2f, $df

    bra -$0b                                                  ; $2c20 : $2f, $f5

    bra $03                                                  ; $2c22 : $2f, $03

    bmi $26                                                  ; $2c24 : $30, $26

    bmi $49                                                  ; $2c26 : $30, $49

    bmi $6a                                                  ; $2c28 : $30, $6a

    bmi -$73                                                  ; $2c2a : $30, $8d

    bmi -$6b                                                  ; $2c2c : $30, $95

    bmi -$55                                                  ; $2c2e : $30, $ab

    bmi -$4d                                                  ; $2c30 : $30, $b3

    bmi -$47                                                  ; $2c32 : $30, $b9

    bmi -$40                                                  ; $2c34 : $30, $c0

    bmi -$39                                                  ; $2c36 : $30, $c7

    bmi $00                                                  ; $2c38 : $30, $00

    nop                                                  ; $2c3a : $00
    mov !$da30, Y                                                  ; $2c3b : $cc, $30, $da
    bmi -$03                                                  ; $2c3e : $30, $fd

    bmi $08                                                  ; $2c40 : $30, $08

    tcall 3                                                  ; $2c42 : $31
    or A, [$31]+Y                                                  ; $2c43 : $17, $31
    clrp                                                  ; $2c45 : $20
    tcall 3                                                  ; $2c46 : $31
    and $00, $31                                                  ; $2c47 : $29, $31, $00
    nop                                                  ; $2c4a : $00


CreditsPhrase6:
    .dw $3130
    .dw $3151
    .dw $31a6
    .dw $320c
    .dw $323b
    .dw $32a2
    .dw $32e5
    .dw $332e
    .dw $3383
    .dw $0000


;
    nop                                                  ; $2c5f : $00
    nop                                                  ; $2c60 : $00
    nop                                                  ; $2c61 : $00
    nop                                                  ; $2c62 : $00
    nop                                                  ; $2c63 : $00
    nop                                                  ; $2c64 : $00
    nop                                                  ; $2c65 : $00
    nop                                                  ; $2c66 : $00
    nop                                                  ; $2c67 : $00
    nop                                                  ; $2c68 : $00
    nop                                                  ; $2c69 : $00
    nop                                                  ; $2c6a : $00
    mov X, SP                                                  ; $2c6b : $9d
    bbc $c5.1, $33                                                  ; $2c6c : $33, $c5, $33

    cbne $33+X, -$13                                                  ; $2c6f : $de, $33, $ed

    bbc $fc.1, $33                                                  ; $2c72 : $33, $fc, $33

    or A, !$0034+X                                                  ; $2c75 : $15, $34, $00
    nop                                                  ; $2c78 : $00
    bra $34                                                  ; $2c79 : $2f, $34


track_2c7b:
    VCMD_SET_INSTRUMENT $05                                                  ; $2c7b : $e0, $05
    .db $18                                                  ; $2c7d : $18
    .db $7f                                                  ; $2c7e : $7f
    .db $a4                                                  ; $2c7f : $a4
    VCMD_SET_INSTRUMENT $0a                                                  ; $2c80 : $e0, $0a
    .db $a4                                                  ; $2c82 : $a4
    VCMD_SET_INSTRUMENT $0b                                                  ; $2c83 : $e0, $0b
    .db $a4                                                  ; $2c85 : $a4
    .db $a6                                                  ; $2c86 : $a6
    .db $a8                                                  ; $2c87 : $a8
    .db $a9                                                  ; $2c88 : $a9
    VCMD_SET_INSTRUMENT $14                                                  ; $2c89 : $e0, $14
    .db $a4                                                  ; $2c8b : $a4
    .db $a6                                                  ; $2c8c : $a6
    .db $a8                                                  ; $2c8d : $a8
    .db $a9                                                  ; $2c8e : $a9
    VCMD_END                                                  ; $2c8f : $00


track_2c90:
    mov A, [$22+X]                                                  ; $2c90 : $e7, $22
    mov A, !$edb4                                                  ; $2c92 : $e5, $b4, $ed
    sbc A, $f5+X                                                  ; $2c95 : $b4, $f5
    asl !$2828                                                  ; $2c97 : $0c, $28, $28
    mov A, [$02]+Y                                                  ; $2c9a : $f7, $02
    cmpw YA, $02                                                  ; $2c9c : $5a, $02
    tcall 14                                                  ; $2c9e : $e1
    brk                                                  ; $2c9f : $0f


    clrv                                                  ; $2ca0 : $e0
    mov !$c910+X, A                                                  ; $2ca1 : $d5, $10, $c9
    or A, #$7f                                                  ; $2ca4 : $08, $7f
    sbc A, $10                                                  ; $2ca6 : $a4, $10
    sbc A, $08                                                  ; $2ca8 : $a4, $08
    sbc A, $00                                                  ; $2caa : $a4, $00
    notc                                                  ; $2cac : $ed
    sbc A, $e0+X                                                  ; $2cad : $b4, $e0
    mov $e1+X,A                                                  ; $2caf : $d4, $e1
    asl !$c910                                                  ; $2cb1 : $0c, $10, $c9
    or A, #$7f                                                  ; $2cb4 : $08, $7f
    xcn A                                                  ; $2cb6 : $9f
    clrv                                                  ; $2cb7 : $e0
    mov $e1, X                                                  ; $2cb8 : $d8, $e1
    or A, [$18+X]                                                  ; $2cba : $07, $18
    sbc A, #$ed                                                  ; $2cbc : $a8, $ed
    sbc A, $e0+X                                                  ; $2cbe : $b4, $e0
    bne -$1f                                                  ; $2cc0 : $d0, $e1

    or1 c, $0910.6                                                  ; $2cc2 : $0a, $10, $c9
    or A, #$5f                                                  ; $2cc5 : $08, $5f
    xcn A                                                  ; $2cc7 : $9f
    bpl -$5f                                                  ; $2cc8 : $10, $a1

    or A, #$9f                                                  ; $2cca : $08, $9f
    notc                                                  ; $2ccc : $ed
    cmp X, #$e1                                                  ; $2ccd : $c8, $e1
    or1 c, $0ae0.0                                                  ; $2ccf : $0a, $e0, $0a
    bpl -$37                                                  ; $2cd2 : $10, $c9

    or $87, #$6f                                                  ; $2cd4 : $18, $6f, $87
    or A, #$3b                                                  ; $2cd7 : $08, $3b
    adc A, [$ed+X]                                                  ; $2cd9 : $87, $ed
    sbc A, $e0+X                                                  ; $2cdb : $b4, $e0
    bne -$1f                                                  ; $2cdd : $d0, $e1

    or $c9, $10                                                  ; $2cdf : $09, $10, $c9
    or A, #$5f                                                  ; $2ce2 : $08, $5f
    xcn A                                                  ; $2ce4 : $9f
    bpl -$62                                                  ; $2ce5 : $10, $9e

    or A, #$9f                                                  ; $2ce7 : $08, $9f
    notc                                                  ; $2ce9 : $ed
    sbc A, $e0+X                                                  ; $2cea : $b4, $e0
    asl A                                                  ; $2cec : $1c
    tcall 14                                                  ; $2ced : $e1
    or A, #$30                                                  ; $2cee : $08, $30
    mov !$d5e0, X                                                  ; $2cf0 : $c9, $e0, $d5
    tcall 14                                                  ; $2cf3 : $e1
    brk                                                  ; $2cf4 : $0f


    bpl $7f                                                  ; $2cf5 : $10, $7f

    sbc A, $08                                                  ; $2cf7 : $a4, $08
    sbc A, $18                                                  ; $2cf9 : $a4, $18
    sbc A, $a4                                                  ; $2cfb : $a4, $a4
    or A, #$a4                                                  ; $2cfd : $08, $a4
    sbc A, $a4                                                  ; $2cff : $a4, $a4
    clrv                                                  ; $2d01 : $e0
    mov !$a418+Y, A                                                  ; $2d02 : $d6, $18, $a4
    clrv                                                  ; $2d05 : $e0
    mov $e1, X                                                  ; $2d06 : $d8, $e1
    or A, [$10+X]                                                  ; $2d08 : $07, $10
    sbc A, #$08                                                  ; $2d0a : $a8, $08
    sbc A, #$00                                                  ; $2d0c : $a8, $00
    clrv                                                  ; $2d0e : $e0
    mov $e1+X,A                                                  ; $2d0f : $d4, $e1
    asl !$7f18                                                  ; $2d11 : $0c, $18, $7f
    xcn A                                                  ; $2d14 : $9f
    xcn A                                                  ; $2d15 : $9f
    xcn A                                                  ; $2d16 : $9f
    xcn A                                                  ; $2d17 : $9f
    xcn A                                                  ; $2d18 : $9f
    xcn A                                                  ; $2d19 : $9f
    clrv                                                  ; $2d1a : $e0
    bne -$1f                                                  ; $2d1b : $d0, $e1

    or1 c, $0f18.1                                                  ; $2d1d : $0a, $18, $2f
    tcall 10                                                  ; $2d20 : $a1
    set1 $18.5                                                  ; $2d21 : $a2, $18
    reti                                                  ; $2d23 : $7f


    bbs $48.5, -$37                                                  ; $2d24 : $a3, $48, $c9

    or $85, #$3f                                                  ; $2d27 : $18, $3f, $85
    adc A, $18                                                  ; $2d2a : $84, $18
    pcall $82                                                  ; $2d2c : $4f, $82
    clrv                                                  ; $2d2e : $e0
    bbc $e1.6, $0a                                                  ; $2d2f : $d3, $e1, $0a

    or $ab, #$1f                                                  ; $2d32 : $18, $1f, $ab
    mov X, $00+Y                                                  ; $2d35 : $f9, $00
    or1 c, $12bc.0                                                  ; $2d37 : $0a, $bc, $12
    reti                                                  ; $2d3a : $7f


    sbc (X), (Y)                                                  ; $2d3b : $b9
    mov X, $00+Y                                                  ; $2d3c : $f9, $00
    clr1 $ab.0                                                  ; $2d3e : $12, $ab
    cmp X, !$e0c9                                                  ; $2d40 : $1e, $c9, $e0
    bne -$1f                                                  ; $2d43 : $d0, $e1

    or $2f, $18                                                  ; $2d45 : $09, $18, $2f
    mov X, SP                                                  ; $2d48 : $9d
    div YA, X                                                  ; $2d49 : $9e
    or $9f, #$7f                                                  ; $2d4a : $18, $7f, $9f
    mov !$c9c9, X                                                  ; $2d4d : $c9, $c9, $c9
    clrv                                                  ; $2d50 : $e0
    bne -$1f                                                  ; $2d51 : $d0, $e1

    or A, #$18                                                  ; $2d53 : $08, $18
    bra -$68                                                  ; $2d55 : $2f, $98

    adc (X), (Y)                                                  ; $2d57 : $99
    or $9a, #$7f                                                  ; $2d58 : $18, $7f, $9a
    mov !$c9c9, X                                                  ; $2d5b : $c9, $c9, $c9
    clrv                                                  ; $2d5e : $e0
    mov !$0fe1+X, A                                                  ; $2d5f : $d5, $e1, $0f
    or $a4, #$7f                                                  ; $2d62 : $18, $7f, $a4
    bpl -$5c                                                  ; $2d65 : $10, $a4

    or A, #$a4                                                  ; $2d67 : $08, $a4
    or $10, #$a4                                                  ; $2d69 : $18, $a4, $10
    sbc A, $08                                                  ; $2d6c : $a4, $08
    sbc A, $ef                                                  ; $2d6e : $a4, $ef
    bbc $34.2, $03                                                  ; $2d70 : $53, $34, $03

    nop                                                  ; $2d73 : $00
    clrv                                                  ; $2d74 : $e0
    mov $e1+X,A                                                  ; $2d75 : $d4, $e1
    asl !$7f18                                                  ; $2d77 : $0c, $18, $7f
    xcn A                                                  ; $2d7a : $9f
    clrv                                                  ; $2d7b : $e0
    mov $e1, X                                                  ; $2d7c : $d8, $e1
    or A, [$a8+X]                                                  ; $2d7e : $07, $a8
    clrv                                                  ; $2d80 : $e0
    mov $e1+X,A                                                  ; $2d81 : $d4, $e1
    asl !$e09f                                                  ; $2d83 : $0c, $9f, $e0
    mov $e1, X                                                  ; $2d86 : $d8, $e1
    or A, [$a8+X]                                                  ; $2d88 : $07, $a8
    sleep                                                  ; $2d8a : $ef
    clrc                                                  ; $2d8b : $60
    and A, $03+X                                                  ; $2d8c : $34, $03
    clrv                                                  ; $2d8e : $e0
    bne -$1f                                                  ; $2d8f : $d0, $e1

    or1 c, $14e3.0                                                  ; $2d91 : $0a, $e3, $14
    bpl $3c                                                  ; $2d94 : $10, $3c

    or $30, #$c9                                                  ; $2d96 : $18, $c9, $30
    reti                                                  ; $2d99 : $7f


    sbc A, #$18                                                  ; $2d9a : $a8, $18
    sbc A, [$a8+X]                                                  ; $2d9c : $a7, $a8
    bpl -$5c                                                  ; $2d9e : $10, $a4

    or $a1, #$2f                                                  ; $2da0 : $18, $2f, $a1
    or A, #$7f                                                  ; $2da3 : $08, $7f
    ei                                                  ; $2da5 : $a0
    or $a6, #$9f                                                  ; $2da6 : $18, $9f, $a6
    sbc A, #$a1                                                  ; $2da9 : $a8, $a1
    sbc A, $ab                                                  ; $2dab : $a4, $ab
    bpl $7b                                                  ; $2dad : $10, $7b

    mov1 c, $1f20.3                                                  ; $2daf : $aa, $20, $7f
    sbc $7b, $10                                                  ; $2db2 : $a9, $10, $7b
    sbc A, $08                                                  ; $2db5 : $a4, $08
    sbc A, (X)                                                  ; $2db7 : $a6
    clrv                                                  ; $2db8 : $e0
    or1 c, $1f18.3                                                  ; $2db9 : $0a, $18, $7f
    dec !$87c9                                                  ; $2dbc : $8c, $c9, $87
    mov !$c98c, X                                                  ; $2dbf : $c9, $8c, $c9
    adc A, [$c9+X]                                                  ; $2dc2 : $87, $c9
    adc A, !$8cc9                                                  ; $2dc4 : $85, $c9, $8c
    mov !$c985, X                                                  ; $2dc7 : $c9, $85, $c9
    dec !$e0c9                                                  ; $2dca : $8c, $c9, $e0
    clr1 $e1.0                                                  ; $2dcd : $12, $e1
    bbs $19.0, -$37                                                  ; $2dcf : $03, $19, $c9

    bpl $2f                                                  ; $2dd2 : $10, $2f

    inc $08                                                  ; $2dd4 : $ab, $08
    and $18, $ab                                                  ; $2dd6 : $29, $ab, $18
    mov !$2f10, X                                                  ; $2dd9 : $c9, $10, $2f
    inc $08                                                  ; $2ddc : $ab, $08
    and $18, $ab                                                  ; $2dde : $29, $ab, $18
    mov !$2f10, X                                                  ; $2de1 : $c9, $10, $2f
    inc $08                                                  ; $2de4 : $ab, $08
    and $18, $ab                                                  ; $2de6 : $29, $ab, $18
    mov !$2f10, X                                                  ; $2de9 : $c9, $10, $2f
    inc $08                                                  ; $2dec : $ab, $08
    and $18, $ab                                                  ; $2dee : $29, $ab, $18
    mov !$2f10, X                                                  ; $2df1 : $c9, $10, $2f
    sbc $29, $08                                                  ; $2df4 : $a9, $08, $29
    sbc $c9, $18                                                  ; $2df7 : $a9, $18, $c9
    bpl $2f                                                  ; $2dfa : $10, $2f

    sbc $29, $08                                                  ; $2dfc : $a9, $08, $29
    sbc $c9, $18                                                  ; $2dff : $a9, $18, $c9
    bpl $2f                                                  ; $2e02 : $10, $2f

    sbc $29, $08                                                  ; $2e04 : $a9, $08, $29
    sbc $c9, $18                                                  ; $2e07 : $a9, $18, $c9
    bpl $2f                                                  ; $2e0a : $10, $2f

    sbc $29, $07                                                  ; $2e0c : $a9, $07, $29
    sbc $12, $e0                                                  ; $2e0f : $a9, $e0, $12
    tcall 14                                                  ; $2e12 : $e1
    or A, !$c91a                                                  ; $2e13 : $05, $1a, $c9
    bpl $2f                                                  ; $2e16 : $10, $2f

    sbc A, #$08                                                  ; $2e18 : $a8, $08
    and $18, $a8                                                  ; $2e1a : $29, $a8, $18
    mov !$2f10, X                                                  ; $2e1d : $c9, $10, $2f
    sbc A, #$08                                                  ; $2e20 : $a8, $08
    and $18, $a8                                                  ; $2e22 : $29, $a8, $18
    mov !$2f10, X                                                  ; $2e25 : $c9, $10, $2f
    sbc A, #$08                                                  ; $2e28 : $a8, $08
    and $18, $a8                                                  ; $2e2a : $29, $a8, $18
    mov !$2f10, X                                                  ; $2e2d : $c9, $10, $2f
    sbc A, #$08                                                  ; $2e30 : $a8, $08
    and $18, $a8                                                  ; $2e32 : $29, $a8, $18
    mov !$2f10, X                                                  ; $2e35 : $c9, $10, $2f
    sbc A, (X)                                                  ; $2e38 : $a6
    or A, #$29                                                  ; $2e39 : $08, $29
    sbc A, (X)                                                  ; $2e3b : $a6
    or $10, #$c9                                                  ; $2e3c : $18, $c9, $10
    bra -$5a                                                  ; $2e3f : $2f, $a6

    or A, #$29                                                  ; $2e41 : $08, $29
    sbc A, (X)                                                  ; $2e43 : $a6
    or $10, #$c9                                                  ; $2e44 : $18, $c9, $10
    bra -$5a                                                  ; $2e47 : $2f, $a6

    or A, #$29                                                  ; $2e49 : $08, $29
    sbc A, (X)                                                  ; $2e4b : $a6
    or $10, #$c9                                                  ; $2e4c : $18, $c9, $10
    bra -$5a                                                  ; $2e4f : $2f, $a6

    or A, (X)                                                  ; $2e51 : $06
    and $e0, $a6                                                  ; $2e52 : $29, $a6, $e0
    clr1 $e1.0                                                  ; $2e55 : $12, $e1
    or A, [$ef+X]                                                  ; $2e57 : $07, $ef
    cmp A, !$0234+X                                                  ; $2e59 : $75, $34, $02
    sleep                                                  ; $2e5c : $ef
    adc A, (X)                                                  ; $2e5d : $86
    and A, $02+X                                                  ; $2e5e : $34, $02
    clrv                                                  ; $2e60 : $e0
    clr1 $e1.0                                                  ; $2e61 : $12, $e1
    or A, #$ef                                                  ; $2e63 : $08, $ef
    adc A, [$34]+Y                                                  ; $2e65 : $97, $34
    set1 $18.0                                                  ; $2e67 : $02, $18
    mov !$2f10, X                                                  ; $2e69 : $c9, $10, $2f
    cmp Y, #$08                                                  ; $2e6c : $ad, $08
    and $18, $ad                                                  ; $2e6e : $29, $ad, $18
    mov !$2f10, X                                                  ; $2e71 : $c9, $10, $2f
    cmp Y, #$08                                                  ; $2e74 : $ad, $08
    and $18, $ad                                                  ; $2e76 : $29, $ad, $18
    mov !$2f10, X                                                  ; $2e79 : $c9, $10, $2f
    inc !$2908                                                  ; $2e7c : $ac, $08, $29
    inc !$c918                                                  ; $2e7f : $ac, $18, $c9
    bpl $2f                                                  ; $2e82 : $10, $2f

    inc !$2908                                                  ; $2e84 : $ac, $08, $29
    inc !$d5e0                                                  ; $2e87 : $ac, $e0, $d5
    tcall 14                                                  ; $2e8a : $e1
    brk                                                  ; $2e8b : $0f


    or $a4, #$7f                                                  ; $2e8c : $18, $7f, $a4
    bpl -$5c                                                  ; $2e8f : $10, $a4

    or A, #$a4                                                  ; $2e91 : $08, $a4
    or $10, #$a4                                                  ; $2e93 : $18, $a4, $10
    sbc A, $08                                                  ; $2e96 : $a4, $08
    sbc A, $ef                                                  ; $2e98 : $a4, $ef
    bbc $34.2, $02                                                  ; $2e9a : $53, $34, $02

    or $08, #$a4                                                  ; $2e9d : $18, $a4, $08
    sbc A, $a4                                                  ; $2ea0 : $a4, $a4
    sbc A, $10                                                  ; $2ea2 : $a4, $10
    sbc A, $e0                                                  ; $2ea4 : $a4, $e0
    mov !$a420+Y, A                                                  ; $2ea6 : $d6, $20, $a4
    nop                                                  ; $2ea9 : $00
    clrv                                                  ; $2eaa : $e0
    mov $e1+X,A                                                  ; $2eab : $d4, $e1
    asl !$7f18                                                  ; $2ead : $0c, $18, $7f
    xcn A                                                  ; $2eb0 : $9f
    clrv                                                  ; $2eb1 : $e0
    mov $e1, X                                                  ; $2eb2 : $d8, $e1
    or A, [$a8+X]                                                  ; $2eb4 : $07, $a8
    clrv                                                  ; $2eb6 : $e0
    mov $e1+X,A                                                  ; $2eb7 : $d4, $e1
    asl !$e09f                                                  ; $2eb9 : $0c, $9f, $e0
    mov $e1, X                                                  ; $2ebc : $d8, $e1
    or A, [$a8+X]                                                  ; $2ebe : $07, $a8
    sleep                                                  ; $2ec0 : $ef
    clrc                                                  ; $2ec1 : $60
    and A, $03+X                                                  ; $2ec2 : $34, $03
    clrv                                                  ; $2ec4 : $e0
    bne -$1f                                                  ; $2ec5 : $d0, $e1

    or1 c, $1f48.3                                                  ; $2ec7 : $0a, $48, $7f
    sbc A, #$18                                                  ; $2eca : $a8, $18
    inc $10                                                  ; $2ecc : $ab, $10
    cmp Y, #$08                                                  ; $2ece : $ad, $08
    inc !$7910                                                  ; $2ed0 : $ac, $10, $79
    cmp Y, #$20                                                  ; $2ed3 : $ad, $20
    reti                                                  ; $2ed5 : $7f


    inc $10                                                  ; $2ed6 : $ab, $10
    sbc A, #$08                                                  ; $2ed8 : $a8, $08
    tcall 10                                                  ; $2eda : $a1
    bpl -$57                                                  ; $2edb : $10, $a9

    or A, #$a8                                                  ; $2edd : $08, $a8
    bpl -$5c                                                  ; $2edf : $10, $a4

    or A, #$a1                                                  ; $2ee1 : $08, $a1
    bpl -$37                                                  ; $2ee3 : $10, $c9

    or $a4, #$2f                                                  ; $2ee5 : $18, $2f, $a4
    or A, #$7f                                                  ; $2ee8 : $08, $7f
    sbc A, $30                                                  ; $2eea : $a4, $30
    sbc A, (X)                                                  ; $2eec : $a6
    sbc A, [$18+X]                                                  ; $2eed : $a7, $18
    reti                                                  ; $2eef : $7f


    dec !$87c9                                                  ; $2ef0 : $8c, $c9, $87
    mov !$c989, X                                                  ; $2ef3 : $c9, $89, $c9
    adc A, $c9                                                  ; $2ef6 : $84, $c9
    set1 $c9.4                                                  ; $2ef8 : $82, $c9
    adc $87, $c9                                                  ; $2efa : $89, $c9, $87
    mov !$c987, X                                                  ; $2efd : $c9, $87, $c9
    clrv                                                  ; $2f00 : $e0
    clr1 $e1.0                                                  ; $2f01 : $12, $e1
    or A, $19                                                  ; $2f03 : $04, $19
    mov !$2f10, X                                                  ; $2f05 : $c9, $10, $2f
    inc $08                                                  ; $2f08 : $ab, $08
    inc $18                                                  ; $2f0a : $ab, $18
    mov !$ab10, X                                                  ; $2f0c : $c9, $10, $ab
    or A, #$ab                                                  ; $2f0f : $08, $ab
    or $10, #$c9                                                  ; $2f11 : $18, $c9, $10
    inc $08                                                  ; $2f14 : $ab, $08
    inc $18                                                  ; $2f16 : $ab, $18
    mov !$ab10, X                                                  ; $2f18 : $c9, $10, $ab
    or A, #$ab                                                  ; $2f1b : $08, $ab
    or $10, #$c9                                                  ; $2f1d : $18, $c9, $10
    bcs $08                                                  ; $2f20 : $b0, $08

    bcs $18                                                  ; $2f22 : $b0, $18

    mov !$b010, X                                                  ; $2f24 : $c9, $10, $b0
    or A, #$b0                                                  ; $2f27 : $08, $b0
    or $10, #$b2                                                  ; $2f29 : $18, $b2, $10
    clr1 $08.5                                                  ; $2f2c : $b2, $08
    clr1 $18.5                                                  ; $2f2e : $b2, $18
    bbc $10.5, -$4d                                                  ; $2f30 : $b3, $10, $b3

    or A, [$b3+X]                                                  ; $2f33 : $07, $b3
    clrv                                                  ; $2f35 : $e0
    clr1 $e1.0                                                  ; $2f36 : $12, $e1
    or A, !$c91a                                                  ; $2f38 : $05, $1a, $c9
    bpl $2f                                                  ; $2f3b : $10, $2f

    sbc A, #$08                                                  ; $2f3d : $a8, $08
    sbc A, #$18                                                  ; $2f3f : $a8, $18
    mov !$a810, X                                                  ; $2f41 : $c9, $10, $a8
    or A, #$a8                                                  ; $2f44 : $08, $a8
    or $10, #$c9                                                  ; $2f46 : $18, $c9, $10
    sbc A, #$08                                                  ; $2f49 : $a8, $08
    sbc A, #$18                                                  ; $2f4b : $a8, $18
    mov !$a810, X                                                  ; $2f4d : $c9, $10, $a8
    or A, #$a8                                                  ; $2f50 : $08, $a8
    or $10, #$c9                                                  ; $2f52 : $18, $c9, $10
    cmp Y, #$08                                                  ; $2f55 : $ad, $08
    cmp Y, #$18                                                  ; $2f57 : $ad, $18
    mov !$ad10, X                                                  ; $2f59 : $c9, $10, $ad
    or A, #$ad                                                  ; $2f5c : $08, $ad
    or $10, #$af                                                  ; $2f5e : $18, $af, $10
    mov (X)+, A                                                  ; $2f61 : $af
    or A, #$af                                                  ; $2f62 : $08, $af
    or $10, #$af                                                  ; $2f64 : $18, $af, $10
    mov (X)+, A                                                  ; $2f67 : $af
    or A, (X)                                                  ; $2f68 : $06
    mov (X)+, A                                                  ; $2f69 : $af
    clrv                                                  ; $2f6a : $e0
    clr1 $e1.0                                                  ; $2f6b : $12, $e1
    or A, (X)                                                  ; $2f6d : $06
    or $10, #$c9                                                  ; $2f6e : $18, $c9, $10
    bra -$5a                                                  ; $2f71 : $2f, $a6

    or A, #$a6                                                  ; $2f73 : $08, $a6
    or $10, #$c9                                                  ; $2f75 : $18, $c9, $10
    sbc A, (X)                                                  ; $2f78 : $a6
    or A, #$a6                                                  ; $2f79 : $08, $a6
    or $10, #$c9                                                  ; $2f7b : $18, $c9, $10
    sbc A, (X)                                                  ; $2f7e : $a6
    or A, #$a6                                                  ; $2f7f : $08, $a6
    or $10, #$c9                                                  ; $2f81 : $18, $c9, $10
    sbc A, (X)                                                  ; $2f84 : $a6
    or A, #$a6                                                  ; $2f85 : $08, $a6
    or $10, #$c9                                                  ; $2f87 : $18, $c9, $10
    sbc $a9, $08                                                  ; $2f8a : $a9, $08, $a9
    or $10, #$c9                                                  ; $2f8d : $18, $c9, $10
    sbc $a9, $08                                                  ; $2f90 : $a9, $08, $a9
    or $10, #$ab                                                  ; $2f93 : $18, $ab, $10
    inc $08                                                  ; $2f96 : $ab, $08
    inc $18                                                  ; $2f98 : $ab, $18
    cmp Y, #$10                                                  ; $2f9a : $ad, $10
    cmp Y, #$08                                                  ; $2f9c : $ad, $08
    cmp Y, #$e0                                                  ; $2f9e : $ad, $e0
    mov !$0fe1+X, A                                                  ; $2fa0 : $d5, $e1, $0f
    or $a4, #$7f                                                  ; $2fa3 : $18, $7f, $a4
    clrv                                                  ; $2fa6 : $e0
    mov !$a4a4+Y, A                                                  ; $2fa7 : $d6, $a4, $a4
    sbc A, $e0                                                  ; $2faa : $a4, $e0
    mov !$10a4+X, A                                                  ; $2fac : $d5, $a4, $10
    sbc A, $08                                                  ; $2faf : $a4, $08
    sbc A, $18                                                  ; $2fb1 : $a4, $18
    sbc A, $10                                                  ; $2fb3 : $a4, $10
    sbc A, $08                                                  ; $2fb5 : $a4, $08
    sbc A, $18                                                  ; $2fb7 : $a4, $18
    sbc A, $10                                                  ; $2fb9 : $a4, $10
    sbc A, $08                                                  ; $2fbb : $a4, $08
    sbc A, $18                                                  ; $2fbd : $a4, $18
    sbc A, $10                                                  ; $2fbf : $a4, $10
    sbc A, $08                                                  ; $2fc1 : $a4, $08
    sbc A, $00                                                  ; $2fc3 : $a4, $00
    clrv                                                  ; $2fc5 : $e0
    mov $e1+X,A                                                  ; $2fc6 : $d4, $e1
    asl !$7f18                                                  ; $2fc8 : $0c, $18, $7f
    xcn A                                                  ; $2fcb : $9f
    clrv                                                  ; $2fcc : $e0
    mov $e1, X                                                  ; $2fcd : $d8, $e1
    or A, [$a8+X]                                                  ; $2fcf : $07, $a8
    clrv                                                  ; $2fd1 : $e0
    mov $e1+X,A                                                  ; $2fd2 : $d4, $e1
    asl !$e09f                                                  ; $2fd4 : $0c, $9f, $e0
    mov $e1, X                                                  ; $2fd7 : $d8, $e1
    or A, [$a8+X]                                                  ; $2fd9 : $07, $a8
    sleep                                                  ; $2fdb : $ef
    clrc                                                  ; $2fdc : $60
    and A, $02+X                                                  ; $2fdd : $34, $02
    clrv                                                  ; $2fdf : $e0
    bne -$1f                                                  ; $2fe0 : $d0, $e1

    or1 c, $1f18.3                                                  ; $2fe2 : $0a, $18, $7f
    sbc A, #$a8                                                  ; $2fe5 : $a8, $a8
    sbc $a8, $10                                                  ; $2fe7 : $a9, $10, $a8
    or A, #$a6                                                  ; $2fea : $08, $a6
    or $30, #$a5                                                  ; $2fec : $18, $a5, $30
    tcall 10                                                  ; $2fef : $a1
    or $30, #$ab                                                  ; $2ff0 : $18, $ab, $30
    sbc $18, $a8                                                  ; $2ff3 : $a9, $a8, $18
    reti                                                  ; $2ff6 : $7f


    dec !$8b8c                                                  ; $2ff7 : $8c, $8c, $8b
    eor1 c, $0989.6                                                  ; $2ffa : $8a, $89, $c9
    adc A, $c9                                                  ; $2ffd : $84, $c9
    set1 $c9.4                                                  ; $2fff : $82, $c9
    adc A, [$c9+X]                                                  ; $3001 : $87, $c9
    clrv                                                  ; $3003 : $e0
    clr1 $e1.0                                                  ; $3004 : $12, $e1
    or A, $01                                                  ; $3006 : $04, $01
    mov !$2f18, X                                                  ; $3008 : $c9, $18, $2f
    inc $ab                                                  ; $300b : $ab, $ab
    mov1 c, $09a9.6                                                  ; $300d : $aa, $a9, $c9
    bpl -$55                                                  ; $3010 : $10, $ab

    or A, #$ab                                                  ; $3012 : $08, $ab
    or $10, #$c9                                                  ; $3014 : $18, $c9, $10
    inc $08                                                  ; $3017 : $ab, $08
    inc $18                                                  ; $3019 : $ab, $18
    mov !$ab10, X                                                  ; $301b : $c9, $10, $ab
    or A, #$ab                                                  ; $301e : $08, $ab
    or $10, #$c9                                                  ; $3020 : $18, $c9, $10
    inc $07                                                  ; $3023 : $ab, $07
    inc $e0                                                  ; $3025 : $ab, $e0
    clr1 $e1.0                                                  ; $3027 : $12, $e1
    or A, !$c902                                                  ; $3029 : $05, $02, $c9
    or $a8, #$2f                                                  ; $302c : $18, $2f, $a8
    sbc A, #$a7                                                  ; $302f : $a8, $a7
    sbc A, $c9                                                  ; $3031 : $a4, $c9
    bpl -$5b                                                  ; $3033 : $10, $a5

    or A, #$a5                                                  ; $3035 : $08, $a5
    or $10, #$c9                                                  ; $3037 : $18, $c9, $10
    sbc A, !$a508                                                  ; $303a : $a5, $08, $a5
    or $10, #$c9                                                  ; $303d : $18, $c9, $10
    sbc $a9, $08                                                  ; $3040 : $a9, $08, $a9
    or $10, #$c9                                                  ; $3043 : $18, $c9, $10
    sbc $a9, $06                                                  ; $3046 : $a9, $06, $a9
    clrv                                                  ; $3049 : $e0
    clr1 $e1.0                                                  ; $304a : $12, $e1
    or A, (X)                                                  ; $304c : $06
    or $a6, #$2f                                                  ; $304d : $18, $2f, $a6
    sbc A, (X)                                                  ; $3050 : $a6
    sbc A, !$c9a2                                                  ; $3051 : $a5, $a2, $c9
    bpl -$5f                                                  ; $3054 : $10, $a1

    or A, #$a1                                                  ; $3056 : $08, $a1
    or $10, #$c9                                                  ; $3058 : $18, $c9, $10
    tcall 10                                                  ; $305b : $a1
    or A, #$a1                                                  ; $305c : $08, $a1
    or $10, #$c9                                                  ; $305e : $18, $c9, $10
    sbc A, (X)                                                  ; $3061 : $a6
    or A, #$a6                                                  ; $3062 : $08, $a6
    or $10, #$c9                                                  ; $3064 : $18, $c9, $10
    sbc A, (X)                                                  ; $3067 : $a6
    or A, #$a6                                                  ; $3068 : $08, $a6
    clrv                                                  ; $306a : $e0
    clr1 $e1.0                                                  ; $306b : $12, $e1
    set1 $01.0                                                  ; $306d : $02, $01
    mov !$2f18, X                                                  ; $306f : $c9, $18, $2f
    bcs -$50                                                  ; $3072 : $b0, $b0

    mov (X)+, A                                                  ; $3074 : $af
    pop A                                                  ; $3075 : $ae
    mov !$ad10, X                                                  ; $3076 : $c9, $10, $ad
    or A, #$ad                                                  ; $3079 : $08, $ad
    or $10, #$c9                                                  ; $307b : $18, $c9, $10
    cmp Y, #$08                                                  ; $307e : $ad, $08
    cmp Y, #$18                                                  ; $3080 : $ad, $18
    mov !$b010, X                                                  ; $3082 : $c9, $10, $b0
    or A, #$b0                                                  ; $3085 : $08, $b0
    or $10, #$c9                                                  ; $3087 : $18, $c9, $10
    mov (X)+, A                                                  ; $308a : $af
    or A, [$af+X]                                                  ; $308b : $07, $af
    clrv                                                  ; $308d : $e0
    mov !$7f18+Y, A                                                  ; $308e : $d6, $18, $7f
    sbc A, $48                                                  ; $3091 : $a4, $48
    mov !$e000, X                                                  ; $3093 : $c9, $00, $e0
    mov $e1, X                                                  ; $3096 : $d8, $e1
    or A, [$18+X]                                                  ; $3098 : $07, $18
    reti                                                  ; $309a : $7f


    sbc A, #$ed                                                  ; $309b : $a8, $ed
    bvc -$12                                                  ; $309d : $50, $ee

    eor A, #$b4                                                  ; $309f : $48, $b4
    or A, #$a8                                                  ; $30a1 : $08, $a8
    sbc A, #$a8                                                  ; $30a3 : $a8, $a8
    sbc A, #$a8                                                  ; $30a5 : $a8, $a8
    sbc A, #$a8                                                  ; $30a7 : $a8, $a8
    sbc A, #$a8                                                  ; $30a9 : $a8, $a8
    clrv                                                  ; $30ab : $e0
    bne -$1f                                                  ; $30ac : $d0, $e1

    or1 c, $1f30.3                                                  ; $30ae : $0a, $30, $7f
    sbc A, $c9                                                  ; $30b1 : $a4, $c9
    or $8c, #$7f                                                  ; $30b3 : $18, $7f, $8c
    dec !$8482                                                  ; $30b6 : $8c, $82, $84
    tcall 0                                                  ; $30b9 : $01
    mov !$2f18, X                                                  ; $30ba : $c9, $18, $2f
    inc $47                                                  ; $30bd : $ab, $47
    mov !$c902, X                                                  ; $30bf : $c9, $02, $c9
    or $a8, #$2f                                                  ; $30c2 : $18, $2f, $a8
    eor A, (X)                                                  ; $30c5 : $46
    mov !$2f18, X                                                  ; $30c6 : $c9, $18, $2f
    sbc A, (X)                                                  ; $30c9 : $a6
    eor A, #$c9                                                  ; $30ca : $48, $c9
    clrv                                                  ; $30cc : $e0
    mov !$7f18+X, A                                                  ; $30cd : $d5, $18, $7f
    sbc A, $10                                                  ; $30d0 : $a4, $10
    mov !$d6e0, X                                                  ; $30d2 : $c9, $e0, $d6
    or $20, #$a4                                                  ; $30d5 : $18, $a4, $20
    mov !$e000, X                                                  ; $30d8 : $c9, $00, $e0
    mov $e1+X,A                                                  ; $30db : $d4, $e1
    asl !$7f10                                                  ; $30dd : $0c, $10, $7f
    xcn A                                                  ; $30e0 : $9f
    clrv                                                  ; $30e1 : $e0
    mov $e1, X                                                  ; $30e2 : $d8, $e1
    or A, [$08+X]                                                  ; $30e4 : $07, $08
    sbc A, #$e0                                                  ; $30e6 : $a8, $e0
    mov $e1+X,A                                                  ; $30e8 : $d4, $e1
    asl !$9f10                                                  ; $30ea : $0c, $10, $9f
    or A, #$9f                                                  ; $30ed : $08, $9f
    bpl -$37                                                  ; $30ef : $10, $c9

    clrv                                                  ; $30f1 : $e0
    mov $e1, X                                                  ; $30f2 : $d8, $e1
    or A, [$08+X]                                                  ; $30f4 : $07, $08
    ror $a8+X                                                  ; $30f6 : $7b, $a8
    or A, #$7f                                                  ; $30f8 : $08, $7f
    sbc A, #$a8                                                  ; $30fa : $a8, $a8
    sbc A, #$e0                                                  ; $30fc : $a8, $e0
    bne -$1f                                                  ; $30fe : $d0, $e1

    or1 c, $1f28.3                                                  ; $3100 : $0a, $28, $7f
    sbc A, $08                                                  ; $3103 : $a4, $08
    sbc A, $30                                                  ; $3105 : $a4, $30
    mov !$7f10, X                                                  ; $3107 : $c9, $10, $7f
    dec !$8608                                                  ; $310a : $8c, $08, $86
    bpl -$79                                                  ; $310d : $10, $87

    or A, #$8c                                                  ; $310f : $08, $8c
    bpl -$37                                                  ; $3111 : $10, $c9

    or $08, #$8c                                                  ; $3113 : $18, $8c, $08
    dec !$c901                                                  ; $3116 : $8c, $01, $c9
    and A, #$2f                                                  ; $3119 : $28, $2f
    inc $08                                                  ; $311b : $ab, $08
    bcs $2f                                                  ; $311d : $b0, $2f

    mov !$c902, X                                                  ; $311f : $c9, $02, $c9
    and A, #$2f                                                  ; $3122 : $28, $2f
    sbc A, #$08                                                  ; $3124 : $a8, $08
    inc $2e                                                  ; $3126 : $ab, $2e
    mov !$2f28, X                                                  ; $3128 : $c9, $28, $2f
    sbc A, (X)                                                  ; $312b : $a6
    or A, #$a8                                                  ; $312c : $08, $a8
    bmi -$37                                                  ; $312e : $30, $c9

    clrv                                                  ; $3130 : $e0
    mov !$0fe1+Y, A                                                  ; $3131 : $d6, $e1, $0f
    notc                                                  ; $3134 : $ed
    cmp A, $18                                                  ; $3135 : $64, $18
    reti                                                  ; $3137 : $7f


    sbc A, $a4                                                  ; $3138 : $a4, $a4
    sbc A, $a4                                                  ; $313a : $a4, $a4
    sleep                                                  ; $313c : $ef
    sbc A, #$34                                                  ; $313d : $a8, $34
    or A, !$d5e0                                                  ; $313f : $05, $e0, $d5
    notc                                                  ; $3142 : $ed
    sbc A, $a4+X                                                  ; $3143 : $b4, $a4
    mov !$c9a4, X                                                  ; $3145 : $c9, $a4, $c9
    clrv                                                  ; $3148 : $e0
    mov !$a4a4+Y, A                                                  ; $3149 : $d6, $a4, $a4
    sbc A, $e0                                                  ; $314c : $a4, $e0
    mov !$00a4+X, A                                                  ; $314e : $d5, $a4, $00
    clrv                                                  ; $3151 : $e0
    mov $e1+X,A                                                  ; $3152 : $d4, $e1
    asl !$7f18                                                  ; $3154 : $0c, $18, $7f
    xcn A                                                  ; $3157 : $9f
    clrv                                                  ; $3158 : $e0
    mov $e1, X                                                  ; $3159 : $d8, $e1
    or A, [$a8+X]                                                  ; $315b : $07, $a8
    clrv                                                  ; $315d : $e0
    mov $e1+X,A                                                  ; $315e : $d4, $e1
    asl !$9f10                                                  ; $3160 : $0c, $10, $9f
    or A, #$9f                                                  ; $3163 : $08, $9f
    clrv                                                  ; $3165 : $e0
    mov $e1, X                                                  ; $3166 : $d8, $e1
    or A, [$18+X]                                                  ; $3168 : $07, $18
    sbc A, #$ef                                                  ; $316a : $a8, $ef
    cmp Y, #$34                                                  ; $316c : $ad, $34
    set1 $e0.0                                                  ; $316e : $02, $e0
    mov $e1+X,A                                                  ; $3170 : $d4, $e1
    asl !$e09f                                                  ; $3172 : $0c, $9f, $e0
    mov $e1, X                                                  ; $3175 : $d8, $e1
    or A, [$a8+X]                                                  ; $3177 : $07, $a8
    clrv                                                  ; $3179 : $e0
    mov $e1+X,A                                                  ; $317a : $d4, $e1
    asl !$9f10                                                  ; $317c : $0c, $10, $9f
    or A, #$9f                                                  ; $317f : $08, $9f
    clrv                                                  ; $3181 : $e0
    mov $e1, X                                                  ; $3182 : $d8, $e1
    or A, [$10+X]                                                  ; $3184 : $07, $10
    sbc A, #$08                                                  ; $3186 : $a8, $08
    sbc A, #$e0                                                  ; $3188 : $a8, $e0
    mov $e1+X,A                                                  ; $318a : $d4, $e1
    asl !$9f18                                                  ; $318c : $0c, $18, $9f
    clrv                                                  ; $318f : $e0
    mov $e1, X                                                  ; $3190 : $d8, $e1
    or A, [$a8+X]                                                  ; $3192 : $07, $a8
    clrv                                                  ; $3194 : $e0
    mov $e1+X,A                                                  ; $3195 : $d4, $e1
    asl !$9f10                                                  ; $3197 : $0c, $10, $9f
    or A, #$9f                                                  ; $319a : $08, $9f
    clrv                                                  ; $319c : $e0
    mov $e1, X                                                  ; $319d : $d8, $e1
    or A, [$18+X]                                                  ; $319f : $07, $18
    sbc A, #$ef                                                  ; $31a1 : $a8, $ef
    cmp Y, #$34                                                  ; $31a3 : $ad, $34
    bbs $e0.0, -$2f                                                  ; $31a5 : $03, $e0, $d1

    bbs $14.7, $14                                                  ; $31a8 : $e3, $14, $14

    clr1 $e1.1                                                  ; $31ab : $32, $e1
    or $7f, $10                                                  ; $31ad : $09, $10, $7f
    tcall 10                                                  ; $31b0 : $a1
    or A, #$a4                                                  ; $31b1 : $08, $a4
    bpl -$5a                                                  ; $31b3 : $10, $a6

    and $10, #$a8                                                  ; $31b5 : $38, $a8, $10
    tcall 10                                                  ; $31b8 : $a1
    or A, #$a4                                                  ; $31b9 : $08, $a4
    bpl -$5a                                                  ; $31bb : $10, $a6

    clrp                                                  ; $31bd : $20
    sbc A, [$10+X]                                                  ; $31be : $a7, $10
    sbc A, (X)                                                  ; $31c0 : $a6
    or A, #$a4                                                  ; $31c1 : $08, $a4
    bpl -$58                                                  ; $31c3 : $10, $a8

    or A, #$9f                                                  ; $31c5 : $08, $9f
    bpl -$58                                                  ; $31c7 : $10, $a8

    or A, #$a9                                                  ; $31c9 : $08, $a9
    or $ab, #$aa                                                  ; $31cb : $18, $aa, $ab
    pop A                                                  ; $31ce : $ae
    bpl -$53                                                  ; $31cf : $10, $ad

    clrp                                                  ; $31d1 : $20
    inc $18                                                  ; $31d2 : $ab, $18
    mov !$d3e0, X                                                  ; $31d4 : $c9, $e0, $d3
    tcall 14                                                  ; $31d7 : $e1
    asl $10                                                  ; $31d8 : $0b, $10
    cmp Y, #$08                                                  ; $31da : $ad, $08
    bcs $10                                                  ; $31dc : $b0, $10

    clr1 $38.5                                                  ; $31de : $b2, $38
    sbc A, $10+X                                                  ; $31e0 : $b4, $10
    cmp Y, #$08                                                  ; $31e2 : $ad, $08
    bcs $18                                                  ; $31e4 : $b0, $18

    bbc $10.5, -$4e                                                  ; $31e6 : $b3, $10, $b2

    clrp                                                  ; $31e9 : $20
    bcs $08                                                  ; $31ea : $b0, $08

    mov (X)+, A                                                  ; $31ec : $af
    bcs -$4f                                                  ; $31ed : $b0, $b1

    asl !$c9b2                                                  ; $31ef : $0c, $b2, $c9
    clrv                                                  ; $31f2 : $e0
    tcall 13                                                  ; $31f3 : $d1
    tcall 14                                                  ; $31f4 : $e1
    or $ab, $08                                                  ; $31f5 : $09, $08, $ab
    cmp Y, #$ae                                                  ; $31f8 : $ad, $ae
    asl !$c9af                                                  ; $31fa : $0c, $af, $c9
    clrv                                                  ; $31fd : $e0
    bbc $e1.6, $0b                                                  ; $31fe : $d3, $e1, $0b

    or A, #$b7                                                  ; $3201 : $08, $b7
    sbc A, !$b4b5+Y                                                  ; $3203 : $b6, $b5, $b4
    bbc $b2.5, $18                                                  ; $3206 : $b3, $b2, $18

    bra -$51                                                  ; $3209 : $2f, $af

    sbc A, [$18]+Y                                                  ; $320b : $b7, $18
    reti                                                  ; $320d : $7f


    adc A, !$8c89                                                  ; $320e : $85, $89, $8c
    pop PSW                                                  ; $3211 : $8e
    mov $8c, #$8e                                                  ; $3212 : $8f, $8e, $8c
    adc $8c, $87                                                  ; $3215 : $89, $87, $8c
    adc A, $87                                                  ; $3218 : $84, $87
    bpl -$76                                                  ; $321a : $10, $8a

    or A, #$8c                                                  ; $321c : $08, $8c
    or $87, #$89                                                  ; $321e : $18, $89, $87
    adc A, $85                                                  ; $3221 : $84, $85
    adc $8e, $8c                                                  ; $3223 : $89, $8c, $8e
    mov $8c, #$8e                                                  ; $3226 : $8f, $8e, $8c
    adc $c9, $87                                                  ; $3229 : $89, $87, $c9
    adc A, [$c9+X]                                                  ; $322c : $87, $c9
    or A, #$87                                                  ; $322e : $08, $87
    adc A, #$89                                                  ; $3230 : $88, $89
    dec $8c                                                  ; $3232 : $8b, $8c
    mov Y, #$10                                                  ; $3234 : $8d, $10
    pop PSW                                                  ; $3236 : $8e
    or A, #$c9                                                  ; $3237 : $08, $c9
    or $e0, #$87                                                  ; $3239 : $18, $87, $e0
    tcall 13                                                  ; $323c : $d1
    bbs $14.7, $18                                                  ; $323d : $e3, $14, $18

    clr1 $e1.1                                                  ; $3240 : $32, $e1
    asl $10                                                  ; $3242 : $0b, $10
    cmp A, !$089c+X                                                  ; $3244 : $75, $9c, $08
    xcn A                                                  ; $3247 : $9f
    bpl -$5f                                                  ; $3248 : $10, $a1

    and $10, #$a3                                                  ; $324a : $38, $a3, $10
    dec A                                                  ; $324d : $9c
    or A, #$9f                                                  ; $324e : $08, $9f
    bpl -$5f                                                  ; $3250 : $10, $a1

    clrp                                                  ; $3252 : $20
    set1 $10.5                                                  ; $3253 : $a2, $10
    tcall 10                                                  ; $3255 : $a1
    or A, #$9f                                                  ; $3256 : $08, $9f
    bpl -$5d                                                  ; $3258 : $10, $a3

    or A, #$9a                                                  ; $325a : $08, $9a
    bpl -$5d                                                  ; $325c : $10, $a3

    or A, #$a4                                                  ; $325e : $08, $a4
    or $a6, #$a5                                                  ; $3260 : $18, $a5, $a6
    sbc $a8, $10                                                  ; $3263 : $a9, $10, $a8
    clrp                                                  ; $3266 : $20
    sbc A, (X)                                                  ; $3267 : $a6
    or $e0, #$c9                                                  ; $3268 : $18, $c9, $e0
    bbc $e1.6, $0b                                                  ; $326b : $d3, $e1, $0b

    bpl -$58                                                  ; $326e : $10, $a8

    or A, #$ab                                                  ; $3270 : $08, $ab
    bpl -$53                                                  ; $3272 : $10, $ad

    and $10, #$af                                                  ; $3274 : $38, $af, $10
    sbc A, #$08                                                  ; $3277 : $a8, $08
    inc $18                                                  ; $3279 : $ab, $18
    pop A                                                  ; $327b : $ae
    bpl -$53                                                  ; $327c : $10, $ad

    clrp                                                  ; $327e : $20
    inc $08                                                  ; $327f : $ab, $08
    mov1 c, $0cab.5                                                  ; $3281 : $aa, $ab, $ac
    asl !$c9ad                                                  ; $3284 : $0c, $ad, $c9
    clrv                                                  ; $3287 : $e0
    tcall 13                                                  ; $3288 : $d1
    tcall 14                                                  ; $3289 : $e1
    or $a6, $08                                                  ; $328a : $09, $08, $a6
    sbc A, #$a9                                                  ; $328d : $a8, $a9
    asl !$c9aa                                                  ; $328f : $0c, $aa, $c9
    clrv                                                  ; $3292 : $e0
    bbc $e1.6, $0b                                                  ; $3293 : $d3, $e1, $0b

    or A, #$7f                                                  ; $3296 : $08, $7f
    clr1 $b1.5                                                  ; $3298 : $b2, $b1
    bcs -$51                                                  ; $329a : $b0, $af

    pop A                                                  ; $329c : $ae
    cmp Y, #$18                                                  ; $329d : $ad, $18
    bra -$57                                                  ; $329f : $2f, $a9

    sbc A, !$18e0+X                                                  ; $32a1 : $b5, $e0, $18
    tcall 14                                                  ; $32a4 : $e1
    asl !$01eb                                                  ; $32a5 : $0c, $eb, $01
    clr1 $3c.1                                                  ; $32a8 : $32, $3c
    notc                                                  ; $32aa : $ed
    dec !$c910                                                  ; $32ab : $8c, $10, $c9
    or A, #$7f                                                  ; $32ae : $08, $7f
    tcall 10                                                  ; $32b0 : $a1
    or $28, #$c9                                                  ; $32b1 : $18, $c9, $28
    tcall 10                                                  ; $32b4 : $a1
    or A, #$c9                                                  ; $32b5 : $08, $c9
    sleep                                                  ; $32b7 : $ef
    mov (X), A                                                  ; $32b8 : $c6
    and A, $02+X                                                  ; $32b9 : $34, $02
    or $10, #$a2                                                  ; $32bb : $18, $a2, $10
    mov !$a230, X                                                  ; $32be : $c9, $30, $a2
    or A, #$c9                                                  ; $32c1 : $08, $c9
    sleep                                                  ; $32c3 : $ef
    mul YA                                                  ; $32c4 : $cf
    and A, $02+X                                                  ; $32c5 : $34, $02
    or $9f, #$2f                                                  ; $32c7 : $18, $2f, $9f
    mov !$c99d, X                                                  ; $32ca : $c9, $9d, $c9
    clrv                                                  ; $32cd : $e0
    tcall 13                                                  ; $32ce : $d1
    bbs $14.7, $18                                                  ; $32cf : $e3, $14, $18

    clr1 $e1.1                                                  ; $32d2 : $32, $e1
    or $b4, $ed                                                  ; $32d4 : $09, $ed, $b4
    or A, #$7f                                                  ; $32d7 : $08, $7f
    mov (X)+, A                                                  ; $32d9 : $af
    pop A                                                  ; $32da : $ae
    cmp Y, #$ab                                                  ; $32db : $ad, $ab
    mov1 c, $18a9.0                                                  ; $32dd : $aa, $a9, $18
    bra -$57                                                  ; $32e0 : $2f, $a9

    mov !$b4ed, X                                                  ; $32e2 : $c9, $ed, $b4
    clrv                                                  ; $32e5 : $e0
    or $09, #$e1                                                  ; $32e6 : $18, $e1, $09
    mov Y, $01                                                  ; $32e9 : $eb, $01
    clr1 $3c.1                                                  ; $32eb : $32, $3c
    notc                                                  ; $32ed : $ed
    dec !$c910                                                  ; $32ee : $8c, $10, $c9
    or A, #$7f                                                  ; $32f1 : $08, $7f
    sbc A, (X)                                                  ; $32f3 : $a6
    or $28, #$c9                                                  ; $32f4 : $18, $c9, $28
    sbc A, (X)                                                  ; $32f7 : $a6
    or A, #$c9                                                  ; $32f8 : $08, $c9
    sleep                                                  ; $32fa : $ef
    movw $34, YA                                                  ; $32fb : $da, $34
    set1 $18.0                                                  ; $32fd : $02, $18
    sbc A, (X)                                                  ; $32ff : $a6
    bpl -$37                                                  ; $3300 : $10, $c9

    bmi -$5a                                                  ; $3302 : $30, $a6

    or A, #$c9                                                  ; $3304 : $08, $c9
    bpl -$37                                                  ; $3306 : $10, $c9

    or A, #$a6                                                  ; $3308 : $08, $a6
    or $28, #$c9                                                  ; $330a : $18, $c9, $28
    sbc A, (X)                                                  ; $330d : $a6
    or A, #$c9                                                  ; $330e : $08, $c9
    bpl -$37                                                  ; $3310 : $10, $c9

    or A, #$a4                                                  ; $3312 : $08, $a4
    or $28, #$c9                                                  ; $3314 : $18, $c9, $28
    sbc A, $08                                                  ; $3317 : $a4, $08
    mov !$2f18, X                                                  ; $3319 : $c9, $18, $2f
    sbc A, (X)                                                  ; $331c : $a6
    mov !$c9a3, X                                                  ; $331d : $c9, $a3, $c9
    or A, #$7f                                                  ; $3320 : $08, $7f
    inc $aa                                                  ; $3322 : $ab, $aa
    sbc $a7, $a8                                                  ; $3324 : $a9, $a8, $a7
    sbc A, (X)                                                  ; $3327 : $a6
    or $a3, #$2f                                                  ; $3328 : $18, $2f, $a3
    inc $ed                                                  ; $332b : $ab, $ed
    sbc A, $e0+X                                                  ; $332d : $b4, $e0
    or $07, #$e1                                                  ; $332f : $18, $e1, $07
    mov Y, $01                                                  ; $3332 : $eb, $01
    clr1 $3c.1                                                  ; $3334 : $32, $3c
    notc                                                  ; $3336 : $ed
    dec !$c910                                                  ; $3337 : $8c, $10, $c9
    or A, #$7f                                                  ; $333a : $08, $7f
    inc $18                                                  ; $333c : $ab, $18
    mov !$ab28, X                                                  ; $333e : $c9, $28, $ab
    or A, #$c9                                                  ; $3341 : $08, $c9
    bpl -$37                                                  ; $3343 : $10, $c9

    or A, #$aa                                                  ; $3345 : $08, $aa
    or $30, #$c9                                                  ; $3347 : $18, $c9, $30
    mov1 c, $0910.6                                                  ; $334a : $aa, $10, $c9
    or A, #$ab                                                  ; $334d : $08, $ab
    or $30, #$c9                                                  ; $334f : $18, $c9, $30
    inc $18                                                  ; $3352 : $ab, $18
    inc $10                                                  ; $3354 : $ab, $10
    mov !$ab30, X                                                  ; $3356 : $c9, $30, $ab
    or A, #$c9                                                  ; $3359 : $08, $c9
    bpl -$37                                                  ; $335b : $10, $c9

    or A, #$ab                                                  ; $335d : $08, $ab
    or $28, #$c9                                                  ; $335f : $18, $c9, $28
    inc $08                                                  ; $3362 : $ab, $08
    mov !$c910, X                                                  ; $3364 : $c9, $10, $c9
    or A, #$a7                                                  ; $3367 : $08, $a7
    or $28, #$c9                                                  ; $3369 : $18, $c9, $28
    sbc A, [$08+X]                                                  ; $336c : $a7, $08
    mov !$2f18, X                                                  ; $336e : $c9, $18, $2f
    sbc $a7, $c9                                                  ; $3371 : $a9, $c9, $a7
    mov !$7f08, X                                                  ; $3374 : $c9, $08, $7f
    bbs $a2.5, -$5f                                                  ; $3377 : $a3, $a2, $a1

    xcn A                                                  ; $337a : $9f
    div YA, X                                                  ; $337b : $9e
    mov X, SP                                                  ; $337c : $9d
    or $9a, #$2f                                                  ; $337d : $18, $2f, $9a
    sbc A, (X)                                                  ; $3380 : $a6
    notc                                                  ; $3381 : $ed
    sbc A, $e0+X                                                  ; $3382 : $b4, $e0
    or A, $e1+X                                                  ; $3384 : $14, $e1
    or A, [$03+X]                                                  ; $3386 : $07, $03
    reti                                                  ; $3388 : $7f


    sbc A, #$a8                                                  ; $3389 : $a8, $a8
    sbc A, #$a8                                                  ; $338b : $a8, $a8
    sbc A, #$a8                                                  ; $338d : $a8, $a8
    sbc A, #$a8                                                  ; $338f : $a8, $a8
    sbc A, #$a8                                                  ; $3391 : $a8, $a8
    sbc A, #$a8                                                  ; $3393 : $a8, $a8
    sbc A, #$a8                                                  ; $3395 : $a8, $a8
    sbc A, #$a8                                                  ; $3397 : $a8, $a8
    or $c9, #$a8                                                  ; $3399 : $18, $a8, $c9
    nop                                                  ; $339c : $00
    mov $e7, $27                                                  ; $339d : $fa, $27, $e7
    set1 $e5.1                                                  ; $33a0 : $22, $e5
    sbc A, $ed+X                                                  ; $33a2 : $b4, $ed
    eor A, (X)                                                  ; $33a4 : $46
    mov A, !$280c+X                                                  ; $33a5 : $f5, $0c, $28
    and A, #$f7                                                  ; $33a8 : $28, $f7
    set1 $5a.0                                                  ; $33aa : $02, $5a
    set1 $ee.0                                                  ; $33ac : $02, $ee
    bmi -$24                                                  ; $33ae : $30, $dc

    tcall 14                                                  ; $33b0 : $e1
    tcall 1                                                  ; $33b1 : $11
    clrv                                                  ; $33b2 : $e0
    movw $60, YA                                                  ; $33b3 : $da, $60
    reti                                                  ; $33b5 : $7f


    ei                                                  ; $33b6 : $a0
    bmi -$38                                                  ; $33b7 : $30, $c8

    pop Y                                                  ; $33b9 : $ee
    bvc $46                                                  ; $33ba : $50, $46

    clrc                                                  ; $33bc : $60
    cmp X, #$ed                                                  ; $33bd : $c8, $ed
    sbc A, $18+X                                                  ; $33bf : $b4, $18
    mov !$c9c9, X                                                  ; $33c1 : $c9, $c9, $c9
    nop                                                  ; $33c4 : $00
    notc                                                  ; $33c5 : $ed
    rol A                                                  ; $33c6 : $3c
    clrv                                                  ; $33c7 : $e0
    movw $e1, YA                                                  ; $33c8 : $da, $e1
    asl !$28ee                                                  ; $33ca : $0c, $ee, $28
    dec Y                                                  ; $33cd : $dc
    clrc                                                  ; $33ce : $60
    reti                                                  ; $33cf : $7f


    dec A                                                  ; $33d0 : $9c
    bmi -$38                                                  ; $33d1 : $30, $c8

    pop Y                                                  ; $33d3 : $ee
    push X                                                  ; $33d4 : $4d
    tcall 2                                                  ; $33d5 : $21
    clrc                                                  ; $33d6 : $60
    cmp X, #$ed                                                  ; $33d7 : $c8, $ed
    sbc A, $18+X                                                  ; $33d9 : $b4, $18
    mov !$c9c9, X                                                  ; $33db : $c9, $c9, $c9
    notc                                                  ; $33de : $ed
    sbc A, $e0+X                                                  ; $33df : $b4, $e0
    bne -$1f                                                  ; $33e1 : $d0, $e1

    or1 c, $0960.6                                                  ; $33e3 : $0a, $60, $c9
    mov !$c918, X                                                  ; $33e6 : $c9, $18, $c9
    mov !$c9c9, X                                                  ; $33e9 : $c9, $c9, $c9
    mov !$c8ed, X                                                  ; $33ec : $c9, $ed, $c8
    tcall 14                                                  ; $33ef : $e1
    or1 c, $0ae0.0                                                  ; $33f0 : $0a, $e0, $0a
    clrc                                                  ; $33f3 : $60
    mov !$18c9, X                                                  ; $33f4 : $c9, $c9, $18
    mov !$c9c9, X                                                  ; $33f7 : $c9, $c9, $c9
    mov !$edc9, X                                                  ; $33fa : $c9, $c9, $ed
    clr1 $ee.1                                                  ; $33fd : $32, $ee
    rol A                                                  ; $33ff : $3c
    dec Y                                                  ; $3400 : $dc
    clrv                                                  ; $3401 : $e0
    movw $e1, YA                                                  ; $3402 : $da, $e1
    bbs $60.0, $7f                                                  ; $3404 : $03, $60, $7f

    mov X, SP                                                  ; $3407 : $9d
    bmi -$38                                                  ; $3408 : $30, $c8

    pop Y                                                  ; $340a : $ee
    eor $60, #$14                                                  ; $340b : $58, $14, $60
    cmp X, #$ed                                                  ; $340e : $c8, $ed
    sbc A, $18+X                                                  ; $3410 : $b4, $18
    mov !$c9c9, X                                                  ; $3412 : $c9, $c9, $c9
    notc                                                  ; $3415 : $ed
    sbc A, $e1+X                                                  ; $3416 : $b4, $e1
    brk                                                  ; $3418 : $0f


    clrv                                                  ; $3419 : $e0
    mov !$c960+X, A                                                  ; $341a : $d5, $60, $c9
    or $ed, #$c9                                                  ; $341d : $18, $c9, $ed
    dec Y                                                  ; $3420 : $dc
    or $a4, #$7f                                                  ; $3421 : $18, $7f, $a4
    mov !$c9a4, X                                                  ; $3424 : $c9, $a4, $c9
    notc                                                  ; $3427 : $ed
    sbc A, $e0+X                                                  ; $3428 : $b4, $e0
    mov !$a4a4+Y, A                                                  ; $342a : $d6, $a4, $a4
    sbc A, $a4                                                  ; $342d : $a4, $a4
    clrv                                                  ; $342f : $e0
    bbc $e1.6, $0a                                                  ; $3430 : $d3, $e1, $0a

    notc                                                  ; $3433 : $ed
    dec $50+X                                                  ; $3434 : $9b, $50
    mov !$1818, X                                                  ; $3436 : $c9, $18, $18
    di                                                  ; $3439 : $c0
    mov X, $02+Y                                                  ; $343a : $f9, $02
    or1 c, $14ab.0                                                  ; $343c : $0a, $ab, $14
    jmp [!$f9b9+X]                                                  ; $343f : $1f, $b9, $f9


    nop                                                  ; $3442 : $00
    or1 c, $18c3.0                                                  ; $3443 : $0a, $c3, $18
    sbc (X), (Y)                                                  ; $3446 : $b9
    mov X, $00+Y                                                  ; $3447 : $f9, $00
    or1 c, $00c3.3                                                  ; $3449 : $0a, $c3, $60
    mov !$c918, X                                                  ; $344c : $c9, $18, $c9
    mov !$c914, X                                                  ; $344f : $c9, $14, $c9
    nop                                                  ; $3452 : $00
    or $10, #$a4                                                  ; $3453 : $18, $a4, $10
    sbc A, $08                                                  ; $3456 : $a4, $08
    sbc A, $18                                                  ; $3458 : $a4, $18
    sbc A, $10                                                  ; $345a : $a4, $10
    sbc A, $08                                                  ; $345c : $a4, $08
    sbc A, $00                                                  ; $345e : $a4, $00
    clrv                                                  ; $3460 : $e0
    mov $e1+X,A                                                  ; $3461 : $d4, $e1
    asl !$e09f                                                  ; $3463 : $0c, $9f, $e0
    mov $e1, X                                                  ; $3466 : $d8, $e1
    or A, [$a8+X]                                                  ; $3468 : $07, $a8
    clrv                                                  ; $346a : $e0
    mov $e1+X,A                                                  ; $346b : $d4, $e1
    asl !$e09f                                                  ; $346d : $0c, $9f, $e0
    mov $e1, X                                                  ; $3470 : $d8, $e1
    or A, [$a8+X]                                                  ; $3472 : $07, $a8
    nop                                                  ; $3474 : $00
    or $10, #$c9                                                  ; $3475 : $18, $c9, $10
    bra -$5a                                                  ; $3478 : $2f, $a6

    or A, #$29                                                  ; $347a : $08, $29
    sbc A, (X)                                                  ; $347c : $a6
    or $10, #$c9                                                  ; $347d : $18, $c9, $10
    bra -$5a                                                  ; $3480 : $2f, $a6

    or A, #$29                                                  ; $3482 : $08, $29
    sbc A, (X)                                                  ; $3484 : $a6
    nop                                                  ; $3485 : $00
    or $10, #$c9                                                  ; $3486 : $18, $c9, $10
    bra -$5c                                                  ; $3489 : $2f, $a4

    or A, #$29                                                  ; $348b : $08, $29
    sbc A, $18                                                  ; $348d : $a4, $18
    mov !$2f10, X                                                  ; $348f : $c9, $10, $2f
    sbc A, $08                                                  ; $3492 : $a4, $08
    and $00, $a4                                                  ; $3494 : $29, $a4, $00
    or $10, #$c9                                                  ; $3497 : $18, $c9, $10
    bra -$50                                                  ; $349a : $2f, $b0

    or A, #$29                                                  ; $349c : $08, $29
    bcs $18                                                  ; $349e : $b0, $18

    mov !$2f10, X                                                  ; $34a0 : $c9, $10, $2f
    bcs $08                                                  ; $34a3 : $b0, $08

    and $00, $b0                                                  ; $34a5 : $29, $b0, $00
    sbc A, $a4                                                  ; $34a8 : $a4, $a4
    sbc A, $a4                                                  ; $34aa : $a4, $a4
    nop                                                  ; $34ac : $00
    clrv                                                  ; $34ad : $e0
    mov $e1+X,A                                                  ; $34ae : $d4, $e1
    asl !$e09f                                                  ; $34b0 : $0c, $9f, $e0
    mov $e1, X                                                  ; $34b3 : $d8, $e1
    or A, [$a8+X]                                                  ; $34b5 : $07, $a8
    clrv                                                  ; $34b7 : $e0
    mov $e1+X,A                                                  ; $34b8 : $d4, $e1
    asl !$9f10                                                  ; $34ba : $0c, $10, $9f
    or A, #$9f                                                  ; $34bd : $08, $9f
    clrv                                                  ; $34bf : $e0
    mov $e1, X                                                  ; $34c0 : $d8, $e1
    or A, [$18+X]                                                  ; $34c2 : $07, $18
    sbc A, #$00                                                  ; $34c4 : $a8, $00
    bpl -$37                                                  ; $34c6 : $10, $c9

    or A, #$a1                                                  ; $34c8 : $08, $a1
    or $30, #$c9                                                  ; $34ca : $18, $c9, $30
    tcall 10                                                  ; $34cd : $a1
    nop                                                  ; $34ce : $00
    bpl -$37                                                  ; $34cf : $10, $c9

    or A, #$a1                                                  ; $34d1 : $08, $a1
    or $28, #$c9                                                  ; $34d3 : $18, $c9, $28
    tcall 10                                                  ; $34d6 : $a1
    or A, #$c9                                                  ; $34d7 : $08, $c9
    nop                                                  ; $34d9 : $00
    bpl -$37                                                  ; $34da : $10, $c9

    or A, #$a4                                                  ; $34dc : $08, $a4
    or $30, #$c9                                                  ; $34de : $18, $c9, $30
    sbc A, $00                                                  ; $34e1 : $a4, $00
