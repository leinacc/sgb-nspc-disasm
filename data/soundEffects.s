.table byte, word, word, word, word
SoundEffectsA_01hTo1Ch:
; 0 - Tracks enabled (bit 0 - track 7, bit 1 - track 6)
; 1/2 - Track 7 data ptr
; 3/4 - Track 6 data ptr
    .row $03, data_1e82, data_1e82, 0, 0
    .row $03, data_1e92, $1ec4, 0, 0
    .db $03, $f6, $1e, $7f, $1e, $00, $00, $00, $00
    .db $03, $12, $1f, $28, $1f, $00, $00, $00, $00
    .db $03, $3e, $1f, $60, $1f, $00, $00, $00, $00
    .db $03, $82, $1f, $92, $1f, $00, $00, $00, $00
    .db $03, $d8, $1f, $ec, $1f, $00, $00, $00, $00
    .db $03, $c2, $1f, $cd, $1f, $00, $00, $00, $00
    .db $03, $00, $20, $7f, $1e, $00, $00, $00, $00
    .db $03, $14, $20, $38, $20, $00, $00, $00, $00
    .db $03, $5c, $20, $6b, $20, $00, $00, $00, $00
    .db $03, $7a, $20, $89, $20, $00, $00, $00, $00
    .db $03, $ba, $20, $c9, $20, $00, $00, $00, $00
    .db $03, $98, $20, $a9, $20, $00, $00, $00, $00
    .db $03, $d8, $20, $7f, $1e, $00, $00, $00, $00
    .db $03, $f2, $20, $06, $21, $00, $00, $00, $00
    .db $03, $34, $21, $43, $21, $00, $00, $00, $00
    .db $03, $1a, $21, $27, $21, $00, $00, $00, $00
    .db $03, $da, $22, $da, $22, $00, $00, $00, $00
    .db $03, $52, $21, $6b, $21, $00, $00, $00, $00
    .db $03, $86, $21, $9d, $21, $00, $00, $00, $00
    .db $03, $b8, $21, $7f, $1e, $00, $00, $00, $00
    .db $03, $ce, $21, $7f, $1e, $00, $00, $00, $00
    .db $03, $e0, $21, $7f, $1e, $00, $00, $00, $00
    .db $03, $06, $22, $7f, $1e, $00, $00, $00, $00
    .db $03, $1b, $22, $7f, $1e, $00, $00, $00, $00
    .db $03, $2e, $22, $39, $22, $00, $00, $00, $00
    .db $03, $44, $22, $51, $22, $00, $00, $00, $00


SoundEffectsA_1DhTo30h:
    .db $03, $5e, $22, $90, $22, $00, $00, $00, $00
    .db $03, $c2, $22, $c2, $22, $00, $00, $00, $00
    .db $03, $f0, $22, $7f, $1e, $00, $00, $00, $00
    .db $03, $02, $23, $7f, $1e, $00, $00, $00, $00
    .db $03, $15, $23, $7f, $1e, $00, $00, $00, $00
    .db $03, $25, $23, $4f, $23, $00, $00, $00, $00
    .db $03, $a2, $1f, $b2, $1f, $00, $00, $00, $00
    .db $03, $cf, $23, $e2, $23, $00, $00, $00, $00
    .db $03, $f5, $23, $08, $24, $00, $00, $00, $00
    .db $03, $1b, $24, $54, $24, $00, $00, $00, $00
    .db $03, $8d, $24, $a1, $24, $00, $00, $00, $00
    .db $03, $b5, $24, $c9, $24, $00, $00, $00, $00
    .db $03, $dd, $24, $f5, $24, $00, $00, $00, $00
    .db $03, $0d, $25, $25, $25, $00, $00, $00, $00
    .db $03, $3d, $25, $55, $25, $00, $00, $00, $00
    .db $03, $6d, $25, $82, $25, $00, $00, $00, $00
    .db $03, $97, $25, $7f, $1e, $00, $00, $00, $00
    .db $03, $a8, $25, $c1, $25, $00, $00, $00, $00
    .db $03, $da, $25, $f7, $25, $00, $00, $00, $00
    .db $03, $f3, $21, $f3, $21, $00, $00, $00, $00


;
    set1 $00.0                                                  ; $1e7f : $02, $00
    stop                                                  ; $1e81 : $ff


data_1e82:
    .db $08
; 1st bigLoop_1689
    .db $e0, $01 ; use instrument 1
    .db $f5 ; apply vol
    .db $ee, $ff, $71 ; set adsr1 and adsr2
; restart bigLoop_1689
    .db $f8 ; $45 |= $40
    .db $a9 ; pitch-related
    .db $02 ; pitch-related

    .db $f9
    .db $00, $5a ; pitch-related
    
    .db $f8
    .db $ae
    .db $ff


data_1e92:
    tcall 0                                                  ; $1e92 : $01
    clrv                                                  ; $1e93 : $e0
    cmp X, $ed                                                  ; $1e94 : $3e, $ed
    .db $50, $f5

    mov Y, $f3+X                                                  ; $1e98 : $fb, $f3

br_00_1e9a:
    mov X, $b4                                                  ; $1e9a : $f8, $b4
    tcall 0                                                  ; $1e9c : $01
    notc                                                  ; $1e9d : $ed
    adc A, $00                                                  ; $1e9e : $84, $00
    tcall 1                                                  ; $1ea0 : $11
    clr1 $02.7                                                  ; $1ea1 : $f2, $02
    nop                                                  ; $1ea3 : $00
    set1 $a8.0                                                  ; $1ea4 : $02, $a8
    sbc A, #$11                                                  ; $1ea6 : $a8, $11
    clr1 $02.7                                                  ; $1ea8 : $f2, $02
    nop                                                  ; $1eaa : $00
    set1 $a0.0                                                  ; $1eab : $02, $a0
    ei                                                  ; $1ead : $a0
    tcall 1                                                  ; $1eae : $11
    clr1 $02.7                                                  ; $1eaf : $f2, $02

Call_00_1eb1:
    nop                                                  ; $1eb1 : $00

Jump_00_1eb2:
    set1 $98.0                                                  ; $1eb2 : $02, $98
    adc $f2, #$11                                                  ; $1eb4 : $98, $11, $f2
    set1 $00.0                                                  ; $1eb7 : $02, $00
    set1 $90.0                                                  ; $1eb9 : $02, $90
    bcc br_00_1ece                                                  ; $1ebb : $90, $11

    clr1 $02.7                                                  ; $1ebd : $f2, $02
    nop                                                  ; $1ebf : $00
    set1 $88.0                                                  ; $1ec0 : $02, $88
    adc A, #$ff                                                  ; $1ec2 : $88, $ff
    tcall 0                                                  ; $1ec4 : $01
    clrv                                                  ; $1ec5 : $e0
    cmp X, $ed                                                  ; $1ec6 : $3e, $ed
    eor $fb, #$f5                                                  ; $1ec8 : $58, $f5, $fb
    bbc $f8.7, -$4e                                                  ; $1ecb : $f3, $f8, $b2

br_00_1ece:
    tcall 0                                                  ; $1ece : $01
    notc                                                  ; $1ecf : $ed
    adc A, $00                                                  ; $1ed0 : $84, $00
    tcall 1                                                  ; $1ed2 : $11
    clr1 $02.7                                                  ; $1ed3 : $f2, $02
    nop                                                  ; $1ed5 : $00
    set1 $a6.0                                                  ; $1ed6 : $02, $a6
    sbc A, (X)                                                  ; $1ed8 : $a6
    tcall 1                                                  ; $1ed9 : $11
    clr1 $02.7                                                  ; $1eda : $f2, $02
    nop                                                  ; $1edc : $00
    set1 $9e.0                                                  ; $1edd : $02, $9e
    div YA, X                                                  ; $1edf : $9e
    tcall 1                                                  ; $1ee0 : $11

Jump_00_1ee1:
    clr1 $02.7                                                  ; $1ee1 : $f2, $02
    nop                                                  ; $1ee3 : $00

Call_00_1ee4:
    set1 $96.0                                                  ; $1ee4 : $02, $96
    adc A, !$f211+Y                                                  ; $1ee6 : $96, $11, $f2
    set1 $00.0                                                  ; $1ee9 : $02, $00
    set1 $8e.0                                                  ; $1eeb : $02, $8e
    pop PSW                                                  ; $1eed : $8e
    tcall 1                                                  ; $1eee : $11
    clr1 $02.7                                                  ; $1eef : $f2, $02
    nop                                                  ; $1ef1 : $00
    set1 $86.0                                                  ; $1ef2 : $02, $86

Jump_00_1ef4:
    adc A, (X)                                                  ; $1ef4 : $86
    stop                                                  ; $1ef5 : $ff
    tcall 0                                                  ; $1ef6 : $01
    clrv                                                  ; $1ef7 : $e0
    nop                                                  ; $1ef8 : $00
    notc                                                  ; $1ef9 : $ed
    setp                                                  ; $1efa : $40
    mov A, !$faf3+X                                                  ; $1efb : $f5, $f3, $fa
    mov X, $a8                                                  ; $1efe : $f8, $a8

Jump_00_1f00:
    or A, [$ed+X]                                                  ; $1f00 : $07, $ed

Jump_00_1f02:
    set1 $00.4                                                  ; $1f02 : $82, $00
    reti                                                  ; $1f04 : $7f


    clr1 $02.7                                                  ; $1f05 : $f2, $02
    and $a8, #$00                                                  ; $1f07 : $38, $00, $a8
    sbc A, #$1f                                                  ; $1f0a : $a8, $1f
    nop                                                  ; $1f0c : $00
    jmp [!Jump_00_1f00+X]                                                  ; $1f0d : $1f, $00, $1f


    nop                                                  ; $1f10 : $00

Jump_00_1f11:
    stop                                                  ; $1f11 : $ff
    or A, (X)                                                  ; $1f12 : $06
    clrv                                                  ; $1f13 : $e0
    tcall 0                                                  ; $1f14 : $01
    mov A, !$ffee+X                                                  ; $1f15 : $f5, $ee, $ff
    tcall 7                                                  ; $1f18 : $71
    mov X, $9f                                                  ; $1f19 : $f8, $9f
    set1 $f9.0                                                  ; $1f1b : $02, $f9
    nop                                                  ; $1f1d : $00
    or A, (X)                                                  ; $1f1e : $06
    mov X, $a3                                                  ; $1f1f : $f8, $a3
    set1 $f9.0                                                  ; $1f21 : $02, $f9
    nop                                                  ; $1f23 : $00

Jump_00_1f24:
    cmpw YA, $f8                                                  ; $1f24 : $5a, $f8
    sbc A, (X)                                                  ; $1f26 : $a6
    stop                                                  ; $1f27 : $ff
    or A, (X)                                                  ; $1f28 : $06
    clrv                                                  ; $1f29 : $e0
    tcall 0                                                  ; $1f2a : $01
    mov A, !$ffee+X                                                  ; $1f2b : $f5, $ee, $ff
    tcall 7                                                  ; $1f2e : $71
    mov X, $a3                                                  ; $1f2f : $f8, $a3
    set1 $f9.0                                                  ; $1f31 : $02, $f9
    nop                                                  ; $1f33 : $00
    or A, (X)                                                  ; $1f34 : $06
    mov X, $a6                                                  ; $1f35 : $f8, $a6
    set1 $f9.0                                                  ; $1f37 : $02, $f9
    nop                                                  ; $1f39 : $00
    cmpw YA, $f8                                                  ; $1f3a : $5a, $f8
    inc $ff                                                  ; $1f3c : $ab, $ff
    or A, $e0                                                  ; $1f3e : $04, $e0
    tcall 0                                                  ; $1f40 : $01
    mov A, !$ffee+X                                                  ; $1f41 : $f5, $ee, $ff
    tcall 7                                                  ; $1f44 : $71
    mov X, $a6                                                  ; $1f45 : $f8, $a6
    set1 $f9.0                                                  ; $1f47 : $02, $f9
    nop                                                  ; $1f49 : $00
    or A, $f8                                                  ; $1f4a : $04, $f8
    sbc A, !$f902                                                  ; $1f4c : $a5, $02, $f9
    nop                                                  ; $1f4f : $00
    or A, $f8                                                  ; $1f50 : $04, $f8
    sbc A, (X)                                                  ; $1f52 : $a6
    set1 $f9.0                                                  ; $1f53 : $02, $f9
    nop                                                  ; $1f55 : $00
    or A, $f8                                                  ; $1f56 : $04, $f8
    sbc A, !$f902                                                  ; $1f58 : $a5, $02, $f9
    nop                                                  ; $1f5b : $00
    cmpw YA, $f8                                                  ; $1f5c : $5a, $f8
    sbc A, (X)                                                  ; $1f5e : $a6
    stop                                                  ; $1f5f : $ff
    or A, $e0                                                  ; $1f60 : $04, $e0
    tcall 0                                                  ; $1f62 : $01
    mov A, !$ffee+X                                                  ; $1f63 : $f5, $ee, $ff
    tcall 7                                                  ; $1f66 : $71
    mov X, $aa                                                  ; $1f67 : $f8, $aa
    set1 $f9.0                                                  ; $1f69 : $02, $f9
    nop                                                  ; $1f6b : $00
    or A, $f8                                                  ; $1f6c : $04, $f8
    sbc A, #$02                                                  ; $1f6e : $a8, $02
    mov X, $00+Y                                                  ; $1f70 : $f9, $00
    or A, $f8                                                  ; $1f72 : $04, $f8
    mov1 c, $1902.7                                                  ; $1f74 : $aa, $02, $f9
    nop                                                  ; $1f77 : $00
    or A, $f8                                                  ; $1f78 : $04, $f8
    sbc A, #$02                                                  ; $1f7a : $a8, $02
    mov X, $00+Y                                                  ; $1f7c : $f9, $00
    cmpw YA, $f8                                                  ; $1f7e : $5a, $f8
    mov1 c, $06ff.0                                                  ; $1f80 : $aa, $ff, $06
    clrv                                                  ; $1f83 : $e0

Jump_00_1f84:
    and A, !$eef5                                                  ; $1f84 : $25, $f5, $ee
    stop                                                  ; $1f87 : $ff
    tcall 7                                                  ; $1f88 : $71
    mov X, $96                                                  ; $1f89 : $f8, $96
    set1 $f9.0                                                  ; $1f8b : $02, $f9

br_00_1f8d:
    nop                                                  ; $1f8d : $00
    cmpw YA, $f8                                                  ; $1f8e : $5a, $f8
    adc (X), (Y)                                                  ; $1f90 : $99
    stop                                                  ; $1f91 : $ff
    or A, (X)                                                  ; $1f92 : $06
    clrv                                                  ; $1f93 : $e0
    and A, !$eef5                                                  ; $1f94 : $25, $f5, $ee
    stop                                                  ; $1f97 : $ff
    tcall 7                                                  ; $1f98 : $71
    mov X, $99                                                  ; $1f99 : $f8, $99
    set1 $f9.0                                                  ; $1f9b : $02, $f9
    nop                                                  ; $1f9d : $00
    cmpw YA, $f8                                                  ; $1f9e : $5a, $f8
    div YA, X                                                  ; $1fa0 : $9e
    stop                                                  ; $1fa1 : $ff
    or A, (X)                                                  ; $1fa2 : $06
    clrv                                                  ; $1fa3 : $e0
    and A, !$eef5                                                  ; $1fa4 : $25, $f5, $ee
    stop                                                  ; $1fa7 : $ff
    tcall 7                                                  ; $1fa8 : $71
    mov X, $99                                                  ; $1fa9 : $f8, $99
    set1 $f9.0                                                  ; $1fab : $02, $f9
    nop                                                  ; $1fad : $00
    cmpw YA, $f8                                                  ; $1fae : $5a, $f8
    adc A, !$06ff+Y                                                  ; $1fb0 : $96, $ff, $06
    clrv                                                  ; $1fb3 : $e0
    and A, !$eef5                                                  ; $1fb4 : $25, $f5, $ee
    stop                                                  ; $1fb7 : $ff
    tcall 7                                                  ; $1fb8 : $71
    mov X, $9e                                                  ; $1fb9 : $f8, $9e
    set1 $f9.0                                                  ; $1fbb : $02, $f9
    nop                                                  ; $1fbd : $00
    cmpw YA, $f8                                                  ; $1fbe : $5a, $f8
    adc (X), (Y)                                                  ; $1fc0 : $99
    stop                                                  ; $1fc1 : $ff
    cmpw YA, $e0                                                  ; $1fc2 : $5a, $e0
    tcall 0                                                  ; $1fc4 : $01
    mov A, !$eefb+X                                                  ; $1fc5 : $f5, $fb, $ee
    stop                                                  ; $1fc8 : $ff
    tcall 7                                                  ; $1fc9 : $71
    mov X, $a9                                                  ; $1fca : $f8, $a9
    stop                                                  ; $1fcc : $ff
    cmpw YA, $e0                                                  ; $1fcd : $5a, $e0
    tcall 0                                                  ; $1fcf : $01
    mov A, !$eefb+X                                                  ; $1fd0 : $f5, $fb, $ee
    stop                                                  ; $1fd3 : $ff
    tcall 7                                                  ; $1fd4 : $71
    mov X, $a6                                                  ; $1fd5 : $f8, $a6
    stop                                                  ; $1fd7 : $ff
    set1 $e0.0                                                  ; $1fd8 : $02, $e0
    and A, [$ed]+Y                                                  ; $1fda : $37, $ed
    bvs -$05                                                  ; $1fdc : $70, $fb

    mov A, !$f8f3+X                                                  ; $1fde : $f5, $f3, $f8
    adc $f9, #$02                                                  ; $1fe1 : $98, $02, $f9
    nop                                                  ; $1fe4 : $00

Call_00_1fe5:
    set1 $f8.0                                                  ; $1fe5 : $02, $f8
    ei                                                  ; $1fe7 : $a0
    set1 $f9.0                                                  ; $1fe8 : $02, $f9
    nop                                                  ; $1fea : $00
    stop                                                  ; $1feb : $ff
    set1 $e0.0                                                  ; $1fec : $02, $e0

Jump_00_1fee:
    and A, [$ed]+Y                                                  ; $1fee : $37, $ed
    bvs -$05                                                  ; $1ff0 : $70, $fb

    mov A, !$f8f3+X                                                  ; $1ff2 : $f5, $f3, $f8
    adc $f9, #$02                                                  ; $1ff5 : $98, $02, $f9
    nop                                                  ; $1ff8 : $00
    set1 $f8.0                                                  ; $1ff9 : $02, $f8
    ei                                                  ; $1ffb : $a0
    set1 $f9.0                                                  ; $1ffc : $02, $f9

Call_00_1ffe:
    nop                                                  ; $1ffe : $00
    stop                                                  ; $1fff : $ff
    or A, $e0                                                  ; $2000 : $04, $e0

Jump_00_2002:
    and A, #$ed                                                  ; $2002 : $28, $ed
    eor $fb, #$f5                                                  ; $2004 : $58, $f5, $fb
    bbc $f8.7, br_00_1f8d                                                  ; $2007 : $f3, $f8, $83

    or A, $f9                                                  ; $200a : $04, $f9
    nop                                                  ; $200c : $00
    or $83, #$f8                                                  ; $200d : $18, $f8, $83
    set1 $f9.0                                                  ; $2010 : $02, $f9
    nop                                                  ; $2012 : $00
    stop                                                  ; $2013 : $ff
    set1 $e0.0                                                  ; $2014 : $02, $e0
    and $68, #$ed                                                  ; $2016 : $38, $ed, $68
    mov A, !$e3fb+X                                                  ; $2019 : $f5, $fb, $e3
    nop                                                  ; $201c : $00
    tcall 0                                                  ; $201d : $01
    tcall 0                                                  ; $201e : $01
    bbc $f8.7, -$71                                                  ; $201f : $f3, $f8, $8f

    or A, $f9                                                  ; $2022 : $04, $f9
    nop                                                  ; $2024 : $00
    set1 $f8.0                                                  ; $2025 : $02, $f8
    adc A, #$02                                                  ; $2027 : $88, $02

br_00_2029:
    mov X, $00+Y                                                  ; $2029 : $f9, $00
    set1 $f8.0                                                  ; $202b : $02, $f8
    bbs $02.4, br_00_2029                                                  ; $202d : $83, $02, $f9

    nop                                                  ; $2030 : $00
    set1 $f8.0                                                  ; $2031 : $02, $f8

Jump_00_2033:
    adc A, $02+X                                                  ; $2033 : $94, $02
    mov X, $00+Y                                                  ; $2035 : $f9, $00
    stop                                                  ; $2037 : $ff
    set1 $e0.0                                                  ; $2038 : $02, $e0
    and $68, #$ed                                                  ; $203a : $38, $ed, $68
    mov A, !$e3fb+X                                                  ; $203d : $f5, $fb, $e3
    nop                                                  ; $2040 : $00
    tcall 0                                                  ; $2041 : $01
    tcall 0                                                  ; $2042 : $01
    bbc $f8.7, -$6d                                                  ; $2043 : $f3, $f8, $93

    or A, $f9                                                  ; $2046 : $04, $f9
    nop                                                  ; $2048 : $00
    set1 $f8.0                                                  ; $2049 : $02, $f8
    dec !$f902                                                  ; $204b : $8c, $02, $f9
    nop                                                  ; $204e : $00
    set1 $f8.0                                                  ; $204f : $02, $f8
    adc A, [$02+X]                                                  ; $2051 : $87, $02
    mov X, $00+Y                                                  ; $2053 : $f9, $00
    set1 $f8.0                                                  ; $2055 : $02, $f8
    adc $f9, #$02                                                  ; $2057 : $98, $02, $f9
    nop                                                  ; $205a : $00
    stop                                                  ; $205b : $ff
    clr1 $e0.0                                                  ; $205c : $12, $e0
    and A, $ed+X                                                  ; $205e : $34, $ed
    eor A, #$f5                                                  ; $2060 : $48, $f5
    mov Y, $f2+X                                                  ; $2062 : $fb, $f2
    set1 $80.0                                                  ; $2064 : $02, $80
    tcall 0                                                  ; $2066 : $01
    sbc A, #$f8                                                  ; $2067 : $a8, $f8
    sbc A, #$ff                                                  ; $2069 : $a8, $ff
    clr1 $e0.0                                                  ; $206b : $12, $e0
    and A, $ed+X                                                  ; $206d : $34, $ed
    eor A, #$f5                                                  ; $206f : $48, $f5
    mov Y, $f2+X                                                  ; $2071 : $fb, $f2
    set1 $80.0                                                  ; $2073 : $02, $80
    tcall 0                                                  ; $2075 : $01
    sbc A, #$f8                                                  ; $2076 : $a8, $f8
    sbc A, #$ff                                                  ; $2078 : $a8, $ff
    reti                                                  ; $207a : $7f


    clrv                                                  ; $207b : $e0
    rol A                                                  ; $207c : $3c
    notc                                                  ; $207d : $ed
    setp                                                  ; $207e : $40
    mov A, !$f3fb+X                                                  ; $207f : $f5, $fb, $f3
    mov X, $99                                                  ; $2082 : $f8, $99
    setp                                                  ; $2084 : $40
    notc                                                  ; $2085 : $ed
    adc $ff, $00                                                  ; $2086 : $89, $00, $ff
    reti                                                  ; $2089 : $7f


Jump_00_208a:
    clrv                                                  ; $208a : $e0
    rol A                                                  ; $208b : $3c
    notc                                                  ; $208c : $ed
    setp                                                  ; $208d : $40
    mov A, !$f3fb+X                                                  ; $208e : $f5, $fb, $f3
    mov X, $92                                                  ; $2091 : $f8, $92
    setp                                                  ; $2093 : $40

br_00_2094:
    notc                                                  ; $2094 : $ed
    adc $ff, $00                                                  ; $2095 : $89, $00, $ff
    reti                                                  ; $2098 : $7f


    clrv                                                  ; $2099 : $e0
    rol A                                                  ; $209a : $3c
    notc                                                  ; $209b : $ed
    eor A, #$f5                                                  ; $209c : $48, $f5
    mov Y, $f3+X                                                  ; $209e : $fb, $f3
    mov X, $8b                                                  ; $20a0 : $f8, $8b
    reti                                                  ; $20a2 : $7f


    nop                                                  ; $20a3 : $00
    reti                                                  ; $20a4 : $7f


    nop                                                  ; $20a5 : $00
    reti                                                  ; $20a6 : $7f


    nop                                                  ; $20a7 : $00

br_00_20a8:
    stop                                                  ; $20a8 : $ff
    reti                                                  ; $20a9 : $7f


    clrv                                                  ; $20aa : $e0
    rol A                                                  ; $20ab : $3c
    notc                                                  ; $20ac : $ed
    eor A, #$f5                                                  ; $20ad : $48, $f5
    mov Y, $f3+X                                                  ; $20af : $fb, $f3
    mov X, $88                                                  ; $20b1 : $f8, $88
    reti                                                  ; $20b3 : $7f


    nop                                                  ; $20b4 : $00
    reti                                                  ; $20b5 : $7f


    nop                                                  ; $20b6 : $00
    reti                                                  ; $20b7 : $7f


    nop                                                  ; $20b8 : $00
    stop                                                  ; $20b9 : $ff
    reti                                                  ; $20ba : $7f


    clrv                                                  ; $20bb : $e0
    rol A                                                  ; $20bc : $3c

Jump_00_20bd:
    notc                                                  ; $20bd : $ed
    eor A, $f5                                                  ; $20be : $44, $f5
    mov Y, $f3+X                                                  ; $20c0 : $fb, $f3
    mov X, $90                                                  ; $20c2 : $f8, $90
    reti                                                  ; $20c4 : $7f


    nop                                                  ; $20c5 : $00
    reti                                                  ; $20c6 : $7f


    nop                                                  ; $20c7 : $00
    stop                                                  ; $20c8 : $ff
    reti                                                  ; $20c9 : $7f


    clrv                                                  ; $20ca : $e0
    rol A                                                  ; $20cb : $3c
    notc                                                  ; $20cc : $ed
    eor A, $f5                                                  ; $20cd : $44, $f5
    mov Y, $f3+X                                                  ; $20cf : $fb, $f3
    mov X, $92                                                  ; $20d1 : $f8, $92
    reti                                                  ; $20d3 : $7f


br_00_20d4:
    nop                                                  ; $20d4 : $00
    reti                                                  ; $20d5 : $7f


    nop                                                  ; $20d6 : $00
    stop                                                  ; $20d7 : $ff
    or A, [$e0+X]                                                  ; $20d8 : $07, $e0
    rol A                                                  ; $20da : $3c
    notc                                                  ; $20db : $ed
    cmp $fb, #$f5                                                  ; $20dc : $78, $f5, $fb
    clr1 $01.7                                                  ; $20df : $f2, $01

Jump_00_20e1:
    eor $94, #$00                                                  ; $20e1 : $58, $00, $94
    mov X, $94                                                  ; $20e4 : $f8, $94
    asl $f2+X                                                  ; $20e6 : $1b, $f2

br_00_20e8:
    tcall 0                                                  ; $20e8 : $01
    nop                                                  ; $20e9 : $00
    or A, $84                                                  ; $20ea : $04, $84
    mov X, $84                                                  ; $20ec : $f8, $84
    set1 $f3.0                                                  ; $20ee : $02, $f3
    nop                                                  ; $20f0 : $00
    stop                                                  ; $20f1 : $ff
    bpl br_00_20d4                                                  ; $20f2 : $10, $e0

    rol A                                                  ; $20f4 : $3c
    notc                                                  ; $20f5 : $ed
    cmp A, $f5                                                  ; $20f6 : $64, $f5
    mov Y, $f2+X                                                  ; $20f8 : $fb, $f2
    tcall 0                                                  ; $20fa : $01
    setc                                                  ; $20fb : $80
    tcall 0                                                  ; $20fc : $01
    set1 $f8.4                                                  ; $20fd : $82, $f8
    set1 $1c.4                                                  ; $20ff : $82, $1c
    bbc $ed.7, br_00_2094                                                  ; $2101 : $f3, $ed, $90

    nop                                                  ; $2104 : $00
    stop                                                  ; $2105 : $ff
    bpl br_00_20e8                                                  ; $2106 : $10, $e0

    rol A                                                  ; $2108 : $3c
    notc                                                  ; $2109 : $ed
    cmp A, $f5                                                  ; $210a : $64, $f5
    mov Y, $f2+X                                                  ; $210c : $fb, $f2
    tcall 0                                                  ; $210e : $01
    setc                                                  ; $210f : $80
    tcall 0                                                  ; $2110 : $01
    adc A, !$85f8                                                  ; $2111 : $85, $f8, $85
    asl A                                                  ; $2114 : $1c
    bbc $ed.7, br_00_20a8                                                  ; $2115 : $f3, $ed, $90

    nop                                                  ; $2118 : $00
    stop                                                  ; $2119 : $ff
    cmp A, #$e0                                                  ; $211a : $68, $e0
    rol A                                                  ; $211c : $3c
    notc                                                  ; $211d : $ed
    cmp A, #$f5                                                  ; $211e : $68, $f5
    mov Y, $f3+X                                                  ; $2120 : $fb, $f3
    mov X, $af                                                  ; $2122 : $f8, $af
    cmp A, #$00                                                  ; $2124 : $68, $00
    stop                                                  ; $2126 : $ff
    cmp A, #$e0                                                  ; $2127 : $68, $e0
    rol A                                                  ; $2129 : $3c
    notc                                                  ; $212a : $ed

Jump_00_212b:
    clrc                                                  ; $212b : $60
    mov A, !$f3fb+X                                                  ; $212c : $f5, $fb, $f3
    mov X, $aa                                                  ; $212f : $f8, $aa
    cmp A, #$00                                                  ; $2131 : $68, $00
    stop                                                  ; $2133 : $ff
    cmp A, #$e0                                                  ; $2134 : $68, $e0
    rol A                                                  ; $2136 : $3c
    notc                                                  ; $2137 : $ed
    cmp A, #$f5                                                  ; $2138 : $68, $f5
    mov Y, $f3+X                                                  ; $213a : $fb, $f3
    mov X, $a8                                                  ; $213c : $f8, $a8
    cmp A, #$ed                                                  ; $213e : $68, $ed
    clrp                                                  ; $2140 : $20
    nop                                                  ; $2141 : $00
    stop                                                  ; $2142 : $ff
    cmp A, #$e0                                                  ; $2143 : $68, $e0
    rol A                                                  ; $2145 : $3c
    notc                                                  ; $2146 : $ed
    clrc                                                  ; $2147 : $60
    mov A, !$f3fb+X                                                  ; $2148 : $f5, $fb, $f3
    mov X, $a4                                                  ; $214b : $f8, $a4

br_00_214d:
    cmp A, #$ed                                                  ; $214d : $68, $ed
    clrp                                                  ; $214f : $20
    nop                                                  ; $2150 : $00
    stop                                                  ; $2151 : $ff
    or $3c, #$e0                                                  ; $2152 : $18, $e0, $3c
    notc                                                  ; $2155 : $ed
    cmp $fb, #$f5                                                  ; $2156 : $78, $f5, $fb
    clr1 $01.7                                                  ; $2159 : $f2, $01
    clrp                                                  ; $215b : $20
    nop                                                  ; $215c : $00
    adc A, #$f8                                                  ; $215d : $88, $f8
    adc A, #$0c                                                  ; $215f : $88, $0c
    notc                                                  ; $2161 : $ed
    adc A, !$7f00                                                  ; $2162 : $85, $00, $7f
    nop                                                  ; $2165 : $00
    reti                                                  ; $2166 : $7f


br_00_2167:
    nop                                                  ; $2167 : $00
    reti                                                  ; $2168 : $7f


    nop                                                  ; $2169 : $00
    stop                                                  ; $216a : $ff
    bpl br_00_214d                                                  ; $216b : $10, $e0

    and $70, #$ed                                                  ; $216d : $38, $ed, $70
    mov A, !$f2fb+X                                                  ; $2170 : $f5, $fb, $f2
    set1 $30.0                                                  ; $2173 : $02, $30
    nop                                                  ; $2175 : $00
    eor1 c, $0af8.4                                                  ; $2176 : $8a, $f8, $8a
    or A, $ed+X                                                  ; $2179 : $14, $ed
    setp                                                  ; $217b : $40
    nop                                                  ; $217c : $00
    asl !$8ded                                                  ; $217d : $0c, $ed, $8d
    nop                                                  ; $2180 : $00
    reti                                                  ; $2181 : $7f


    nop                                                  ; $2182 : $00
    reti                                                  ; $2183 : $7f


    nop                                                  ; $2184 : $00
    stop                                                  ; $2185 : $ff
    or $3c, #$e0                                                  ; $2186 : $18, $e0, $3c
    notc                                                  ; $2189 : $ed
    cmp $fa, #$f5                                                  ; $218a : $78, $f5, $fa
    clr1 $01.7                                                  ; $218d : $f2, $01
    or $90, #$00                                                  ; $218f : $18, $00, $90
    mov X, $90                                                  ; $2192 : $f8, $90
    asl !$85ed                                                  ; $2194 : $0c, $ed, $85

br_00_2197:
    nop                                                  ; $2197 : $00
    reti                                                  ; $2198 : $7f


    nop                                                  ; $2199 : $00
    reti                                                  ; $219a : $7f


    nop                                                  ; $219b : $00
    stop                                                  ; $219c : $ff
    bpl -$20                                                  ; $219d : $10, $e0

    and $70, #$ed                                                  ; $219f : $38, $ed, $70
    mov A, !$f2fa+X                                                  ; $21a2 : $f5, $fa, $f2
    set1 $30.0                                                  ; $21a5 : $02, $30
    nop                                                  ; $21a7 : $00
    clr1 $f8.4                                                  ; $21a8 : $92, $f8
    clr1 $14.4                                                  ; $21aa : $92, $14
    notc                                                  ; $21ac : $ed
    setp                                                  ; $21ad : $40
    nop                                                  ; $21ae : $00
    asl !$8ded                                                  ; $21af : $0c, $ed, $8d
    nop                                                  ; $21b2 : $00
    reti                                                  ; $21b3 : $7f


    nop                                                  ; $21b4 : $00
    reti                                                  ; $21b5 : $7f


br_00_21b6:
    nop                                                  ; $21b6 : $00
    stop                                                  ; $21b7 : $ff
    set1 $e0.0                                                  ; $21b8 : $02, $e0
    or A, (X)                                                  ; $21ba : $06
    notc                                                  ; $21bb : $ed
    setp                                                  ; $21bc : $40
    mov $f3, $f5                                                  ; $21bd : $fa, $f5, $f3
    mov X, $80                                                  ; $21c0 : $f8, $80
    bpl br_00_21b6                                                  ; $21c2 : $10, $f2

    tcall 0                                                  ; $21c4 : $01
    nop                                                  ; $21c5 : $00
    bbs $80.0, -$80                                                  ; $21c6 : $03, $80, $80

br_00_21c9:
    call !$00ed                                                  ; $21c9 : $3f, $ed, $00
    nop                                                  ; $21cc : $00
    stop                                                  ; $21cd : $ff
    set1 $e0.0                                                  ; $21ce : $02, $e0
    or A, (X)                                                  ; $21d0 : $06

br_00_21d1:
    notc                                                  ; $21d1 : $ed
    bvs br_00_21c9                                                  ; $21d2 : $70, $f5

    mov Y, $f3+X                                                  ; $21d4 : $fb, $f3
    mov X, $88                                                  ; $21d6 : $f8, $88
    asl !$01f2                                                  ; $21d8 : $0c, $f2, $01
    nop                                                  ; $21db : $00
    bbs $88.0, br_00_2167                                                  ; $21dc : $03, $88, $88

    stop                                                  ; $21df : $ff
    set1 $e0.0                                                  ; $21e0 : $02, $e0
    bmi br_00_21d1                                                  ; $21e2 : $30, $ed

br_00_21e4:
    reti                                                  ; $21e4 : $7f


    mov A, !$f2fb+X                                                  ; $21e5 : $f5, $fb, $f2
    tcall 0                                                  ; $21e8 : $01
    tcall 13                                                  ; $21e9 : $d1
    nop                                                  ; $21ea : $00
    dec A                                                  ; $21eb : $9c

br_00_21ec:
    mov X, $9c                                                  ; $21ec : $f8, $9c

br_00_21ee:
    and $8f, $ed                                                  ; $21ee : $29, $ed, $8f

Jump_00_21f1:
    nop                                                  ; $21f1 : $00
    stop                                                  ; $21f2 : $ff
    set1 $e0.0                                                  ; $21f3 : $02, $e0
    bmi br_00_21e4                                                  ; $21f5 : $30, $ed

    bvs br_00_21ee                                                  ; $21f7 : $70, $f5

    mov Y, $f2+X                                                  ; $21f9 : $fb, $f2
    set1 $81.0                                                  ; $21fb : $02, $81
    nop                                                  ; $21fd : $00
    sbc (X), (Y)                                                  ; $21fe : $b9
    mov X, $b9                                                  ; $21ff : $f8, $b9
    and $8f, $ed                                                  ; $2201 : $29, $ed, $8f
    nop                                                  ; $2204 : $00
    stop                                                  ; $2205 : $ff
    setc                                                  ; $2206 : $80
    clrv                                                  ; $2207 : $e0
    and $78, #$ed                                                  ; $2208 : $38, $ed, $78
    mov A, !$f2fb+X                                                  ; $220b : $f5, $fb, $f2
    tcall 0                                                  ; $220e : $01
    bmi br_00_2211                                                  ; $220f : $30, $00

br_00_2211:
    bbs $f8.4, br_00_2197                                                  ; $2211 : $83, $f8, $83

    reti                                                  ; $2214 : $7f


    notc                                                  ; $2215 : $ed
    set1 $00.4                                                  ; $2216 : $82, $00
    bvs br_00_221a                                                  ; $2218 : $70, $00

br_00_221a:
    stop                                                  ; $221a : $ff
    setc                                                  ; $221b : $80
    clrv                                                  ; $221c : $e0
    and $c1, #$ed                                                  ; $221d : $38, $ed, $c1
    mov A, !$f2fb+X                                                  ; $2220 : $f5, $fb, $f2
    set1 $10.0                                                  ; $2223 : $02, $10
    nop                                                  ; $2225 : $00
    bbs $f8.6, br_00_21ec                                                  ; $2226 : $c3, $f8, $c3

    reti                                                  ; $2229 : $7f


    notc                                                  ; $222a : $ed
    mov (X)+, A                                                  ; $222b : $af
    nop                                                  ; $222c : $00
    stop                                                  ; $222d : $ff
    clr1 $e0.1                                                  ; $222e : $32, $e0
    rol $ed+X                                                  ; $2230 : $3b, $ed
    pcall $f5                                                  ; $2232 : $4f, $f5
    mov Y, $f3+X                                                  ; $2234 : $fb, $f3
    mov X, $8c                                                  ; $2236 : $f8, $8c
    stop                                                  ; $2238 : $ff
    clr1 $e0.1                                                  ; $2239 : $32, $e0
    rol $ed+X                                                  ; $223b : $3b, $ed
    pcall $f5                                                  ; $223d : $4f, $f5
    mov Y, $f3+X                                                  ; $223f : $fb, $f3
    mov X, $8c                                                  ; $2241 : $f8, $8c
    stop                                                  ; $2243 : $ff
    clr1 $e0.1                                                  ; $2244 : $32, $e0
    rol $ed+X                                                  ; $2246 : $3b, $ed
    cmp A, #$f5                                                  ; $2248 : $68, $f5
    mov Y, $f3+X                                                  ; $224a : $fb, $f3
    mov X, $80                                                  ; $224c : $f8, $80

Jump_00_224e:
    reti                                                  ; $224e : $7f


    nop                                                  ; $224f : $00
    stop                                                  ; $2250 : $ff
    clr1 $e0.1                                                  ; $2251 : $32, $e0
    rol $ed+X                                                  ; $2253 : $3b, $ed
    cmp A, #$f5                                                  ; $2255 : $68, $f5
    mov Y, $f3+X                                                  ; $2257 : $fb, $f3
    mov X, $80                                                  ; $2259 : $f8, $80
    reti                                                  ; $225b : $7f


    nop                                                  ; $225c : $00
    stop                                                  ; $225d : $ff
    or A, #$e0                                                  ; $225e : $08, $e0
    tcall 0                                                  ; $2260 : $01
    bbc $f5.7, -$05                                                  ; $2261 : $f3, $f5, $fb

    pop Y                                                  ; $2264 : $ee
    stop                                                  ; $2265 : $ff
    tcall 7                                                  ; $2266 : $71
    mov A, $f8                                                  ; $2267 : $e4, $f8
    mov1 c, $1902.7                                                  ; $2269 : $aa, $02, $f9
    nop                                                  ; $226c : $00
    or A, #$f8                                                  ; $226d : $08, $f8
    mov1 c, $1902.7                                                  ; $226f : $aa, $02, $f9
    nop                                                  ; $2272 : $00
    or A, #$f8                                                  ; $2273 : $08, $f8
    mov1 c, $1902.7                                                  ; $2275 : $aa, $02, $f9
    nop                                                  ; $2278 : $00
    or A, #$00                                                  ; $2279 : $08, $00
    or A, #$f8                                                  ; $227b : $08, $f8
    inc $02                                                  ; $227d : $ab, $02
    mov X, $00+Y                                                  ; $227f : $f9, $00
    or A, #$f8                                                  ; $2281 : $08, $f8
    inc $02                                                  ; $2283 : $ab, $02
    mov X, $00+Y                                                  ; $2285 : $f9, $00
    or A, #$00                                                  ; $2287 : $08, $00
    or A, #$f8                                                  ; $2289 : $08, $f8
    inc !$f902                                                  ; $228b : $ac, $02, $f9
    nop                                                  ; $228e : $00
    stop                                                  ; $228f : $ff
    or A, #$e0                                                  ; $2290 : $08, $e0
    tcall 0                                                  ; $2292 : $01
    bbc $f5.7, -$05                                                  ; $2293 : $f3, $f5, $fb

Call_00_2296:
    pop Y                                                  ; $2296 : $ee
    stop                                                  ; $2297 : $ff
    tcall 7                                                  ; $2298 : $71
    mov A, $f8                                                  ; $2299 : $e4, $f8
    sbc A, [$02+X]                                                  ; $229b : $a7, $02
    mov X, $00+Y                                                  ; $229d : $f9, $00
    or A, #$f8                                                  ; $229f : $08, $f8
    sbc A, [$02+X]                                                  ; $22a1 : $a7, $02
    mov X, $00+Y                                                  ; $22a3 : $f9, $00
    or A, #$f8                                                  ; $22a5 : $08, $f8
    sbc A, [$02+X]                                                  ; $22a7 : $a7, $02
    mov X, $00+Y                                                  ; $22a9 : $f9, $00
    or A, #$00                                                  ; $22ab : $08, $00
    or A, #$f8                                                  ; $22ad : $08, $f8
    sbc A, #$02                                                  ; $22af : $a8, $02
    mov X, $00+Y                                                  ; $22b1 : $f9, $00
    or A, #$f8                                                  ; $22b3 : $08, $f8
    sbc A, #$02                                                  ; $22b5 : $a8, $02
    mov X, $00+Y                                                  ; $22b7 : $f9, $00
    or A, #$00                                                  ; $22b9 : $08, $00
    or A, #$f8                                                  ; $22bb : $08, $f8
    sbc $f9, $02                                                  ; $22bd : $a9, $02, $f9
    nop                                                  ; $22c0 : $00
    stop                                                  ; $22c1 : $ff
    bbs $e0.0, br_00_22fd                                                  ; $22c2 : $03, $e0, $38

    notc                                                  ; $22c5 : $ed
    clr1 $f5.7                                                  ; $22c6 : $f2, $f5
    mov Y, $f2+X                                                  ; $22c8 : $fb, $f2
    set1 $a0.0                                                  ; $22ca : $02, $a0
    set1 $a8.0                                                  ; $22cc : $02, $a8
    mov X, $a8                                                  ; $22ce : $f8, $a8
    or A, #$ed                                                  ; $22d0 : $08, $ed
    ror A                                                  ; $22d2 : $7c
    nop                                                  ; $22d3 : $00
    or A, (X)                                                  ; $22d4 : $06
    bbc $ed.7, -$68                                                  ; $22d5 : $f3, $ed, $98

    nop                                                  ; $22d8 : $00
    stop                                                  ; $22d9 : $ff
    bpl -$20                                                  ; $22da : $10, $e0

    and $77, #$ed                                                  ; $22dc : $38, $ed, $77
    mov A, !$f2fb+X                                                  ; $22df : $f5, $fb, $f2
    tcall 0                                                  ; $22e2 : $01
    setp                                                  ; $22e3 : $40
    nop                                                  ; $22e4 : $00
    tcall 8                                                  ; $22e5 : $81
    mov X, $81                                                  ; $22e6 : $f8, $81
    cmp $ed, $f3                                                  ; $22e8 : $69, $f3, $ed
    adc A, #$00                                                  ; $22eb : $88, $00
    reti                                                  ; $22ed : $7f


    nop                                                  ; $22ee : $00
    stop                                                  ; $22ef : $ff
    set1 $e0.0                                                  ; $22f0 : $02, $e0
    and (X), (Y)                                                  ; $22f2 : $39
    notc                                                  ; $22f3 : $ed
    cmp $fb, #$f5                                                  ; $22f4 : $78, $f5, $fb
    bbc $f8.7, -$78                                                  ; $22f7 : $f3, $f8, $88

    or $01, #$f2                                                  ; $22fa : $18, $f2, $01

br_00_22fd:
    nop                                                  ; $22fd : $00
    set1 $88.0                                                  ; $22fe : $02, $88
    adc A, #$ff                                                  ; $2300 : $88, $ff
    or A, #$e0                                                  ; $2302 : $08, $e0
    inc X                                                  ; $2304 : $3d
    notc                                                  ; $2305 : $ed
    cmp A, #$f5                                                  ; $2306 : $68, $f5
    mov Y, $f3+X                                                  ; $2308 : $fb, $f3
    mov X, $88                                                  ; $230a : $f8, $88
    set1 $ed.0                                                  ; $230c : $02, $ed
    bvs -$6c                                                  ; $230e : $70, $94

    reti                                                  ; $2310 : $7f


    notc                                                  ; $2311 : $ed
    adc A, #$00                                                  ; $2312 : $88, $00
    stop                                                  ; $2314 : $ff
    clrc                                                  ; $2315 : $60
    mov A, !$ed0c                                                  ; $2316 : $e5, $0c, $ed
    daa A                                                  ; $2319 : $df
    mov A, !$eefb+X                                                  ; $231a : $f5, $fb, $ee
    sbc A, !$f830+Y                                                  ; $231d : $b6, $30, $f8
    inc $02                                                  ; $2320 : $ab, $02

Jump_00_2322:
    mov X, $00+Y                                                  ; $2322 : $f9, $00
    stop                                                  ; $2324 : $ff
    set1 $e0.0                                                  ; $2325 : $02, $e0
    and A, $ed+X                                                  ; $2327 : $34, $ed
    jmp !$fbf5                                                  ; $2329 : $5f, $f5, $fb


    mov X, $9e                                                  ; $232c : $f8, $9e
    set1 $f9.0                                                  ; $232e : $02, $f9
    nop                                                  ; $2330 : $00
    set1 $ed.0                                                  ; $2331 : $02, $ed
    cmp $ad, #$f8                                                  ; $2333 : $78, $f8, $ad
    set1 $f9.0                                                  ; $2336 : $02, $f9
    nop                                                  ; $2338 : $00
    tcall 0                                                  ; $2339 : $01
    notc                                                  ; $233a : $ed
    cmp A, #$f8                                                  ; $233b : $68, $f8
    mov1 c, $1902.7                                                  ; $233d : $aa, $02, $f9
    nop                                                  ; $2340 : $00
    tcall 0                                                  ; $2341 : $01
    notc                                                  ; $2342 : $ed
    cmp A, $f8                                                  ; $2343 : $64, $f8
    sbc A, [$01+X]                                                  ; $2345 : $a7, $01
    notc                                                  ; $2347 : $ed
    eor $a5, #$f8                                                  ; $2348 : $58, $f8, $a5
    set1 $f9.0                                                  ; $234b : $02, $f9
    nop                                                  ; $234d : $00
    stop                                                  ; $234e : $ff
    set1 $e0.0                                                  ; $234f : $02, $e0
    and A, $ed+X                                                  ; $2351 : $34, $ed
    jmp !$fbf5                                                  ; $2353 : $5f, $f5, $fb


    mov X, $9c                                                  ; $2356 : $f8, $9c
    set1 $f9.0                                                  ; $2358 : $02, $f9
    nop                                                  ; $235a : $00
    set1 $ed.0                                                  ; $235b : $02, $ed
    cmp $ab, #$f8                                                  ; $235d : $78, $f8, $ab
    set1 $f9.0                                                  ; $2360 : $02, $f9
    nop                                                  ; $2362 : $00
    tcall 0                                                  ; $2363 : $01
    notc                                                  ; $2364 : $ed
    cmp A, #$f8                                                  ; $2365 : $68, $f8
    sbc A, #$02                                                  ; $2367 : $a8, $02
    mov X, $00+Y                                                  ; $2369 : $f9, $00
    tcall 0                                                  ; $236b : $01
    notc                                                  ; $236c : $ed
    cmp A, $f8                                                  ; $236d : $64, $f8
    sbc A, !$ed01                                                  ; $236f : $a5, $01, $ed
    eor $a3, #$f8                                                  ; $2372 : $58, $f8, $a3
    set1 $f9.0                                                  ; $2375 : $02, $f9
    nop                                                  ; $2377 : $00
    stop                                                  ; $2378 : $ff
    tcall 0                                                  ; $2379 : $01
    clrv                                                  ; $237a : $e0
    or A, [$f5+X]                                                  ; $237b : $07, $f5
    mov Y, $ed+X                                                  ; $237d : $fb, $ed
    cmp $a7, #$f8                                                  ; $237f : $78, $f8, $a7
    set1 $f9.0                                                  ; $2382 : $02, $f9
    nop                                                  ; $2384 : $00
    tcall 0                                                  ; $2385 : $01
    mov X, $a6                                                  ; $2386 : $f8, $a6
    set1 $f9.0                                                  ; $2388 : $02, $f9
    nop                                                  ; $238a : $00
    tcall 0                                                  ; $238b : $01
    mov X, $a7                                                  ; $238c : $f8, $a7
    set1 $f9.0                                                  ; $238e : $02, $f9
    nop                                                  ; $2390 : $00

br_00_2391:
    tcall 0                                                  ; $2391 : $01
    mov X, $a7                                                  ; $2392 : $f8, $a7
    set1 $f9.0                                                  ; $2394 : $02, $f9
    nop                                                  ; $2396 : $00
    tcall 0                                                  ; $2397 : $01
    mov X, $a6                                                  ; $2398 : $f8, $a6

Jump_00_239a:
    set1 $f9.0                                                  ; $239a : $02, $f9
    nop                                                  ; $239c : $00
    tcall 0                                                  ; $239d : $01
    mov X, $a7                                                  ; $239e : $f8, $a7
    set1 $f9.0                                                  ; $23a0 : $02, $f9
    nop                                                  ; $23a2 : $00
    stop                                                  ; $23a3 : $ff

br_00_23a4:
    tcall 0                                                  ; $23a4 : $01
    clrv                                                  ; $23a5 : $e0
    or A, [$f5+X]                                                  ; $23a6 : $07, $f5
    mov Y, $ed+X                                                  ; $23a8 : $fb, $ed
    cmp $a5, #$f8                                                  ; $23aa : $78, $f8, $a5
    set1 $f9.0                                                  ; $23ad : $02, $f9

br_00_23af:
    nop                                                  ; $23af : $00
    tcall 0                                                  ; $23b0 : $01
    mov X, $a4                                                  ; $23b1 : $f8, $a4
    set1 $f9.0                                                  ; $23b3 : $02, $f9
    nop                                                  ; $23b5 : $00
    tcall 0                                                  ; $23b6 : $01

br_00_23b7:
    mov X, $a5                                                  ; $23b7 : $f8, $a5
    set1 $f9.0                                                  ; $23b9 : $02, $f9
    nop                                                  ; $23bb : $00

Call_00_23bc:
    tcall 0                                                  ; $23bc : $01
    mov X, $a5                                                  ; $23bd : $f8, $a5
    set1 $f9.0                                                  ; $23bf : $02, $f9
    nop                                                  ; $23c1 : $00
    tcall 0                                                  ; $23c2 : $01
    mov X, $a4                                                  ; $23c3 : $f8, $a4

br_00_23c5:
    set1 $f9.0                                                  ; $23c5 : $02, $f9
    nop                                                  ; $23c7 : $00
    tcall 0                                                  ; $23c8 : $01
    mov X, $a5                                                  ; $23c9 : $f8, $a5
    set1 $f9.0                                                  ; $23cb : $02, $f9

br_00_23cd:
    nop                                                  ; $23cd : $00
    stop                                                  ; $23ce : $ff
    bbs $e0.0, $30                                                  ; $23cf : $03, $e0, $30

    mov A, !$edfb+X                                                  ; $23d2 : $f5, $fb, $ed
    cmp $99, #$f8                                                  ; $23d5 : $78, $f8, $99
    set1 $f9.0                                                  ; $23d8 : $02, $f9
    nop                                                  ; $23da : $00

br_00_23db:
    bbs $f8.0, -$60                                                  ; $23db : $03, $f8, $a0

    set1 $f9.0                                                  ; $23de : $02, $f9
    nop                                                  ; $23e0 : $00
    stop                                                  ; $23e1 : $ff
    bbs $e0.0, $30                                                  ; $23e2 : $03, $e0, $30

    mov A, !$edfb+X                                                  ; $23e5 : $f5, $fb, $ed
    cmp $99, #$f8                                                  ; $23e8 : $78, $f8, $99

br_00_23eb:
    set1 $f9.0                                                  ; $23eb : $02, $f9
    nop                                                  ; $23ed : $00
    bbs $f8.0, br_00_2391                                                  ; $23ee : $03, $f8, $a0

Jump_00_23f1:
    set1 $f9.0                                                  ; $23f1 : $02, $f9
    nop                                                  ; $23f3 : $00
    stop                                                  ; $23f4 : $ff
    set1 $e0.0                                                  ; $23f5 : $02, $e0
    and A, $f5+X                                                  ; $23f7 : $34, $f5

br_00_23f9:
    notc                                                  ; $23f9 : $ed
    clrc                                                  ; $23fa : $60
    mov Y, $f8+X                                                  ; $23fb : $fb, $f8
    xcn A                                                  ; $23fd : $9f
    set1 $f9.0                                                  ; $23fe : $02, $f9

br_00_2400:
    nop                                                  ; $2400 : $00
    bbs $f8.0, br_00_23a4                                                  ; $2401 : $03, $f8, $a0

    set1 $f9.0                                                  ; $2404 : $02, $f9
    nop                                                  ; $2406 : $00
    stop                                                  ; $2407 : $ff

br_00_2408:
    set1 $e0.0                                                  ; $2408 : $02, $e0
    and A, $f5+X                                                  ; $240a : $34, $f5
    notc                                                  ; $240c : $ed
    clrc                                                  ; $240d : $60

Jump_00_240e:
    mov Y, $f8+X                                                  ; $240e : $fb, $f8
    xcn A                                                  ; $2410 : $9f
    set1 $f9.0                                                  ; $2411 : $02, $f9
    nop                                                  ; $2413 : $00
    bbs $f8.0, br_00_23b7                                                  ; $2414 : $03, $f8, $a0

    set1 $f9.0                                                  ; $2417 : $02, $f9
    nop                                                  ; $2419 : $00
    stop                                                  ; $241a : $ff
    bbs $e0.0, $38                                                  ; $241b : $03, $e0, $38

    bbc $f5.7, -$12                                                  ; $241e : $f3, $f5, $ee

    stop                                                  ; $2421 : $ff
    clr1 $fb.3                                                  ; $2422 : $72, $fb
    mov X, $80                                                  ; $2424 : $f8, $80
    set1 $f9.0                                                  ; $2426 : $02, $f9
    nop                                                  ; $2428 : $00
    bbs $f8.0, br_00_23af                                                  ; $2429 : $03, $f8, $83

    set1 $f9.0                                                  ; $242c : $02, $f9
    nop                                                  ; $242e : $00
    bbs $f8.0, br_00_23b7                                                  ; $242f : $03, $f8, $85

    set1 $f9.0                                                  ; $2432 : $02, $f9
    nop                                                  ; $2434 : $00
    bbs $f8.0, -$7a                                                  ; $2435 : $03, $f8, $86

    set1 $f9.0                                                  ; $2438 : $02, $f9
    nop                                                  ; $243a : $00
    bbs $f8.0, br_00_23c5                                                  ; $243b : $03, $f8, $87

    set1 $f9.0                                                  ; $243e : $02, $f9
    nop                                                  ; $2440 : $00
    bbs $f8.0, br_00_23cd                                                  ; $2441 : $03, $f8, $89

    set1 $f9.0                                                  ; $2444 : $02, $f9
    nop                                                  ; $2446 : $00
    bbs $f8.0, -$76                                                  ; $2447 : $03, $f8, $8a

    set1 $f9.0                                                  ; $244a : $02, $f9
    nop                                                  ; $244c : $00
    bbs $f8.0, br_00_23db                                                  ; $244d : $03, $f8, $8b

    set1 $f9.0                                                  ; $2450 : $02, $f9
    nop                                                  ; $2452 : $00

br_00_2453:
    stop                                                  ; $2453 : $ff
    bbs $e0.0, br_00_248f                                                  ; $2454 : $03, $e0, $38

    bbc $f5.7, -$12                                                  ; $2457 : $f3, $f5, $ee

    stop                                                  ; $245a : $ff
    clr1 $fb.3                                                  ; $245b : $72, $fb
    mov X, $82                                                  ; $245d : $f8, $82
    set1 $f9.0                                                  ; $245f : $02, $f9
    nop                                                  ; $2461 : $00
    bbs $f8.0, br_00_23eb                                                  ; $2462 : $03, $f8, $86

    set1 $f9.0                                                  ; $2465 : $02, $f9

br_00_2467:
    nop                                                  ; $2467 : $00
    bbs $f8.0, -$79                                                  ; $2468 : $03, $f8, $87

    set1 $f9.0                                                  ; $246b : $02, $f9
    nop                                                  ; $246d : $00
    bbs $f8.0, br_00_23f9                                                  ; $246e : $03, $f8, $88

    set1 $f9.0                                                  ; $2471 : $02, $f9
    nop                                                  ; $2473 : $00
    bbs $f8.0, br_00_2400                                                  ; $2474 : $03, $f8, $89

    set1 $f9.0                                                  ; $2477 : $02, $f9
    nop                                                  ; $2479 : $00
    bbs $f8.0, br_00_2408                                                  ; $247a : $03, $f8, $8b

    set1 $f9.0                                                  ; $247d : $02, $f9
    nop                                                  ; $247f : $00
    bbs $f8.0, -$74                                                  ; $2480 : $03, $f8, $8c

br_00_2483:
    set1 $f9.0                                                  ; $2483 : $02, $f9
    nop                                                  ; $2485 : $00
    bbs $f8.0, -$73                                                  ; $2486 : $03, $f8, $8d

    set1 $f9.0                                                  ; $2489 : $02, $f9
    nop                                                  ; $248b : $00
    stop                                                  ; $248c : $ff
    bra -$20                                                  ; $248d : $2f, $e0

br_00_248f:
    and $f2, #$f5                                                  ; $248f : $38, $f5, $f2
    tcall 0                                                  ; $2492 : $01
    or A, !$8100+X                                                  ; $2493 : $15, $00, $81
    notc                                                  ; $2496 : $ed

br_00_2497:
    bvs -$05                                                  ; $2497 : $70, $fb

    mov X, $81                                                  ; $2499 : $f8, $81
    dec X                                                  ; $249b : $1d
    bbc $ed.7, -$74                                                  ; $249c : $f3, $ed, $8c

    nop                                                  ; $249f : $00
    stop                                                  ; $24a0 : $ff
    bra br_00_2483                                                  ; $24a1 : $2f, $e0

    and $f2, #$f5                                                  ; $24a3 : $38, $f5, $f2
    tcall 0                                                  ; $24a6 : $01
    or A, !$8100+X                                                  ; $24a7 : $15, $00, $81
    notc                                                  ; $24aa : $ed

br_00_24ab:
    bvs -$05                                                  ; $24ab : $70, $fb

    mov X, $81                                                  ; $24ad : $f8, $81
    dec X                                                  ; $24af : $1d
    bbc $ed.7, -$74                                                  ; $24b0 : $f3, $ed, $8c

    nop                                                  ; $24b3 : $00
    stop                                                  ; $24b4 : $ff
    bra br_00_2497                                                  ; $24b5 : $2f, $e0

    and $f2, #$f5                                                  ; $24b7 : $38, $f5, $f2
    set1 $15.0                                                  ; $24ba : $02, $15

br_00_24bc:
    nop                                                  ; $24bc : $00
    adc A, (X)                                                  ; $24bd : $86
    notc                                                  ; $24be : $ed
    bvs br_00_24bc                                                  ; $24bf : $70, $fb

    mov X, $86                                                  ; $24c1 : $f8, $86
    dec X                                                  ; $24c3 : $1d
    bbc $ed.7, br_00_2453                                                  ; $24c4 : $f3, $ed, $8c

    nop                                                  ; $24c7 : $00
    stop                                                  ; $24c8 : $ff
    bra br_00_24ab                                                  ; $24c9 : $2f, $e0

    and $f2, #$f5                                                  ; $24cb : $38, $f5, $f2
    set1 $15.0                                                  ; $24ce : $02, $15

br_00_24d0:
    nop                                                  ; $24d0 : $00
    adc A, (X)                                                  ; $24d1 : $86
    notc                                                  ; $24d2 : $ed

br_00_24d3:
    bvs br_00_24d0                                                  ; $24d3 : $70, $fb

    mov X, $86                                                  ; $24d5 : $f8, $86
    dec X                                                  ; $24d7 : $1d
    bbc $ed.7, br_00_2467                                                  ; $24d8 : $f3, $ed, $8c

    nop                                                  ; $24db : $00
    stop                                                  ; $24dc : $ff
    asl !$34e0                                                  ; $24dd : $0c, $e0, $34
    notc                                                  ; $24e0 : $ed
    reti                                                  ; $24e1 : $7f


br_00_24e2:
    mov A, !$f2fb+X                                                  ; $24e2 : $f5, $fb, $f2
    tcall 0                                                  ; $24e5 : $01
    nop                                                  ; $24e6 : $00
    bbs $88.0, br_00_24e2                                                  ; $24e7 : $03, $88, $f8

    adc A, #$0c                                                  ; $24ea : $88, $0c
    notc                                                  ; $24ec : $ed
    mov Y, !wPendingCtrlTilNextTrackByte                                                  ; $24ed : $ec, $00, $02
    bbc $ed.7, br_00_24f3                                                  ; $24f0 : $f3, $ed, $00

br_00_24f3:
    nop                                                  ; $24f3 : $00
    stop                                                  ; $24f4 : $ff
    asl !$34e0                                                  ; $24f5 : $0c, $e0, $34
    notc                                                  ; $24f8 : $ed
    ret                                                  ; $24f9 : $6f


br_00_24fa:
    mov A, !$f2fb+X                                                  ; $24fa : $f5, $fb, $f2
    tcall 0                                                  ; $24fd : $01
    nop                                                  ; $24fe : $00
    bbs $88.0, br_00_24fa                                                  ; $24ff : $03, $88, $f8

    adc A, #$0c                                                  ; $2502 : $88, $0c
    notc                                                  ; $2504 : $ed
    mov Y, !wPendingCtrlTilNextTrackByte                                                  ; $2505 : $ec, $00, $02
    bbc $ed.7, br_00_250b                                                  ; $2508 : $f3, $ed, $00

br_00_250b:
    nop                                                  ; $250b : $00
    stop                                                  ; $250c : $ff
    bbs $e0.0, $33                                                  ; $250d : $03, $e0, $33

    notc                                                  ; $2510 : $ed
    clr1 $f5.7                                                  ; $2511 : $f2, $f5
    mov Y, $f2+X                                                  ; $2513 : $fb, $f2
    set1 $a0.0                                                  ; $2515 : $02, $a0
    set1 $a8.0                                                  ; $2517 : $02, $a8
    mov X, $a8                                                  ; $2519 : $f8, $a8
    or A, #$ed                                                  ; $251b : $08, $ed
    reti                                                  ; $251d : $7f


    nop                                                  ; $251e : $00
    or A, (X)                                                  ; $251f : $06
    bbc $ed.7, -$68                                                  ; $2520 : $f3, $ed, $98

    nop                                                  ; $2523 : $00
    stop                                                  ; $2524 : $ff
    bbs $e0.0, $33                                                  ; $2525 : $03, $e0, $33

    notc                                                  ; $2528 : $ed
    clr1 $f5.7                                                  ; $2529 : $f2, $f5
    mov Y, $f2+X                                                  ; $252b : $fb, $f2
    set1 $a0.0                                                  ; $252d : $02, $a0
    set1 $a8.0                                                  ; $252f : $02, $a8
    mov X, $a8                                                  ; $2531 : $f8, $a8
    or A, #$ed                                                  ; $2533 : $08, $ed
    reti                                                  ; $2535 : $7f


    nop                                                  ; $2536 : $00
    or A, (X)                                                  ; $2537 : $06
    bbc $ed.7, br_00_24d3                                                  ; $2538 : $f3, $ed, $98

    nop                                                  ; $253b : $00
    stop                                                  ; $253c : $ff
    asl !$39e0                                                  ; $253d : $0c, $e0, $39
    notc                                                  ; $2540 : $ed
    eor $fa, #$f5                                                  ; $2541 : $58, $f5, $fa
    clr1 $01.7                                                  ; $2544 : $f2, $01
    setc                                                  ; $2546 : $80
    tcall 0                                                  ; $2547 : $01
    tcall 8                                                  ; $2548 : $81

br_00_2549:
    mov X, $81                                                  ; $2549 : $f8, $81
    asl !$eced                                                  ; $254b : $0c, $ed, $ec
    nop                                                  ; $254e : $00

br_00_254f:
    set1 $f3.3                                                  ; $254f : $62, $f3
    notc                                                  ; $2551 : $ed
    nop                                                  ; $2552 : $00
    nop                                                  ; $2553 : $00
    stop                                                  ; $2554 : $ff
    asl !$39e0                                                  ; $2555 : $0c, $e0, $39
    notc                                                  ; $2558 : $ed
    eor $fa, #$f5                                                  ; $2559 : $58, $f5, $fa
    clr1 $01.7                                                  ; $255c : $f2, $01
    setc                                                  ; $255e : $80
    tcall 0                                                  ; $255f : $01
    tcall 8                                                  ; $2560 : $81
    mov X, $81                                                  ; $2561 : $f8, $81
    asl !$eced                                                  ; $2563 : $0c, $ed, $ec
    nop                                                  ; $2566 : $00
    set1 $f3.3                                                  ; $2567 : $62, $f3
    notc                                                  ; $2569 : $ed
    nop                                                  ; $256a : $00
    nop                                                  ; $256b : $00
    stop                                                  ; $256c : $ff
    bra br_00_254f                                                  ; $256d : $2f, $e0

    and (X), (Y)                                                  ; $256f : $39
    mov A, !$f2fb+X                                                  ; $2570 : $f5, $fb, $f2
    set1 $12.0                                                  ; $2573 : $02, $12
    nop                                                  ; $2575 : $00
    adc A, !$58ed                                                  ; $2576 : $85, $ed, $58
    mov A, $f8                                                  ; $2579 : $e4, $f8
    adc A, !$f31d                                                  ; $257b : $85, $1d, $f3
    notc                                                  ; $257e : $ed
    dec !$ff00                                                  ; $257f : $8c, $00, $ff
    bra -$20                                                  ; $2582 : $2f, $e0

    and (X), (Y)                                                  ; $2584 : $39
    mov A, !$f2fb+X                                                  ; $2585 : $f5, $fb, $f2
    set1 $12.0                                                  ; $2588 : $02, $12
    nop                                                  ; $258a : $00
    adc A, !$58ed                                                  ; $258b : $85, $ed, $58
    mov A, $f8                                                  ; $258e : $e4, $f8
    adc A, !$f31d                                                  ; $2590 : $85, $1d, $f3
    notc                                                  ; $2593 : $ed
    dec !$ff00                                                  ; $2594 : $8c, $00, $ff
    and A, #$e0                                                  ; $2597 : $28, $e0
    inc X                                                  ; $2599 : $3d
    notc                                                  ; $259a : $ed
    mov Y, $f5                                                  ; $259b : $eb, $f5
    mov $f8, $f3                                                  ; $259d : $fa, $f3, $f8
    sbc A, $7f+X                                                  ; $25a0 : $b4, $7f
    notc                                                  ; $25a2 : $ed
    pop A                                                  ; $25a3 : $ae
    nop                                                  ; $25a4 : $00
    reti                                                  ; $25a5 : $7f


    nop                                                  ; $25a6 : $00
    stop                                                  ; $25a7 : $ff
    rol A                                                  ; $25a8 : $3c
    clrv                                                  ; $25a9 : $e0
    rol A                                                  ; $25aa : $3c
    notc                                                  ; $25ab : $ed
    rol A                                                  ; $25ac : $3c
    mov A, !$f3fb+X                                                  ; $25ad : $f5, $fb, $f3
    mov X, $8e                                                  ; $25b0 : $f8, $8e
    clrc                                                  ; $25b2 : $60
    clr1 $02.7                                                  ; $25b3 : $f2, $02
    bpl br_00_25b7                                                  ; $25b5 : $10, $00

br_00_25b7:
    bcc br_00_2549                                                  ; $25b7 : $90, $90

    reti                                                  ; $25b9 : $7f


    .db $f3, $00, $7f

    nop                                                  ; $25bd : $00
    reti                                                  ; $25be : $7f


    nop                                                  ; $25bf : $00
    stop                                                  ; $25c0 : $ff
    rol A                                                  ; $25c1 : $3c
    clrv                                                  ; $25c2 : $e0
    rol A                                                  ; $25c3 : $3c
    notc                                                  ; $25c4 : $ed
    rol A                                                  ; $25c5 : $3c
    mov A, !$f3fb+X                                                  ; $25c6 : $f5, $fb, $f3
    mov X, $8e                                                  ; $25c9 : $f8, $8e
    clrc                                                  ; $25cb : $60
    clr1 $02.7                                                  ; $25cc : $f2, $02
    bpl br_00_25d0                                                  ; $25ce : $10, $00

br_00_25d0:
    bcc -$70                                                  ; $25d0 : $90, $90

br_00_25d2:
    reti                                                  ; $25d2 : $7f


    .db $f3, $00, $7f

    nop                                                  ; $25d6 : $00
    reti                                                  ; $25d7 : $7f


    nop                                                  ; $25d8 : $00
    stop                                                  ; $25d9 : $ff
    rol !$3ce0                                                  ; $25da : $2c, $e0, $3c
    notc                                                  ; $25dd : $ed
    eor A, (X)                                                  ; $25de : $46
    mov A, !$f3fb+X                                                  ; $25df : $f5, $fb, $f3
    mov X, $84                                                  ; $25e2 : $f8, $84
    clrc                                                  ; $25e4 : $60
    clr1 $02.7                                                  ; $25e5 : $f2, $02
    or A, #$00                                                  ; $25e7 : $08, $00
    adc A, #$00                                                  ; $25e9 : $88, $00
    reti                                                  ; $25eb : $7f


    .db $f3, $00, $7f

    nop                                                  ; $25ef : $00
    reti                                                  ; $25f0 : $7f


    nop                                                  ; $25f1 : $00
    reti                                                  ; $25f2 : $7f


    nop                                                  ; $25f3 : $00
    reti                                                  ; $25f4 : $7f


    nop                                                  ; $25f5 : $00
    stop                                                  ; $25f6 : $ff
    ror !$3ce0                                                  ; $25f7 : $6c, $e0, $3c
    notc                                                  ; $25fa : $ed
    eor A, (X)                                                  ; $25fb : $46
    mov A, !$f3fb+X                                                  ; $25fc : $f5, $fb, $f3
    mov X, $82                                                  ; $25ff : $f8, $82
    clrc                                                  ; $2601 : $60
    clr1 $02.7                                                  ; $2602 : $f2, $02
    tcall 0                                                  ; $2604 : $01
    nop                                                  ; $2605 : $00
    adc A, $00                                                  ; $2606 : $84, $00
    reti                                                  ; $2608 : $7f


    .db $f3, $00, $7f

    nop                                                  ; $260c : $00
    reti                                                  ; $260d : $7f


    nop                                                  ; $260e : $00
    reti                                                  ; $260f : $7f


    nop                                                  ; $2610 : $00
    reti                                                  ; $2611 : $7f


    nop                                                  ; $2612 : $00
    stop                                                  ; $2613 : $ff


SoundEffectsB_01hTo1Ch:
; 0 -
; 1/2 - Track 5 data ptr
; 3/4 - Track 4 data ptr
; 5/6 - Track 1 data ptr
; 7/8 - Track 0 data ptr
	.db $8f, $19, $27, $7f, $1e, $7f, $1e, $7f, $1e
	.db $8f, $3e, $27, $4f, $27, $7f, $1e, $7f, $1e
	.db $8f, $71, $27, $82, $27, $93, $27, $a4, $27
	.db $8f, $b5, $27, $db, $27, $7f, $1e, $7f, $1e
	.db $8f, $01, $28, $7f, $1e, $7f, $1e, $7f, $1e
	.db $8f, $b5, $27, $db, $27, $01, $28, $7f, $1e
	.db $8f, $12, $28, $38, $28, $5e, $28, $6f, $28
	.db $8f, $99, $28, $b3, $28, $7f, $1e, $7f, $1e
	.db $8f, $cd, $28, $ea, $28, $7f, $1e, $7f, $1e
	.db $8f, $07, $29, $1b, $29, $7f, $1e, $7f, $1e
	.db $8f, $2f, $29, $7f, $1e, $7f, $1e, $7f, $1e
	.db $8f, $45, $29, $53, $29, $7f, $1e, $7f, $1e
	.db $8f, $6f, $29, $7d, $29, $7f, $1e, $7f, $1e
	.db $8f, $e4, $29, $7f, $1e, $7f, $1e, $7f, $1e
	.db $8f, $f8, $29, $7f, $1e, $7f, $1e, $7f, $1e
	.db $8f, $13, $2a, $7f, $1e, $7f, $1e, $7f, $1e
	.db $8f, $8b, $29, $7f, $1e, $7f, $1e, $7f, $1e
	.db $8f, $99, $29, $7f, $1e, $7f, $1e, $7f, $1e
	.db $8f, $a7, $29, $7f, $1e, $7f, $1e, $7f, $1e
	.db $8f, $b5, $29, $7f, $1e, $7f, $1e, $7f, $1e
	.db $8f, $c4, $29, $7f, $1e, $7f, $1e, $7f, $1e
	.db $8f, $d3, $29, $7f, $1e, $7f, $1e, $7f, $1e
	.db $8f, $31, $2a, $43, $2a, $55, $2a, $67, $2a
	.db $8f, $79, $2a, $7f, $1e, $7f, $1e, $7f, $1e
	.db $8f, $9b, $2a, $7f, $1e, $7f, $1e, $7f, $1e
	.db $8f, $9b, $2a, $7f, $1e, $7f, $1e, $7f, $1e
	.db $8f, $9b, $2a, $7f, $1e, $7f, $1e, $7f, $1e
	.db $8f, $9b, $2a, $7f, $1e, $7f, $1e, $7f, $1e
    
    
SoundEffectsB_1Dh:
	.db $8f, $9b, $2a, $7f, $1e, $7f, $1e, $7f, $1e



    reti                                                  ; $2719 : $7f


    clrv                                                  ; $271a : $e0
    and A, [$ed]+Y                                                  ; $271b : $37, $ed
    setp                                                  ; $271d : $40
    mov Y, $f5+X                                                  ; $271e : $fb, $f5
    bbc $f8.7, -$7a                                                  ; $2720 : $f3, $f8, $86

    reti                                                  ; $2723 : $7f


br_00_2724:
    mov A, !$3f86+X                                                  ; $2724 : $f5, $86, $3f
    mov A, !$0286+X                                                  ; $2727 : $f5, $86, $02
    mov A, !$fd86+X                                                  ; $272a : $f5, $86, $fd
    reti                                                  ; $272d : $7f


    clrv                                                  ; $272e : $e0
    and A, [$ed]+Y                                                  ; $272f : $37, $ed
    setp                                                  ; $2731 : $40
    mov Y, $f5+X                                                  ; $2732 : $fb, $f5

br_00_2734:
    .db $f3, $f8, $83

    call !$83f5                                                  ; $2737 : $3f, $f5, $83
    set1 $f5.0                                                  ; $273a : $02, $f5
    bbs $fd.4, br_00_27be                                                  ; $273c : $83, $fd, $7f

    clrv                                                  ; $273f : $e0
    and A, [$ed]+Y                                                  ; $2740 : $37, $ed
    eor A, #$fb                                                  ; $2742 : $48, $fb
    mov A, !$f8f3+X                                                  ; $2744 : $f5, $f3, $f8
    adc A, (X)                                                  ; $2747 : $86
    call !$86f5                                                  ; $2748 : $3f, $f5, $86
    set1 $f5.0                                                  ; $274b : $02, $f5
    adc A, (X)                                                  ; $274d : $86
    mov Y, A                                                  ; $274e : $fd
    reti                                                  ; $274f : $7f


br_00_2750:
    clrv                                                  ; $2750 : $e0
    and A, [$ed]+Y                                                  ; $2751 : $37, $ed

br_00_2753:
    eor A, #$fb                                                  ; $2753 : $48, $fb
    mov A, !$f8f3+X                                                  ; $2755 : $f5, $f3, $f8
    bbs $3f.4, br_00_2750                                                  ; $2758 : $83, $3f, $f5

    bbs $02.4, br_00_2753                                                  ; $275b : $83, $02, $f5

    bbs $fd.4, $7f                                                  ; $275e : $83, $fd, $7f

    clrv                                                  ; $2761 : $e0
    and A, [$ed]+Y                                                  ; $2762 : $37, $ed
    eor A, #$fa                                                  ; $2764 : $48, $fa
    mov A, !$f8f3+X                                                  ; $2766 : $f5, $f3, $f8
    tcall 8                                                  ; $2769 : $81
    call !$81f5                                                  ; $276a : $3f, $f5, $81
    set1 $f5.0                                                  ; $276d : $02, $f5
    tcall 8                                                  ; $276f : $81
    mov Y, A                                                  ; $2770 : $fd
    reti                                                  ; $2771 : $7f


    clrv                                                  ; $2772 : $e0
    and A, [$ed]+Y                                                  ; $2773 : $37, $ed
    and $f5, #$fb                                                  ; $2775 : $38, $fb, $f5
    .db $f3, $f8, $8c

    call !$8cf5                                                  ; $277b : $3f, $f5, $8c
    set1 $f5.0                                                  ; $277e : $02, $f5
    dec !$7ffd                                                  ; $2780 : $8c, $fd, $7f
    clrv                                                  ; $2783 : $e0
    and A, [$ed]+Y                                                  ; $2784 : $37, $ed
    and $f5, #$fb                                                  ; $2786 : $38, $fb, $f5
    .db $f3, $f8, $89

    call !$89f5                                                  ; $278c : $3f, $f5, $89
    set1 $f5.0                                                  ; $278f : $02, $f5
    adc $7f, $fd                                                  ; $2791 : $89, $fd, $7f
    clrv                                                  ; $2794 : $e0
    and A, [$ed]+Y                                                  ; $2795 : $37, $ed
    and $f5, #$fa                                                  ; $2797 : $38, $fa, $f5
    bbc $f8.7, br_00_2724                                                  ; $279a : $f3, $f8, $87

    call !$87f5                                                  ; $279d : $3f, $f5, $87
    set1 $f5.0                                                  ; $27a0 : $02, $f5
    adc A, [$fd+X]                                                  ; $27a2 : $87, $fd
    reti                                                  ; $27a4 : $7f


    clrv                                                  ; $27a5 : $e0
    and A, [$ed]+Y                                                  ; $27a6 : $37, $ed
    and $f5, #$fb                                                  ; $27a8 : $38, $fb, $f5
    bbc $f8.7, br_00_2734                                                  ; $27ab : $f3, $f8, $86

    call !$86f5                                                  ; $27ae : $3f, $f5, $86
    set1 $f5.0                                                  ; $27b1 : $02, $f5
    adc A, (X)                                                  ; $27b3 : $86
    mov Y, A                                                  ; $27b4 : $fd
    call !$3ee0                                                  ; $27b5 : $3f, $e0, $3e
    notc                                                  ; $27b8 : $ed
    or A, $fb+X                                                  ; $27b9 : $14, $fb
    mov A, !$f8f3+X                                                  ; $27bb : $f5, $f3, $f8

br_00_27be:
    adc A, (X)                                                  ; $27be : $86
    reti                                                  ; $27bf : $7f


    notc                                                  ; $27c0 : $ed
    and A, $f5                                                  ; $27c1 : $24, $f5
    clr1 $01.7                                                  ; $27c3 : $f2, $01
    bpl br_00_27c7                                                  ; $27c5 : $10, $00

br_00_27c7:
    adc A, (X)                                                  ; $27c7 : $86
    adc A, (X)                                                  ; $27c8 : $86
    pcall $f5                                                  ; $27c9 : $4f, $f5
    nop                                                  ; $27cb : $00
    reti                                                  ; $27cc : $7f


    mov A, !$02f2+X                                                  ; $27cd : $f5, $f2, $02
    or $92, #$00                                                  ; $27d0 : $18, $00, $92
    clr1 $6f.4                                                  ; $27d3 : $92, $6f
    notc                                                  ; $27d5 : $ed
    asl A                                                  ; $27d6 : $1c
    bbc $f5.7, br_00_27da                                                  ; $27d7 : $f3, $f5, $00

br_00_27da:
    dbnz Y, $07                                                  ; $27da : $fe, $07

    clrv                                                  ; $27dc : $e0
    cmp X, $ed                                                  ; $27dd : $3e, $ed
    or A, $fb+X                                                  ; $27df : $14, $fb
    mov A, !$f8f3+X                                                  ; $27e1 : $f5, $f3, $f8
    adc A, (X)                                                  ; $27e4 : $86
    reti                                                  ; $27e5 : $7f


    notc                                                  ; $27e6 : $ed
    and A, $f5                                                  ; $27e7 : $24, $f5
    clr1 $01.7                                                  ; $27e9 : $f2, $01
    bpl br_00_27ed                                                  ; $27eb : $10, $00

br_00_27ed:
    adc A, (X)                                                  ; $27ed : $86
    adc A, (X)                                                  ; $27ee : $86
    pcall $f5                                                  ; $27ef : $4f, $f5
    nop                                                  ; $27f1 : $00
    reti                                                  ; $27f2 : $7f


    mov A, !$02f2+X                                                  ; $27f3 : $f5, $f2, $02
    or $92, #$00                                                  ; $27f6 : $18, $00, $92
    clr1 $6f.4                                                  ; $27f9 : $92, $6f
    notc                                                  ; $27fb : $ed
    asl A                                                  ; $27fc : $1c
    bbc $f5.7, br_00_2800                                                  ; $27fd : $f3, $f5, $00

br_00_2800:
    dbnz Y, $4f                                                  ; $2800 : $fe, $4f

    clrv                                                  ; $2802 : $e0
    inc X                                                  ; $2803 : $3d
    notc                                                  ; $2804 : $ed
    and $f5, #$fb                                                  ; $2805 : $38, $fb, $f5
    bbc $f8.7, -$72                                                  ; $2808 : $f3, $f8, $8e

    pcall $f5                                                  ; $280b : $4f, $f5
    pop PSW                                                  ; $280d : $8e
    set1 $f5.0                                                  ; $280e : $02, $f5
    pop PSW                                                  ; $2810 : $8e
    mov Y, A                                                  ; $2811 : $fd
    call !$3ee0                                                  ; $2812 : $3f, $e0, $3e
    notc                                                  ; $2815 : $ed
    or A, $fb+X                                                  ; $2816 : $14, $fb
    mov A, !$f8f3+X                                                  ; $2818 : $f5, $f3, $f8
    eor1 c, $0d7f.7                                                  ; $281b : $8a, $7f, $ed
    asl A                                                  ; $281e : $1c
    mov A, !$01f2+X                                                  ; $281f : $f5, $f2, $01
    bpl br_00_2824                                                  ; $2822 : $10, $00

br_00_2824:
    eor1 c, $0f8a.2                                                  ; $2824 : $8a, $8a, $4f
    mov A, !$7f00+X                                                  ; $2827 : $f5, $00, $7f
    mov A, !$02f2+X                                                  ; $282a : $f5, $f2, $02
    or $96, #$00                                                  ; $282d : $18, $00, $96
    adc A, !$ed6f+Y                                                  ; $2830 : $96, $6f, $ed
    or A, $f3+X                                                  ; $2833 : $14, $f3
    mov A, !$fe00+X                                                  ; $2835 : $f5, $00, $fe
    or A, [$e0+X]                                                  ; $2838 : $07, $e0
    cmp X, $ed                                                  ; $283a : $3e, $ed
    or A, $fb+X                                                  ; $283c : $14, $fb
    mov A, !$f8f3+X                                                  ; $283e : $f5, $f3, $f8
    adc A, (X)                                                  ; $2841 : $86
    reti                                                  ; $2842 : $7f


    notc                                                  ; $2843 : $ed
    asl A                                                  ; $2844 : $1c
    mov A, !$01f2+X                                                  ; $2845 : $f5, $f2, $01
    bpl br_00_284a                                                  ; $2848 : $10, $00

br_00_284a:
    adc A, (X)                                                  ; $284a : $86
    adc A, (X)                                                  ; $284b : $86
    pcall $f5                                                  ; $284c : $4f, $f5
    nop                                                  ; $284e : $00
    reti                                                  ; $284f : $7f


    mov A, !$02f2+X                                                  ; $2850 : $f5, $f2, $02
    or $92, #$00                                                  ; $2853 : $18, $00, $92
    clr1 $6f.4                                                  ; $2856 : $92, $6f
    notc                                                  ; $2858 : $ed
    or A, $f3+X                                                  ; $2859 : $14, $f3
    mov A, !$fe00+X                                                  ; $285b : $f5, $00, $fe
    pcall $e0                                                  ; $285e : $4f, $e0
    inc X                                                  ; $2860 : $3d
    notc                                                  ; $2861 : $ed
    eor A, #$f5                                                  ; $2862 : $48, $f5
    mov Y, $f3+X                                                  ; $2864 : $fb, $f3
    mov X, $8c                                                  ; $2866 : $f8, $8c
    pcall $f5                                                  ; $2868 : $4f, $f5
    dec !$f502                                                  ; $286a : $8c, $02, $f5
    dec !$47fd                                                  ; $286d : $8c, $fd, $47
    clrv                                                  ; $2870 : $e0
    cmp X, $ed                                                  ; $2871 : $3e, $ed
    or A, $fa+X                                                  ; $2873 : $14, $fa
    mov A, !$f8f3+X                                                  ; $2875 : $f5, $f3, $f8
    eor1 c, $0d7f.7                                                  ; $2878 : $8a, $7f, $ed
    asl A                                                  ; $287b : $1c
    mov A, !$01f2+X                                                  ; $287c : $f5, $f2, $01
    or $8a, #$00                                                  ; $287f : $18, $00, $8a
    eor1 c, $152f.7                                                  ; $2882 : $8a, $2f, $f5
    nop                                                  ; $2885 : $00
    bra -$0b                                                  ; $2886 : $2f, $f5

    bbc $00.7, $7f                                                  ; $2888 : $f3, $00, $7f

    mov A, !$02f2+X                                                  ; $288b : $f5, $f2, $02
    clrp                                                  ; $288e : $20
    nop                                                  ; $288f : $00
    dec A                                                  ; $2890 : $9c
    dec A                                                  ; $2891 : $9c
    ret                                                  ; $2892 : $6f


br_00_2893:
    notc                                                  ; $2893 : $ed
    or A, $f3+X                                                  ; $2894 : $14, $f3
    mov A, !$fe00+X                                                  ; $2896 : $f5, $00, $fe
    rol A                                                  ; $2899 : $3c
    clrv                                                  ; $289a : $e0
    rol A                                                  ; $289b : $3c
    notc                                                  ; $289c : $ed
    rol A                                                  ; $289d : $3c
    mov A, !$f3fb+X                                                  ; $289e : $f5, $fb, $f3
    mov X, $8e                                                  ; $28a1 : $f8, $8e
    clrc                                                  ; $28a3 : $60
    clr1 $02.7                                                  ; $28a4 : $f2, $02
    bpl br_00_28a8                                                  ; $28a6 : $10, $00

br_00_28a8:
    bcc -$0b                                                  ; $28a8 : $90, $f5

    bcc $7f                                                  ; $28aa : $90, $7f

    bbc $f5.7, br_00_28af                                                  ; $28ac : $f3, $f5, $00

br_00_28af:
    jmp !$00f5                                                  ; $28af : $5f, $f5, $00


    dbnz Y, $3c                                                  ; $28b2 : $fe, $3c

    clrv                                                  ; $28b4 : $e0
    rol A                                                  ; $28b5 : $3c
    notc                                                  ; $28b6 : $ed
    rol A                                                  ; $28b7 : $3c
    mov A, !$f3fb+X                                                  ; $28b8 : $f5, $fb, $f3
    mov X, $8e                                                  ; $28bb : $f8, $8e
    clrc                                                  ; $28bd : $60
    clr1 $02.7                                                  ; $28be : $f2, $02
    bpl br_00_28c2                                                  ; $28c0 : $10, $00

br_00_28c2:
    bcc -$0b                                                  ; $28c2 : $90, $f5

    bcc br_00_2945                                                  ; $28c4 : $90, $7f

    bbc $f5.7, br_00_28c9                                                  ; $28c6 : $f3, $f5, $00

br_00_28c9:
    jmp !$00f5                                                  ; $28c9 : $5f, $f5, $00


    dbnz Y, $2c                                                  ; $28cc : $fe, $2c

    clrv                                                  ; $28ce : $e0
    rol A                                                  ; $28cf : $3c
    notc                                                  ; $28d0 : $ed
    eor A, (X)                                                  ; $28d1 : $46
    mov A, !$f3fb+X                                                  ; $28d2 : $f5, $fb, $f3
    mov X, $84                                                  ; $28d5 : $f8, $84
    clrc                                                  ; $28d7 : $60
    clr1 $02.7                                                  ; $28d8 : $f2, $02
    or A, #$00                                                  ; $28da : $08, $00

br_00_28dc:
    adc A, #$f5                                                  ; $28dc : $88, $f5
    nop                                                  ; $28de : $00
    reti                                                  ; $28df : $7f


    bbc $f5.7, br_00_28e3                                                  ; $28e0 : $f3, $f5, $00

br_00_28e3:
    reti                                                  ; $28e3 : $7f


    mov A, !$7f00+X                                                  ; $28e4 : $f5, $00, $7f

br_00_28e7:
    mov A, !$fe00+X                                                  ; $28e7 : $f5, $00, $fe
    ror !$3ce0                                                  ; $28ea : $6c, $e0, $3c
    notc                                                  ; $28ed : $ed
    eor A, (X)                                                  ; $28ee : $46
    mov A, !$f3fb+X                                                  ; $28ef : $f5, $fb, $f3

br_00_28f2:
    mov X, $82                                                  ; $28f2 : $f8, $82
    clrc                                                  ; $28f4 : $60
    clr1 $02.7                                                  ; $28f5 : $f2, $02
    tcall 0                                                  ; $28f7 : $01
    nop                                                  ; $28f8 : $00
    adc A, $f5                                                  ; $28f9 : $84, $f5
    nop                                                  ; $28fb : $00
    reti                                                  ; $28fc : $7f


    bbc $f5.7, br_00_2900                                                  ; $28fd : $f3, $f5, $00

br_00_2900:
    reti                                                  ; $2900 : $7f


    mov A, !$7f00+X                                                  ; $2901 : $f5, $00, $7f
    mov A, !$fe00+X                                                  ; $2904 : $f5, $00, $fe
    reti                                                  ; $2907 : $7f


    clrv                                                  ; $2908 : $e0
    and A, [$ed]+Y                                                  ; $2909 : $37, $ed
    lsr !$fbf5                                                  ; $290b : $4c, $f5, $fb
    bbc $f8.7, br_00_2893                                                  ; $290e : $f3, $f8, $82

    reti                                                  ; $2911 : $7f


    mov A, !$7f82+X                                                  ; $2912 : $f5, $82, $7f
    mov A, !$0282+X                                                  ; $2915 : $f5, $82, $02
    mov A, !$fd82+X                                                  ; $2918 : $f5, $82, $fd
    reti                                                  ; $291b : $7f


    clrv                                                  ; $291c : $e0
    and A, [$ed]+Y                                                  ; $291d : $37, $ed
    lsr !$fbf5                                                  ; $291f : $4c, $f5, $fb
    bbc $f8.7, -$7e                                                  ; $2922 : $f3, $f8, $82

    reti                                                  ; $2925 : $7f


    mov A, !$7f82+X                                                  ; $2926 : $f5, $82, $7f
    mov A, !$0282+X                                                  ; $2929 : $f5, $82, $02
    mov A, !$fd82+X                                                  ; $292c : $f5, $82, $fd
    and A, #$e0                                                  ; $292f : $28, $e0
    inc X                                                  ; $2931 : $3d
    notc                                                  ; $2932 : $ed
    mov Y, $f5                                                  ; $2933 : $eb, $f5
    mov Y, $f3+X                                                  ; $2935 : $fb, $f3
    mov X, $9c                                                  ; $2937 : $f8, $9c
    call !$aeed                                                  ; $2939 : $3f, $ed, $ae
    mov A, !$7f00+X                                                  ; $293c : $f5, $00, $7f
    mov A, !$3f00+X                                                  ; $293f : $f5, $00, $3f
    mov A, !$fe00+X                                                  ; $2942 : $f5, $00, $fe

br_00_2945:
    clrc                                                  ; $2945 : $60
    clrv                                                  ; $2946 : $e0
    inc X                                                  ; $2947 : $3d
    notc                                                  ; $2948 : $ed
    and $fb, #$f5                                                  ; $2949 : $38, $f5, $fb
    bbc $f8.7, br_00_28dc                                                  ; $294c : $f3, $f8, $8d

    set1 $f5.0                                                  ; $294f : $02, $f5
    mov Y, #$fd                                                  ; $2951 : $8d, $fd
    clrc                                                  ; $2953 : $60
    clrv                                                  ; $2954 : $e0
    inc X                                                  ; $2955 : $3d
    notc                                                  ; $2956 : $ed
    and $fb, #$f5                                                  ; $2957 : $38, $f5, $fb
    bbc $f8.7, br_00_28e7                                                  ; $295a : $f3, $f8, $8a

    set1 $f5.0                                                  ; $295d : $02, $f5
    eor1 c, $00fd.3                                                  ; $295f : $8a, $fd, $60
    clrv                                                  ; $2962 : $e0
    inc X                                                  ; $2963 : $3d
    notc                                                  ; $2964 : $ed
    and $fb, #$f5                                                  ; $2965 : $38, $f5, $fb
    bbc $f8.7, br_00_28f2                                                  ; $2968 : $f3, $f8, $87

    set1 $f5.0                                                  ; $296b : $02, $f5
    adc A, [$fd+X]                                                  ; $296d : $87, $fd
    clrc                                                  ; $296f : $60
    clrv                                                  ; $2970 : $e0
    inc X                                                  ; $2971 : $3d
    notc                                                  ; $2972 : $ed
    setp                                                  ; $2973 : $40
    mov A, !$f3fb+X                                                  ; $2974 : $f5, $fb, $f3
    mov X, $83                                                  ; $2977 : $f8, $83
    set1 $f5.0                                                  ; $2979 : $02, $f5
    bbs $fd.4, $60                                                  ; $297b : $83, $fd, $60

    clrv                                                  ; $297e : $e0
    inc X                                                  ; $297f : $3d
    notc                                                  ; $2980 : $ed
    setp                                                  ; $2981 : $40
    mov A, !$f3fb+X                                                  ; $2982 : $f5, $fb, $f3
    mov X, $83                                                  ; $2985 : $f8, $83
    set1 $f5.0                                                  ; $2987 : $02, $f5
    bbs $fd.4, br_00_298e                                                  ; $2989 : $83, $fd, $02

br_00_298c:
    clrv                                                  ; $298c : $e0
    and (X), (Y)                                                  ; $298d : $39

br_00_298e:
    notc                                                  ; $298e : $ed
    bmi br_00_298c                                                  ; $298f : $30, $fb

    mov A, !$f8f3+X                                                  ; $2991 : $f5, $f3, $f8
    sbc A, $02                                                  ; $2994 : $a4, $02
    mov A, !$fda4+X                                                  ; $2996 : $f5, $a4, $fd
    set1 $e0.0                                                  ; $2999 : $02, $e0
    and $78, #$ed                                                  ; $299b : $38, $ed, $78
    mov Y, $f5+X                                                  ; $299e : $fb, $f5
    bbc $f8.7, -$80                                                  ; $29a0 : $f3, $f8, $80

    set1 $f5.0                                                  ; $29a3 : $02, $f5
    setc                                                  ; $29a5 : $80
    mov Y, A                                                  ; $29a6 : $fd
    set1 $e0.0                                                  ; $29a7 : $02, $e0
    cmp X, $ed                                                  ; $29a9 : $3e, $ed
    bvc -$05                                                  ; $29ab : $50, $fb

    mov A, !$f8f3+X                                                  ; $29ad : $f5, $f3, $f8
    dec !$f502                                                  ; $29b0 : $8c, $02, $f5
    dec !$04fd                                                  ; $29b3 : $8c, $fd, $04
    clrv                                                  ; $29b6 : $e0
    tcall 0                                                  ; $29b7 : $01
    notc                                                  ; $29b8 : $ed
    reti                                                  ; $29b9 : $7f


    mov Y, $f5+X                                                  ; $29ba : $fb, $f5
    bbs $00.7, br_00_29c1                                                  ; $29bc : $e3, $00, $02

    set1 $f3.0                                                  ; $29bf : $02, $f3

br_00_29c1:
    mov X, $96                                                  ; $29c1 : $f8, $96
    dbnz Y, $04                                                  ; $29c3 : $fe, $04

    clrv                                                  ; $29c5 : $e0
    or A, [$ed]+Y                                                  ; $29c6 : $17, $ed
    and $f5, #$fb                                                  ; $29c8 : $38, $fb, $f5
    bbs $00.7, br_00_29d0                                                  ; $29cb : $e3, $00, $02

    set1 $f3.0                                                  ; $29ce : $02, $f3

br_00_29d0:
    mov X, $8c                                                  ; $29d0 : $f8, $8c
    dbnz Y, $60                                                  ; $29d2 : $fe, $60

    mov A, !$ed0c                                                  ; $29d4 : $e5, $0c, $ed
    or $f5, #$fb                                                  ; $29d7 : $18, $fb, $f5
    mov X, $ab                                                  ; $29da : $f8, $ab
    or A, (X)                                                  ; $29dc : $06
    mov A, !$0ce5+X                                                  ; $29dd : $f5, $e5, $0c
    notc                                                  ; $29e0 : $ed
    or $fd, #$00                                                  ; $29e1 : $18, $00, $fd
    bbs $e0.0, br_00_29ee                                                  ; $29e4 : $03, $e0, $07

    mov A, !$eefb+X                                                  ; $29e7 : $f5, $fb, $ee
    stop                                                  ; $29ea : $ff
    tcall 7                                                  ; $29eb : $71
    mov X, $9d                                                  ; $29ec : $f8, $9d

br_00_29ee:
    set1 $f9.0                                                  ; $29ee : $02, $f9
    nop                                                  ; $29f0 : $00
    bbs $f8.0, -$64                                                  ; $29f1 : $03, $f8, $9c

    set1 $f9.0                                                  ; $29f4 : $02, $f9
    nop                                                  ; $29f6 : $00
    dbnz Y, br_00_2a01                                                  ; $29f7 : $fe, $08

    clrv                                                  ; $29f9 : $e0
    tcall 3                                                  ; $29fa : $31
    notc                                                  ; $29fb : $ed
    reti                                                  ; $29fc : $7f


    mov Y, $f5+X                                                  ; $29fd : $fb, $f5
    mov X, $9d                                                  ; $29ff : $f8, $9d

br_00_2a01:
    set1 $f9.0                                                  ; $2a01 : $02, $f9
    nop                                                  ; $2a03 : $00
    or A, #$00                                                  ; $2a04 : $08, $00
    or A, #$f8                                                  ; $2a06 : $08, $f8
    mov X, SP                                                  ; $2a08 : $9d
    set1 $f9.0                                                  ; $2a09 : $02, $f9
    nop                                                  ; $2a0b : $00
    or A, $f8                                                  ; $2a0c : $04, $f8
    adc $f9, #$02                                                  ; $2a0e : $98, $02, $f9
    nop                                                  ; $2a11 : $00
    dbnz Y, br_00_2a1e                                                  ; $2a12 : $fe, $0a

    mov A, !$07e0+X                                                  ; $2a14 : $f5, $e0, $07
    bbc $ed.7, br_00_2a62                                                  ; $2a17 : $f3, $ed, $48

    mov Y, $f8+X                                                  ; $2a1a : $fb, $f8
    bcs $04                                                  ; $2a1c : $b0, $04

br_00_2a1e:
    mov X, $00+Y                                                  ; $2a1e : $f9, $00
    or1 c, $08ed.2                                                  ; $2a20 : $0a, $ed, $48
    mov X, $b0                                                  ; $2a23 : $f8, $b0
    or A, $f9                                                  ; $2a25 : $04, $f9
    nop                                                  ; $2a27 : $00
    or1 c, $08ed.2                                                  ; $2a28 : $0a, $ed, $48
    mov X, $b0                                                  ; $2a2b : $f8, $b0
    cbne $f9, br_00_2a30                                                  ; $2a2d : $2e, $f9, $00

br_00_2a30:
    dbnz Y, $02                                                  ; $2a30 : $fe, $02

    clrv                                                  ; $2a32 : $e0
    and A, [$f3]+Y                                                  ; $2a33 : $37, $f3
    mov A, !$ffee+X                                                  ; $2a35 : $f5, $ee, $ff
    clr1 $fb.3                                                  ; $2a38 : $72, $fb
    mov X, $9b                                                  ; $2a3a : $f8, $9b
    set1 $f9.0                                                  ; $2a3c : $02, $f9
    nop                                                  ; $2a3e : $00
    or A, $f8                                                  ; $2a3f : $04, $f8
    ei                                                  ; $2a41 : $a0
    stop                                                  ; $2a42 : $ff
    set1 $e0.0                                                  ; $2a43 : $02, $e0
    and A, [$f3]+Y                                                  ; $2a45 : $37, $f3
    mov A, !$ffee+X                                                  ; $2a47 : $f5, $ee, $ff

br_00_2a4a:
    clr1 $fb.3                                                  ; $2a4a : $72, $fb
    mov X, $9c                                                  ; $2a4c : $f8, $9c
    set1 $f9.0                                                  ; $2a4e : $02, $f9
    nop                                                  ; $2a50 : $00
    or A, $f8                                                  ; $2a51 : $04, $f8
    tcall 10                                                  ; $2a53 : $a1
    stop                                                  ; $2a54 : $ff
    set1 $e0.0                                                  ; $2a55 : $02, $e0
    and A, [$f3]+Y                                                  ; $2a57 : $37, $f3
    mov A, !$ffee+X                                                  ; $2a59 : $f5, $ee, $ff
    clr1 $fb.3                                                  ; $2a5c : $72, $fb
    mov X, $9d                                                  ; $2a5e : $f8, $9d
    set1 $f9.0                                                  ; $2a60 : $02, $f9

br_00_2a62:
    nop                                                  ; $2a62 : $00
    or A, $f8                                                  ; $2a63 : $04, $f8
    set1 $ff.5                                                  ; $2a65 : $a2, $ff
    set1 $e0.0                                                  ; $2a67 : $02, $e0
    and A, [$f3]+Y                                                  ; $2a69 : $37, $f3
    mov A, !$ffee+X                                                  ; $2a6b : $f5, $ee, $ff
    clr1 $fb.3                                                  ; $2a6e : $72, $fb
    mov X, $9e                                                  ; $2a70 : $f8, $9e
    set1 $f9.0                                                  ; $2a72 : $02, $f9
    nop                                                  ; $2a74 : $00
    or A, $f8                                                  ; $2a75 : $04, $f8
    bbs $ff.5, br_00_2a7f                                                  ; $2a77 : $a3, $ff, $05

    clrv                                                  ; $2a7a : $e0
    tcall 3                                                  ; $2a7b : $31
    notc                                                  ; $2a7c : $ed
    eor A, #$fb                                                  ; $2a7d : $48, $fb

br_00_2a7f:
    mov A, !$9ef8+X                                                  ; $2a7f : $f5, $f8, $9e
    or A, $f9                                                  ; $2a82 : $04, $f9
    nop                                                  ; $2a84 : $00
    bbs $f5.0, -$08                                                  ; $2a85 : $03, $f5, $f8

    xcn A                                                  ; $2a88 : $9f
    or A, $f9                                                  ; $2a89 : $04, $f9
    nop                                                  ; $2a8b : $00
    set1 $f5.0                                                  ; $2a8c : $02, $f5
    mov X, $a0                                                  ; $2a8e : $f8, $a0
    bbs $f9.0, br_00_2a93                                                  ; $2a90 : $03, $f9, $00

br_00_2a93:
    set1 $f5.0                                                  ; $2a93 : $02, $f5
    mov X, $a0                                                  ; $2a95 : $f8, $a0
    set1 $f9.0                                                  ; $2a97 : $02, $f9
    nop                                                  ; $2a99 : $00
    stop                                                  ; $2a9a : $ff
    or A, $e0                                                  ; $2a9b : $04, $e0
    cmp X, $ed                                                  ; $2a9d : $3e, $ed
    clrp                                                  ; $2a9f : $20
    mov A, !$f3fb+X                                                  ; $2aa0 : $f5, $fb, $f3
    mov X, $84                                                  ; $2aa3 : $f8, $84
    or A, [$f2+X]                                                  ; $2aa5 : $07, $f2
    tcall 0                                                  ; $2aa7 : $01
    nop                                                  ; $2aa8 : $00
    bbs $84.0, br_00_2a30                                                  ; $2aa9 : $03, $84, $84

    set1 $f5.0                                                  ; $2aac : $02, $f5
    bbc $86.7, br_00_2ab8                                                  ; $2aae : $f3, $86, $07

    clr1 $01.7                                                  ; $2ab1 : $f2, $01
    nop                                                  ; $2ab3 : $00
    bbs $86.0, -$7a                                                  ; $2ab4 : $03, $86, $86

    tcall 0                                                  ; $2ab7 : $01

br_00_2ab8:
    mov A, !$88f3+X                                                  ; $2ab8 : $f5, $f3, $88
    or A, [$f2+X]                                                  ; $2abb : $07, $f2
    tcall 0                                                  ; $2abd : $01
    nop                                                  ; $2abe : $00
    bbs $88.0, br_00_2a4a                                                  ; $2abf : $03, $88, $88

    stop                                                  ; $2ac2 : $ff
    bmi $30                                                  ; $2ac3 : $30, $30

    bmi $30                                                  ; $2ac5 : $30, $30

    bmi $30                                                  ; $2ac7 : $30, $30

    bmi $30                                                  ; $2ac9 : $30, $30

    bmi $30                                                  ; $2acb : $30, $30

    bmi $30                                                  ; $2acd : $30, $30

    bmi $30                                                  ; $2acf : $30, $30

    bmi $30                                                  ; $2ad1 : $30, $30

    bmi $30                                                  ; $2ad3 : $30, $30

    bmi $30                                                  ; $2ad5 : $30, $30

    bmi $30                                                  ; $2ad7 : $30, $30

    bmi $30                                                  ; $2ad9 : $30, $30

    bmi $30                                                  ; $2adb : $30, $30

    bmi $30                                                  ; $2add : $30, $30

    bmi $30                                                  ; $2adf : $30, $30

    bmi $30                                                  ; $2ae1 : $30, $30

    bmi $30                                                  ; $2ae3 : $30, $30

    bmi $30                                                  ; $2ae5 : $30, $30

    bmi $30                                                  ; $2ae7 : $30, $30

    bmi $30                                                  ; $2ae9 : $30, $30

    bmi $30                                                  ; $2aeb : $30, $30

    bmi $30                                                  ; $2aed : $30, $30

    bmi $30                                                  ; $2aef : $30, $30

    bmi $30                                                  ; $2af1 : $30, $30
