.include "include/rominfo.s"
.include "include/constants.s"
.include "include/macros.s"

.include "code/wram.s"

.org $400

Begin:
; Set direct page to 0, and init stack
    clrp                                                                      ; $0400 : $20
    mov X, #<wStackTop                                                        ; $0401 : $cd, $cf
    mov SP, X                                                                 ; $0403 : $bd

; Clear ram $00-$df
    mov A, #$00                                                  ; $0404 : $e8, $00
    mov X, A                                                  ; $0406 : $5d
-   mov (X)+, A                                                  ; $0407 : $af
    cmp X, #$e0                                                  ; $0408 : $c8, $e0
    bne -                                                  ; $040a : $d0, $fb

; Clear ram $250-$27f
    mov X, #$00                                                  ; $040c : $cd, $00
-   inc X                                                  ; $040e : $3d
    mov !$0250-1+X, A                                                  ; $040f : $d5, $4f, $02
    cmp X, #$30                                                  ; $0412 : $c8, $30
    bne -                                                  ; $0414 : $d0, $f8

; Clear ram $390-$3ff
    mov X, #$00                                                  ; $0416 : $cd, $00
-   inc X                                                  ; $0418 : $3d
    mov !w390-1+X, A                                                  ; $0419 : $d5, $8f, $03
    cmp X, #$70                                                  ; $041c : $c8, $70
    bne -                                                  ; $041e : $d0, $f8

; Clear ram $120-$1bf
    mov X, #$00                                                  ; $0420 : $cd, $00
-   inc X                                                  ; $0422 : $3d
    mov !wSndEffectBCopyOfTrack0Ptr-1+X, A                                                  ; $0423 : $d5, $1f, $01
    cmp X, #$a0                                                  ; $0426 : $c8, $a0
    bne -                                                  ; $0428 : $d0, $f8

; Clear all echo buffer (its end is $feff)
    mov X, #$00                                                               ; $042a : $cd, $00
    mov wPtrToEchoBuffer, #<wEchoBuffer                                       ; $042c : $8f, $00, $d0
    mov wPtrToEchoBuffer+1, #>wEchoBuffer                                     ; $042f : $8f, $ef, $d1

    @nextEchoBufferByte:
        mov [wPtrToEchoBuffer+X], A                                           ; $0432 : $c7, $d0
        inc wPtrToEchoBuffer                                                  ; $0434 : $ab, $d0
        bne @nextEchoBufferByte                                               ; $0436 : $d0, $fa

        inc wPtrToEchoBuffer+1                                                ; $0438 : $ab, $d1
        cmp wPtrToEchoBuffer+1, #$ff                                          ; $043a : $78, $ff, $d1
        bne @nextEchoBufferByte                                               ; $043d : $d0, $f3

; Set a $800 echo buffer block, but disable echo
    inc A                                                                     ; $043f : $bc
    call !SetEchoDelayAndBufferStart                                          ; $0440 : $3f, $5d, $0a
    set1 wDSPflags.FLGB_ECHO_DISABLE                                          ; $0443 : $a2, $48

; Clear main volume, and set sample src directory
    mov A, #$00                                                               ; $0445 : $e8, $00
    mov Y, #MVOL_L                                                            ; $0447 : $8d, $0c
    call !SetDspAddrDataToYA                                                  ; $0449 : $3f, $1d, $06
    mov Y, #MVOL_R                                                            ; $044c : $8d, $1c
    call !SetDspAddrDataToYA                                                  ; $044e : $3f, $1d, $06

    mov A, #>SampleSrcDir                                                     ; $0451 : $e8, $4b
    mov Y, #DIR                                                               ; $0453 : $8d, $5d
    call !SetDspAddrDataToYA                                                  ; $0455 : $3f, $1d, $06

;
    mov A, #$f0                                                  ; $0458 : $e8, $f0
    mov !CTRL_REG, A                                                  ; $045a : $c5, $f1, $00
    mov A, #$10                                                  ; $045d : $e8, $10
    mov !TIMER_0, A                                                  ; $045f : $c5, $fa, $00
    mov wTempoVal+1, A                                                  ; $0462 : $c4, $53
    mov A, #_CTRL_TIMER_0                                                  ; $0464 : $e8, $01
    mov !CTRL_REG, A                                                  ; $0466 : $c5, $f1, $00
    mov A, #$02                                                  ; $0469 : $e8, $02
    call !SetEchoDelayAndBufferStart                                                  ; $046b : $3f, $5d, $0a
    mov wEchoFeedback, #$5a                                                  ; $046e : $8f, $5a, $4e
    mov A, #$02                                                  ; $0471 : $e8, $02
    call !SetEchoFilterCoef                                                  ; $0473 : $3f, $46, $0a
    clr1 wDSPflags.FLGB_ECHO_DISABLE                                                  ; $0476 : $b2, $48
    mov A, #$28                                                  ; $0478 : $e8, $28
    mov $d9, A                                                  ; $047a : $c4, $d9
    mov $da, A                                                  ; $047c : $c4, $da
    mov A, #$00                                                  ; $047e : $e8, $00
    mov $d8, A                                                  ; $0480 : $c4, $d8

@mainLoop:
    mov Y, #$0a                                                  ; $0482 : $8d, $0a

    @loop_0484:
        cmp Y, #$05                                                  ; $0484 : $ad, $05
        beq @br_048f                                                  ; $0486 : $f0, $07

        bcs @br_0492                                                  ; $0488 : $b0, $08

        cmp $4c, wEchoDelay                                                  ; $048a : $69, $4d, $4c
        bne @cont_04a0                                                  ; $048d : $d0, $11

    @br_048f:
        bbs $4c.7, @cont_04a0                                                  ; $048f : $e3, $4c, $0e

    @br_0492:
        mov A, !$0df4+Y                                                  ; $0492 : $f6, $f4, $0d
        mov !DSP_REG_ADDR, A                                                  ; $0495 : $c5, $f2, $00
        mov A, !$0dfe+Y                                                  ; $0498 : $f6, $fe, $0d
        mov X, A                                                  ; $049b : $5d
        mov A, (X)                                                  ; $049c : $e6
        mov !DSP_REG_DATA, A                                                  ; $049d : $c5, $f3, $00

    @cont_04a0:
        dbnz Y, @loop_0484                                                  ; $04a0 : $fe, $e2

    mov w45, Y                                                  ; $04a2 : $cb, $45
    mov w46, Y                                                  ; $04a4 : $cb, $46
    mov A, $18                                                  ; $04a6 : $e4, $18
    eor A, $19                                                  ; $04a8 : $44, $19
    lsr A                                                  ; $04aa : $5c
    lsr A                                                  ; $04ab : $5c
    notc                                                  ; $04ac : $ed
    ror $18                                                  ; $04ad : $6b, $18
    ror $19                                                  ; $04af : $6b, $19

; push num frames passed?
-   mov Y, !COUNTER_0                                                  ; $04b1 : $ec, $fd, $00
    beq -                                                  ; $04b4 : $f0, $fb

    push Y                                                  ; $04b6 : $6d

;
    mov A, #$2c                                                  ; $04b7 : $e8, $2c
    mul YA                                                  ; $04b9 : $cf
    clrc                                                  ; $04ba : $60
    adc A, $43                                                  ; $04bb : $84, $43
    mov $43, A                                                  ; $04bd : $c4, $43
    bcc @cont_04e6                                                  ; $04bf : $90, $25

; Process curr sound effect attrs, then exchange to acknowledge to SNES that
; we're done with it, and to get a new attr
    call !ProcessSndEffectAttrs                                               ; $04c1 : $3f, $f0, $0e

    mov X, #$03                                                               ; $04c4 : $cd, $03
    call !ExchgPortXDataWithSnes                                              ; $04c6 : $3f, $18, $05
    mov wPortDataToWrite+X,A                                                  ; $04c9 : $d4, $04

; Repeat above, but for sound effect A
    call !ProcessSndEffectAdecrescendo@start                                  ; $04cb : $3f, $83, $0f

    mov X, #$01                                                               ; $04ce : $cd, $01
    call !ExchgPortXDataWithSnes                                              ; $04d0 : $3f, $18, $05
    mov wPortDataToWrite+X,A                                                  ; $04d3 : $d4, $04

; Repeat above, but for sound effect B
    call !ProcessSndEffectBsustain@start                                      ; $04d5 : $3f, $da, $11

    mov X, #$02                                                               ; $04d8 : $cd, $02
    call !ExchgPortXDataWithSnes                                              ; $04da : $3f, $18, $05
    mov wPortDataToWrite+X,A                                                  ; $04dd : $d4, $04

; inc 4c until its wEchoDelay
    cmp $4c, wEchoDelay                                                  ; $04df : $69, $4d, $4c
    beq @cont_04e6                                                  ; $04e2 : $f0, $02

    inc $4c                                                  ; $04e4 : $ab, $4c

@cont_04e6:
; do tempo * num frames passed?
    mov A, wTempoVal+1                                                  ; $04e6 : $e4, $53
    pop Y                                                  ; $04e8 : $ee
    mul YA                                                  ; $04e9 : $cf
    clrc                                                  ; $04ea : $60
    adc A, $51                                                  ; $04eb : $84, $51
    mov $51, A                                                  ; $04ed : $c4, $51
    bcc @afterMusic                                                  ; $04ef : $90, $0c

; Process curr music, and exchange with SNES for new music
    call !ProcessMusicScore                                                   ; $04f1 : $3f, $cb, $06

    mov X, #$00                                                               ; $04f4 : $cd, $00
    call !ExchgPortXDataWithSnes                                              ; $04f6 : $3f, $18, $05
    mov wPortDataToWrite+X,A                                                  ; $04f9 : $d4, $04
    bra @mainLoop                                                             ; $04fb : $2f, $85

@afterMusic:
    mov A, wCurrMusic                                                  ; $04fd : $e4, $db
    cmp A, #$80                                                  ; $04ff : $68, $80
    beq @toMainLoop                                                  ; $0501 : $f0, $12

; X is a word idx pointing to track 0
; wCurrTrackIdxBitfield shifts left each track to let us know when all 8 done
    mov X, #$00                                                  ; $0503 : $cd, $00
    mov wCurrTrackIdxBitfield, #$01                                                  ; $0505 : $8f, $01, $47

    @nextTrack:
        mov A, wCurrPhraseTracksAddrs+1+X                                                  ; $0508 : $f4, $31
        beq +                                                  ; $050a : $f0, $03
        call !tickTrackUpdate@func_0d1d                                                  ; $050c : $3f, $1d, $0d
    +   inc X                                                  ; $050f : $3d
        inc X                                                  ; $0510 : $3d
        asl wCurrTrackIdxBitfield                                                  ; $0511 : $0b, $47
        bne @nextTrack                                                  ; $0513 : $d0, $f3

@toMainLoop:
    jmp !@mainLoop                                                  ; $0515 : $5f, $82, $04


; X - chosen port
; Returns port 0 data in A
ExchgPortXDataWithSnes:
    mov A, wPortDataToWrite+X                                                 ; $0518 : $f4, $04
    mov !PORT_0+X, A                                                          ; $051a : $d5, $f4, $00

; Wait until port 0 data stabilizes
-   mov A, !PORT_0+X                                                          ; $051d : $f5, $f4, $00
    cmp A, !PORT_0+X                                                          ; $0520 : $75, $f4, $00
    bne -                                                                     ; $0523 : $d0, $f8

    mov wReadPortData+X,A                                                     ; $0525 : $d4, $00

Stub_0527:
    ret                                                                       ; $0527 : $6f


; A - the VCMD byte
HandleVCMDBetween80hAndDFh:
; If percussion note...
    cmp Y, #$ca                                                               ; $0528 : $ad, $ca
    bcc +                                                                     ; $052a : $90, $05

; Set its instrument, and note to $a4
    call !VCMDE0h_SetInstrumentA                                              ; $052c : $3f, $26, $08
    mov Y, #$a4                                                               ; $052f : $8d, $a4

; If $c8 (TIE) or $c9 (REST), return
+   cmp Y, #$c8                                                               ; $0531 : $ad, $c8
    bcs Stub_0527                                                             ; $0533 : $b0, $f2

; Don't do note manips and setting of regs, if sound effects are using the track
    mov A, wBitfieldOfSndEffectsTracksUsed                                    ; $0535 : $e4, $1a
    and A, wCurrTrackIdxBitfield                                              ; $0537 : $24, $47
    bne Stub_0527                                                             ; $0539 : $d0, $ec

; Y = a note value ($80-$c7). -$80 and add on transposes, and fine tuning
    mov A, Y                                                                  ; $053b : $dd
    and A, #$7f                                                               ; $053c : $28, $7f
    clrc                                                                      ; $053e : $60
    adc A, wGlobalTranspose                                                   ; $053f : $84, $50
    clrc                                                                      ; $0541 : $60
    adc A, !wTrackTranspose+X                                                 ; $0542 : $95, $f0, $02
    mov !wTrackNoteAfterTransposeTuning+1+X, A                                ; $0545 : $d5, $61, $03
    mov A, !wTrackTuning+X                                                    ; $0548 : $f5, $81, $03
    mov !wTrackNoteAfterTransposeTuning+X, A                                  ; $054b : $d5, $60, $03

;
    mov A, !wTrackVibratoFadeLen+X                                                  ; $054e : $f5, $b1, $02
    lsr A                                                  ; $0551 : $5c
    mov A, #$00                                                  ; $0552 : $e8, $00
    ror A                                                  ; $0554 : $7c
    mov !w2a0+X, A                                                  ; $0555 : $d5, $a0, $02
    mov A, #$00                                                  ; $0558 : $e8, $00
    mov $b0+X,A                                                  ; $055a : $d4, $b0
    mov !$0100+X, A                                                  ; $055c : $d5, $00, $01
    mov !w2d0+X, A                                                  ; $055f : $d5, $d0, $02
    mov wc0+X,A                                                  ; $0562 : $d4, $c0
    or $5e, wCurrTrackIdxBitfield                                                  ; $0564 : $09, $47, $5e
    or w45, wCurrTrackIdxBitfield                                                  ; $0567 : $09, $47, $45
    mov A, !wTrackPitchEnvelopeLen+X                                                  ; $056a : $f5, $80, $02
    mov wPitchSlideLength+X,A                                                  ; $056d : $d4, $a0
    beq @cont_058f                                                  ; $056f : $f0, $1e

    mov A, !wTrackPitchEnvelopeDelay+X                                                  ; $0571 : $f5, $81, $02
    mov wPitchSlideDelay+X,A                                                  ; $0574 : $d4, $a1

;
    mov A, !wTrackPitchEnvelopeIsTo+X                                                  ; $0576 : $f5, $90, $02
    bne @cont_0585                                                  ; $0579 : $d0, $0a

; pitch env is 'from'
    mov A, !wTrackNoteAfterTransposeTuning+1+X                                                  ; $057b : $f5, $61, $03
    setc                                                  ; $057e : $80
    sbc A, !wTrackPitchEnvelopeKey+X                                                  ; $057f : $b5, $91, $02
    mov !wTrackNoteAfterTransposeTuning+1+X, A                                                  ; $0582 : $d5, $61, $03

@cont_0585:
    mov A, !wTrackPitchEnvelopeKey+X                                                  ; $0585 : $f5, $91, $02
    clrc                                                  ; $0588 : $60
    adc A, !wTrackNoteAfterTransposeTuning+1+X                                                  ; $0589 : $95, $61, $03
    call !Call_00_0ac6                                                  ; $058c : $3f, $c6, $0a

@cont_058f:
    call !SetZpNoteAfterTransposeTuning                                                  ; $058f : $3f, $de, $0a

@func_0592:
; If high byte of note is >= $34, add note-$34 to transpose tuning
    mov Y, #$00                                                  ; $0592 : $8d, $00
    mov A, wZpNoteAfterTransposeTuning+1                                                  ; $0594 : $e4, $11
    setc                                                  ; $0596 : $80
    sbc A, #$34                                                  ; $0597 : $a8, $34
    bcs @addYAtoNote                                                  ; $0599 : $b0, $09

; If high byte is $13 <= x < $34, don't add
    mov A, wZpNoteAfterTransposeTuning+1                                                  ; $059b : $e4, $11
    setc                                                  ; $059d : $80
    sbc A, #$13                                                  ; $059e : $a8, $13
    bcs @playNote                                                  ; $05a0 : $b0, $06

;)
    dec Y                                                  ; $05a2 : $dc
    asl A                                                  ; $05a3 : $1c

@addYAtoNote:
    addw YA, wZpNoteAfterTransposeTuning                                      ; $05a4 : $7a, $10
    movw wZpNoteAfterTransposeTuning, YA                                      ; $05a6 : $da, $10

; wZpNoteAfterTransposeTuning - note to play in high byte
@playNote:
; Note is in the high byte, /24 (1 word table entry per note)
; X = div (octave), Y = mod (note within octave)
    push X                                                                    ; $05a8 : $4d
    mov A, wZpNoteAfterTransposeTuning+1                                      ; $05a9 : $e4, $11
    asl A                                                                     ; $05ab : $1c
    mov Y, #$00                                                               ; $05ac : $8d, $00
    mov X, #$18                                                               ; $05ae : $cd, $18
    div YA, X                                                                 ; $05b0 : $9e
    mov X, A                                                                  ; $05b1 : $5d

; Save current note in ram
    mov A, !Octave0NotePitches+1+Y                                            ; $05b2 : $f6, $0a, $0e
    mov wNoteFrom+1, A                                                        ; $05b5 : $c4, $15
    mov A, !Octave0NotePitches+Y                                              ; $05b7 : $f6, $09, $0e
    mov wNoteFrom, A                                                          ; $05ba : $c4, $14

; YA = next note
    mov A, !Octave0NotePitches+3+Y                                            ; $05bc : $f6, $0c, $0e
    push A                                                                    ; $05bf : $2d
    mov A, !Octave0NotePitches+2+Y                                            ; $05c0 : $f6, $0b, $0e
    pop Y                                                                     ; $05c3 : $ee

; Get distance from curr note to ext
    subw YA, wNoteFrom                                                  ; $05c4 : $9a, $14

;
    mov Y, wZpNoteAfterTransposeTuning                                                 ; $05c6 : $eb, $10
    mul YA                                                  ; $05c8 : $cf
    mov A, Y                                                  ; $05c9 : $dd
    mov Y, #$00                                                  ; $05ca : $8d, $00
    addw YA, wNoteFrom                                                  ; $05cc : $7a, $14
    mov wNoteFrom+1, Y                                                  ; $05ce : $cb, $15
    asl A                                                  ; $05d0 : $1c
    rol wNoteFrom+1                                                  ; $05d1 : $2b, $15
    mov wNoteFrom, A                                                  ; $05d3 : $c4, $14
    bra @startOctaveAdjusts                                                  ; $05d5 : $2f, $04

@nextOctave:
    lsr wNoteFrom+1                                                  ; $05d7 : $4b, $15
    ror A                                                  ; $05d9 : $7c
    inc X                                                  ; $05da : $3d

@startOctaveAdjusts:
    cmp X, #$06                                                  ; $05db : $c8, $06
    bne @nextOctave                                                  ; $05dd : $d0, $f8

    mov wNoteFrom, A                                                  ; $05df : $c4, $14

; Multiply 2 words (wPitchBaseMultiplier * wNoteFrom)
; Start with <mult * >wNoteFrom
    pop X                                                                     ; $05e1 : $ce
    mov A, !wPitchBaseMultiplier+X                                            ; $05e2 : $f5, $20, $02
    mov Y, wNoteFrom+1                                                        ; $05e5 : $eb, $15
    mul YA                                                                    ; $05e7 : $cf
    movw wCalcedShadowPitch, YA                                               ; $05e8 : $da, $16

; Push <mult * <wNoteFrom
    mov A, !wPitchBaseMultiplier+X                                            ; $05ea : $f5, $20, $02
    mov Y, wNoteFrom                                                          ; $05ed : $eb, $14
    mul YA                                                                    ; $05ef : $cf
    push Y                                                                    ; $05f0 : $6d

; Add on >mult * <wNoteFrom
    mov A, !wPitchBaseMultiplier+1+X                                          ; $05f1 : $f5, $21, $02
    mov Y, wNoteFrom                                                          ; $05f4 : $eb, $14
    mul YA                                                                    ; $05f6 : $cf
    addw YA, wCalcedShadowPitch                                               ; $05f7 : $7a, $16
    movw wCalcedShadowPitch, YA                                               ; $05f9 : $da, $16

; Y = >mult * >wNoteFrom
    mov A, !wPitchBaseMultiplier+1+X                                          ; $05fb : $f5, $21, $02
    mov Y, wNoteFrom+1                                                        ; $05fe : $eb, $15
    mul YA                                                                    ; $0600 : $cf
    mov Y, A                                                                  ; $0601 : $fd

; A = <mult * <wNoteFrom, add onto total calced pitch
    pop A                                                                     ; $0602 : $ae
    addw YA, wCalcedShadowPitch                                               ; $0603 : $7a, $16
    movw wCalcedShadowPitch, YA                                               ; $0605 : $da, $16

; Y = track's pitch low
    mov A, X                                                                  ; $0607 : $7d
    xcn A                                                                     ; $0608 : $9f
    lsr A                                                                     ; $0609 : $5c
    or A, #PITCH_L                                                            ; $060a : $08, $02
    mov Y, A                                                                  ; $060c : $fd

; Set the DSP pitch low
    mov A, wCalcedShadowPitch                                                 ; $060d : $e4, $16
    call !SetDspAddrDataIfNoSndEffectToYA                                     ; $060f : $3f, $15, $06

; Repeat above with Y = track's pitch high
    inc Y                                                                     ; $0612 : $fc
    mov A, wCalcedShadowPitch+1                                               ; $0613 : $e4, $17

SetDspAddrDataIfNoSndEffectToYA:
; Return if the curr music track is in use by sounds
    push A                                                                    ; $0615 : $2d
    mov A, wCurrTrackIdxBitfield                                              ; $0616 : $e4, $47
    and A, wBitfieldOfSndEffectsTracksUsed                                    ; $0618 : $24, $1a
    pop A                                                                     ; $061a : $ae
    bne +                                                                     ; $061b : $d0, $06

SetDspAddrDataToYA:
    mov !DSP_REG_ADDR, Y                                                      ; $061d : $cc, $f2, $00
    mov !DSP_REG_DATA, A                                                      ; $0620 : $c5, $f3, $00

+   ret                                                                       ; $0623 : $6f


YAequNextPhraseAddr:
; Get low byte of sound score word in A
    mov Y, #$00                                                               ; $0624 : $8d, $00
    mov A, [wSoundScorePtr]+Y                                                 ; $0626 : $f7, $40
    incw wSoundScorePtr                                                       ; $0628 : $3a, $40
    push A                                                                    ; $062a : $2d

; Get high byte of sound score word in Y
    mov A, [wSoundScorePtr]+Y                                                 ; $062b : $f7, $40
    incw wSoundScorePtr                                                       ; $062d : $3a, $40
    mov Y, A                                                                  ; $062f : $fd
    pop A                                                                     ; $0630 : $ae
    ret                                                                       ; $0631 : $6f


HandleCmdFFh_LoadNewData:
    call !MimicIPL                                                  ; $0632 : $3f, $2e, $0e
    mov A, #$80                                                  ; $0635 : $e8, $80
    mov wMusicToPlay, A                                                  ; $0637 : $c4, $08

playMusic80h:
    mov A, #$80                                                  ; $0639 : $e8, $80

; A - music idx
PlayNewMusic:
    mov wCurrMusic, A                                                  ; $063b : $c4, $db
    cmp A, #$80                                                  ; $063d : $68, $80
    beq func_064f                                                  ; $063f : $f0, $0e

; Get pointer to the music's phrases (idx 1 = 1st entry)
    asl A                                                                     ; $0641 : $1c
    mov X, A                                                                  ; $0642 : $5d
    mov A, !SoundScoreArea-1+X                                                ; $0643 : $f5, $ff, $2a
    mov Y, A                                                                  ; $0646 : $fd
    mov A, !SoundScoreArea-2+X                                                ; $0647 : $f5, $fe, $2a
    movw wSoundScorePtr, YA                                                   ; $064a : $da, $40

;
    mov w0c, #$02                                                  ; $064c : $8f, $02, $0c

func_064f:
    mov A, #$00                                                  ; $064f : $e8, $00
    mov wd4, A                                                  ; $0651 : $c4, $d4
    mov wEchoVolL+1, A                                                  ; $0653 : $c4, $61
    mov wEchoVolR+1, A                                                  ; $0655 : $c4, $63
    mov A, wBitfieldOfSndEffectsTracksUsed                                                  ; $0657 : $e4, $1a
    eor A, #$ff                                                  ; $0659 : $48, $ff
    tset1 !w46                                                  ; $065b : $0e, $46, $00
    ret                                                  ; $065e : $6f


resetAllTracks:
; Point to last track (idx 7)
    mov X, #$0e                                                  ; $065f : $cd, $0e
    mov wCurrTrackIdxBitfield, #$80                                                  ; $0661 : $8f, $80, $47

@prevTrack:
    mov A, #$ff                                                  ; $0664 : $e8, $ff
    mov !wTrackVolume+1+X, A                                                  ; $0666 : $d5, $01, $03
    mov A, #$0a                                                  ; $0669 : $e8, $0a
    call !VCMDE1h_SetPanA                                                  ; $066b : $3f, $8d, $08

; A = 0, clear various vars for this track
    mov !wTrackInstrumentIdxes+X, A                                           ; $066e : $d5, $11, $02
    mov !wTrackTuning+X, A                                                    ; $0671 : $d5, $81, $03
    mov !wTrackTranspose+X, A                                                 ; $0674 : $d5, $f0, $02
    mov !wTrackPitchEnvelopeLen+X, A                                          ; $0677 : $d5, $80, $02
    mov wTrackCurrVibratoVal+X,A                                              ; $067a : $d4, $b1
    mov wTrackTremoloDepth+X,A                                                ; $067c : $d4, $c1

; Process previous track
    dec X                                                                     ; $067e : $1d
    dec X                                                                     ; $067f : $1d
    lsr wCurrTrackIdxBitfield                                                 ; $0680 : $4b, $47
    bne @prevTrack                                                            ; $0682 : $d0, $e0

    mov wMasterVolLength, A                                                  ; $0684 : $c4, $5a
    mov wEchoVolFadeLen, A                                                  ; $0686 : $c4, $68
    mov wTempoLength, A                                                  ; $0688 : $c4, $54
    mov wGlobalTranspose, A                                                  ; $068a : $c4, $50
    mov w42, A                                                  ; $068c : $c4, $42
    mov wPercussionPatchBase, A                                                  ; $068e : $c4, $5f
    mov wMasterVolume+1, #$c0                                                  ; $0690 : $8f, $c0, $59
    mov wTempoVal+1, #$20                                                  ; $0693 : $8f, $20, $53

Stub_0696:
    ret                                                                       ; $0696 : $6f


JmpPlayNewMusic:
    jmp !PlayNewMusic                                                         ; $0697 : $5f, $3b, $06


    jmp !func_064f                                                  ; $069a : $5f, $4f, $06


JmpHandleCmdFFh_LoadNewData:
    jmp !HandleCmdFFh_LoadNewData                                             ; $069d : $5f, $32, $06


jmpResetAllTracks:
    jmp !resetAllTracks                                                  ; $06a0 : $5f, $5f, $06


jmpPlayMusic80h:
    jmp !playMusic80h                                                  ; $06a3 : $5f, $39, $06


HandleCmdFEh_StopAndJmpIPL:
; Stop all tracks, and clear all echo regs
    mov A, #$ff                                                               ; $06a6 : $e8, $ff
    mov Y, #KOF                                                               ; $06a8 : $8d, $5c
    call !SetDspAddrDataToYA                                                  ; $06aa : $3f, $1d, $06

    mov A, #$00                                                               ; $06ad : $e8, $00
    mov Y, #EVOL_L                                                            ; $06af : $8d, $2c
    call !SetDspAddrDataToYA                                                  ; $06b1 : $3f, $1d, $06

    mov A, #$00                                                               ; $06b4 : $e8, $00
    mov Y, #EVOL_R                                                            ; $06b6 : $8d, $3c
    call !SetDspAddrDataToYA                                                  ; $06b8 : $3f, $1d, $06

    mov A, #$00                                                               ; $06bb : $e8, $00
    mov Y, #EON                                                               ; $06bd : $8d, $4d
    call !SetDspAddrDataToYA                                                  ; $06bf : $3f, $1d, $06

; Set direct page back to 0, re-enable the IPL and jump to it
    clrp                                                                      ; $06c2 : $20
    mov A, #_CTRL_IPLEN                                                       ; $06c3 : $e8, $80
    mov !CTRL_REG, A                                                          ; $06c5 : $c5, $f1, $00
    jmp !IPL_START                                                            ; $06c8 : $5f, $c0, $ff


ProcessMusicScore:
; If special music ID $fe or $ff, process them
    mov A, wMusicScore                                                        ; $06cb : $e4, $00
    cmp A, #$fe                                                               ; $06cd : $68, $fe
    beq HandleCmdFEh_StopAndJmpIPL                                            ; $06cf : $f0, $d5

    cmp A, #$ff                                                               ; $06d1 : $68, $ff
    beq JmpHandleCmdFFh_LoadNewData                                           ; $06d3 : $f0, $c8

; Music can only be $01 to $0f
    cmp A, #$10                                                               ; $06d5 : $68, $10
    bcs @stopMusic                                                            ; $06d7 : $b0, $05

; Don't play music if SPC disabled
    mov X, wSPCDisabled                                                       ; $06d9 : $f8, $dd
    beq @playMusic                                                            ; $06db : $f0, $05

    ret                                                                       ; $06dd : $6f

@stopMusic:
    mov A, #$80                                                  ; $06de : $e8, $80
    mov wMusicScore, A                                                  ; $06e0 : $c4, $00

@playMusic:
; Jump if music to play is already being played
    mov Y, wMusicToPlay                                                       ; $06e2 : $eb, $08
    mov A, wMusicScore                                                        ; $06e4 : $e4, $00
    mov wMusicToPlay, A                                                       ; $06e6 : $c4, $08
    beq @sameMusic                                                            ; $06e8 : $f0, $04

; Else jump to process new music
    cmp Y, wMusicScore                                                        ; $06ea : $7e, $00
    bne JmpPlayNewMusic                                                       ; $06ec : $d0, $a9

@sameMusic:
;
    mov A, wCurrMusic                                                  ; $06ee : $e4, $db
    cmp A, #$80                                                  ; $06f0 : $68, $80
    beq Stub_0696                                                  ; $06f2 : $f0, $a2

    mov A, w0c                                                  ; $06f4 : $e4, $0c
    beq @afterPhraseProcessing                                                  ; $06f6 : $f0, $4c

    dbnz w0c, jmpResetAllTracks                                                  ; $06f8 : $6e, $0c, $a5

    @nextPhrase:
    ; Get phrase addr from music's phrase table, and jump if non-0
        call !YAequNextPhraseAddr                                          ; $06fb : $3f, $24, $06
        bne @foundPhrase                                                   ; $06fe : $d0, $14

    ; Else jump to stop music
        mov Y, A                                                  ; $0700 : $fd
        beq jmpPlayMusic80h                                                  ; $0701 : $f0, $a0

    ; todo: never run? due to above bne+beq
        dec w42                                                  ; $0703 : $8b, $42
        bpl +                                                  ; $0705 : $10, $02
        mov w42, A                                                  ; $0707 : $c4, $42
    +   call !YAequNextPhraseAddr                                                  ; $0709 : $3f, $24, $06
        mov X, w42                                                  ; $070c : $f8, $42
        beq @nextPhrase                                                  ; $070e : $f0, $eb

        movw wSoundScorePtr, YA                                                  ; $0710 : $da, $40
        bra @nextPhrase                                                  ; $0712 : $2f, $e7

@foundPhrase:
    movw wMusicPhrasesTracksTable, YA                                         ; $0714 : $da, $16

; Save 8 tracks addresses
    mov Y, #$0f                                                               ; $0716 : $8d, $0f
-   mov A, [wMusicPhrasesTracksTable]+Y                                       ; $0718 : $f7, $16
    mov !wCurrPhraseTracksAddrs+Y, A                                          ; $071a : $d6, $30, $00
    dec Y                                                                     ; $071d : $dc
    bpl -                                                                     ; $071e : $10, $f8

; X is a word idx pointing to track 0
; wCurrTrackIdxBitfield shifts left each track to let us know when all 8 done
    mov X, #$00                                                               ; $0720 : $cd, $00
    mov wCurrTrackIdxBitfield, #$01                                           ; $0722 : $8f, $01, $47

    @@nextTrack:
    ; Skip clearing instrument if high byte of phrase is 0 (loop/jump)
        mov A, wCurrPhraseTracksAddrs+1+X                                     ; $0725 : $f4, $31
        beq @@afterSettingInstrument                                          ; $0727 : $f0, $0a

    ; If instrument idx is 0, apply it
        mov A, !wTrackInstrumentIdxes+X                                       ; $0729 : $f5, $11, $02
        bne @@afterSettingInstrument                                          ; $072c : $d0, $05

        mov A, #$00                                                           ; $072e : $e8, $00
        call !VCMDE0h_SetInstrumentA                                          ; $0730 : $3f, $26, $08

    @@afterSettingInstrument:
    ; Clear some lengths/counters for this new phrase
        mov A, #$00                                                           ; $0733 : $e8, $00
        mov wBlockLoopCtr+X,A                                                 ; $0735 : $d4, $80
        mov wTrackVolLen+X,A                                                  ; $0737 : $d4, $90
        mov wTrackPanLength+X,A                                               ; $0739 : $d4, $91
        inc A                                                                 ; $073b : $bc
        mov wCtrlTilNextTrackByte+X,A                                         ; $073c : $d4, $70

    ; To next track
        inc X                                                                 ; $073e : $3d
        inc X                                                                 ; $073f : $3d
        asl wCurrTrackIdxBitfield                                             ; $0740 : $0b, $47
        bne @@nextTrack                                                       ; $0742 : $d0, $e1

@afterPhraseProcessing:
; X is a word idx pointing to track 0
; wCurrTrackIdxBitfield shifts left each track to let us know when all 8 done
    mov X, #$00                                                  ; $0744 : $cd, $00
    mov $5e, X                                                  ; $0746 : $d8, $5e
    mov wCurrTrackIdxBitfield, #$01                                                  ; $0748 : $8f, $01, $47

    @@nextTrack:
    ; Preserve track work idx, and skip track if src addr=0
        mov wBackupTrackWordIdx, X                                            ; $074b : $d8, $44
        mov A, wCurrPhraseTracksAddrs+1+X                                     ; $074d : $f4, $31
        beq @@toNextTrack                                                     ; $074f : $f0, $66

        dec wCtrlTilNextTrackByte+X                                           ; $0751 : $9b, $70
        bne @@afterTrackByte                                                  ; $0753 : $d0, $5c

        @@nextTrackByte:
        ; Jump if track byte != 0 (end/return)
            call !YequNextTrackDataByte                                       ; $0755 : $3f, $1c, $08
            bne @@afterEndReturnCheck                                         ; $0758 : $d0, $17

        ; If loop counter is 0, go to the next phrase
            mov A, wBlockLoopCtr+X                                            ; $075a : $f4, $80
            beq @nextPhrase                                                   ; $075c : $f0, $9d

        ; Jump to the subroutine...
            call !JumpSubroutine                                              ; $075e : $3f, $7b, $09
            dec wBlockLoopCtr+X                                               ; $0761 : $9b, $80
            bne @@nextTrackByte                                               ; $0763 : $d0, $f0

        ; But return if loop ctr was 1
            mov A, !wTrackRetAddr+X                                           ; $0765 : $f5, $30, $02
            mov wCurrPhraseTracksAddrs+X,A                                    ; $0768 : $d4, $30
            mov A, !wTrackRetAddr+1+X                                         ; $076a : $f5, $31, $02
            mov wCurrPhraseTracksAddrs+1+X,A                                  ; $076d : $d4, $31
            bra @@nextTrackByte                                               ; $076f : $2f, $e4

        @@afterEndReturnCheck:
        ; Jump if track byte bit 7 set (not note params)
            bmi @@afterNoteParamsCheck                                        ; $0771 : $30, $20

        ; Note params - set note, and process next byte if its bit 7 is clear
            mov !wPendingCtrlTilNextTrackByte+X, A                            ; $0773 : $d5, $00, $02
            call !YequNextTrackDataByte                                       ; $0776 : $3f, $1c, $08
            bmi @@afterNoteParamsCheck                                        ; $0779 : $30, $18

        ; The next byte's high nybble determines the note duration from this table
            push A                                                            ; $077b : $2d
            xcn A                                                             ; $077c : $9f
            and A, #$07                                                       ; $077d : $28, $07
            mov Y, A                                                          ; $077f : $fd
            mov A, !NoteDurationRates+Y                                       ; $0780 : $f6, $10, $4c
            mov !wTrackDurationOfNote+X, A                                    ; $0783 : $d5, $01, $02

        ; Its low nybble determines the note velocity from this table
            pop A                                                             ; $0786 : $ae
            and A, #$0f                                                       ; $0787 : $28, $0f
            mov Y, A                                                          ; $0789 : $fd
            mov A, !NoteVelocityRates+Y                                       ; $078a : $f6, $18, $4c
            mov !wTrackVelocityOfNote+X, A                                    ; $078d : $d5, $10, $02
            call !YequNextTrackDataByte                                       ; $0790 : $3f, $1c, $08

        @@afterNoteParamsCheck:
        ; Jump if VCMD < $e0
            cmp A, #$e0                                                       ; $0793 : $68, $e0
            bcc @@vcmdLtE0h                                                   ; $0795 : $90, $05

            call !HandleVCMDGteE0h                                            ; $0797 : $3f, $0a, $08
            bra @@nextTrackByte                                               ; $079a : $2f, $b9

    @@vcmdLtE0h:
    ; Handle note
        call !HandleVCMDBetween80hAndDFh                                      ; $079c : $3f, $28, $05

    ; Frames til next track byte = >(ctr * note duration)
        mov A, !wPendingCtrlTilNextTrackByte+X                                ; $079f : $f5, $00, $02
        mov wCtrlTilNextTrackByte+X,A                                         ; $07a2 : $d4, $70
        mov Y, A                                                              ; $07a4 : $fd
        mov A, !wTrackDurationOfNote+X                                        ; $07a5 : $f5, $01, $02
        mul YA                                                                ; $07a8 : $cf
        mov A, Y                                                              ; $07a9 : $dd

    ; Frame wait is minimum 1
        bne +                                                                 ; $07aa : $d0, $01
        inc A                                                                 ; $07ac : $bc
    +   mov wFramesTilNextTrackByte+X,A                                       ; $07ad : $d4, $71
        bra +                                                                 ; $07af : $2f, $03

    @@afterTrackByte:
        call !tickTrackUpdate                                            ; $07b1 : $3f, $2b, $0c

    +   call !Call_00_0aa6                                             ; $07b4 : $3f, $a6, $0a

    @@toNextTrack:
    ; Move active track in bitfield
        inc X                                                                 ; $07b7 : $3d
        inc X                                                                 ; $07b8 : $3d
        asl wCurrTrackIdxBitfield                                             ; $07b9 : $0b, $47
        bne @@nextTrack                                                       ; $07bb : $d0, $8e

; After track processing, if tempo length is set...
    mov A, wTempoLength                                                       ; $07bd : $e4, $54
    beq @afterTempoAdjust                                                     ; $07bf : $f0, $0b

; Add increment to tempo val, decreasing length
; Set tempo to 0 once length == 0
    movw YA, wTempoIncrPer1Length                                             ; $07c1 : $ba, $56
    addw YA, wTempoVal                                                        ; $07c3 : $7a, $52
    dbnz wTempoLength, +                                                      ; $07c5 : $6e, $54, $02
    movw YA, wTempoLength                                                     ; $07c8 : $ba, $54
+   movw wTempoVal, YA                                                        ; $07ca : $da, $52

@afterTempoAdjust:
; If echo volume fade length is set...
    mov A, wEchoVolFadeLen                                                    ; $07cc : $e4, $68
    beq @afterEchoFade                                                        ; $07ce : $f0, $15

; Add increment to echo volume left
    movw YA, wEchoLeftVolIncrPer1Length                                       ; $07d0 : $ba, $64
    addw YA, wEchoVolL                                                        ; $07d2 : $7a, $60
    movw wEchoVolL, YA                                                        ; $07d4 : $da, $60

;
    movw YA, wEchoRightVolIncrPer1Length                                                  ; $07d6 : $ba, $66
    addw YA, wEchoVolR                                                  ; $07d8 : $7a, $62
    dbnz wEchoVolFadeLen, @setEchoVolR                                                  ; $07da : $6e, $68, $06

    movw YA, wEchoVolFadeLen                                                  ; $07dd : $ba, $68
    movw wEchoVolL, YA                                                  ; $07df : $da, $60
    mov Y, wEchoVolDestRight                                                  ; $07e1 : $eb, $6a

@setEchoVolR:
    movw wEchoVolR, YA                                                  ; $07e3 : $da, $62

@afterEchoFade:
; If master volume length is set...
    mov A, wMasterVolLength                                                   ; $07e5 : $e4, $5a
    beq @afterMasterVolFade                                                   ; $07e7 : $f0, $0e

; Add increment to master volume
; Set volume to 0 once length == 0
    movw YA, wMasterVolIncrPer1Length                                         ; $07e9 : $ba, $5c
    addw YA, wMasterVolume                                                    ; $07eb : $7a, $58
    dbnz wMasterVolLength, +                                                  ; $07ed : $6e, $5a, $02
    movw YA, wMasterVolLength                                                 ; $07f0 : $ba, $5a
+   movw wMasterVolume, YA                                                    ; $07f2 : $da, $58

;
    mov $5e, #$ff                                                  ; $07f4 : $8f, $ff, $5e

@afterMasterVolFade:
; X is a word idx pointing to track 0
; wCurrTrackIdxBitfield shifts left each track to let us know when all 8 done
    mov X, #$00                                                  ; $07f7 : $cd, $00
    mov wCurrTrackIdxBitfield, #$01                                                  ; $07f9 : $8f, $01, $47

    @@nextTrack:
        mov A, wCurrPhraseTracksAddrs+1+X                                                  ; $07fc : $f4, $31
        beq +                                                  ; $07fe : $f0, $03
        call !Call_00_0b62                                                  ; $0800 : $3f, $62, $0b
    +   inc X                                                  ; $0803 : $3d
        inc X                                                  ; $0804 : $3d
        asl wCurrTrackIdxBitfield                                                  ; $0805 : $0b, $47
        bne @@nextTrack                                                  ; $0807 : $d0, $f3

    ret                                                  ; $0809 : $6f


; A - the VCMD byte
HandleVCMDGteE0h:
; *2 to get a table word idx, $e0->$c0
    asl A                                                                     ; $080a : $1c
    mov Y, A                                                                  ; $080b : $fd

; Push handler for the VCMD
    mov A, !VCMDGteE0hHandlers-$c0+1+Y                                        ; $080c : $f6, $46, $0a
    push A                                                                    ; $080f : $2d
    mov A, !VCMDGteE0hHandlers-$c0+Y                                          ; $0810 : $f6, $45, $0a
    push A                                                                    ; $0813 : $2d

; Y = VCMD-$80, $e0->$60
    mov A, Y                                                                  ; $0814 : $dd
    lsr A                                                                     ; $0815 : $5c
    mov Y, A                                                                  ; $0816 : $fd

; Get a track data byte in Y if non-0
    mov A, !VCMDGteE0hNumParams-$60+Y                                         ; $0817 : $f6, $e3, $0a
    beq retWithYequA                                                          ; $081a : $f0, $08

YequNextTrackDataByte:
    mov A, [wCurrPhraseTracksAddrs+X]                                         ; $081c : $e7, $30

IncTrackDataSrc:
    inc wCurrPhraseTracksAddrs+X                                              ; $081e : $bb, $30
    bne +                                                                     ; $0820 : $d0, $02
    inc wCurrPhraseTracksAddrs+1+X                                            ; $0822 : $bb, $31
retWithYequA:
+   mov Y, A                                                                  ; $0824 : $fd
    ret                                                                       ; $0825 : $6f


; A - instrument idx ($ca-$df for percussion)
; X - track word idx
VCMDE0h_SetInstrumentA:
; Save curr instrument
    mov !wTrackInstrumentIdxes+X, A                                           ; $0826 : $d5, $11, $02

; A - instrument idx ($ca-$df for percussion)
; X - track word idx
ApplyInstrumentA:
; If percussion idx...
    mov Y, A                                                                  ; $0829 : $fd
    bpl @afterPercussionIdx                                                   ; $082a : $10, $06

; Instrument is 0-idxed from percussion patch base
    setc                                                                      ; $082c : $80
    sbc A, #$ca                                                               ; $082d : $a8, $ca
    clrc                                                                      ; $082f : $60
    adc A, wPercussionPatchBase                                               ; $0830 : $84, $5f

@afterPercussionIdx:
; Get 6-byte data for curr instrument
    mov Y, #$06                                                               ; $0832 : $8d, $06
    mul YA                                                                    ; $0834 : $cf
    movw wInstrumentDataPtr, YA                                               ; $0835 : $da, $14
    clrc                                                                      ; $0837 : $60
    adc wInstrumentDataPtr, #<InstrumentsData                                 ; $0838 : $98, $30, $14
    adc wInstrumentDataPtr+1, #>InstrumentsData                               ; $083b : $98, $4c, $15

; Skip below setting of hardware regs if a sound effect is using this track
    mov A, wBitfieldOfSndEffectsTracksUsed                                    ; $083e : $e4, $1a
    and A, wCurrTrackIdxBitfield                                              ; $0840 : $24, $47
    bne @done                                                                 ; $0842 : $d0, $48

; Preserving the track word idx, get the track's SRCN in X
    push X                                                                    ; $0844 : $4d
    mov A, X                                                                  ; $0845 : $7d
    xcn A                                                                     ; $0846 : $9f
    lsr A                                                                     ; $0847 : $5c
    or A, #SRCN                                                               ; $0848 : $08, $04
    mov X, A                                                                  ; $084a : $5d

; Get 1st byte for instrument. If bit 7 clear, it's for SRCN
    mov Y, #$00                                                               ; $084b : $8d, $00
    mov A, [wInstrumentDataPtr]+Y                                             ; $084d : $f7, $14
    bpl @br_086d                                                              ; $084f : $10, $1c

; If bit 7 clear, the low 5 bits is the noise clock rate
    and A, #$1f                                                               ; $0851 : $28, $1f
    mov wNoiseClockRate, Y                                                    ; $0853 : $cb, $dc

; Set mute flag if SPC is disabled
    mov Y, wSPCDisabled                                                       ; $0855 : $eb, $dd
    beq @unmute                                                               ; $0857 : $f0, $04

    set1 wDSPflags.FLGB_MUTE                                                  ; $0859 : $c2, $48
    bra +                                                                     ; $085b : $2f, $02

@unmute:
    clr1 wDSPflags.FLGB_MUTE                                                  ; $085d : $d2, $48

;
+   and wDSPflags, #FLGF_MUTE|FLGF_ECHO_DISABLE                                                  ; $085f : $38, $60, $48
    tset1 !wDSPflags                                                  ; $0862 : $0e, $48, $00

;
    mov Y, wNoiseClockRate                                                  ; $0865 : $eb, $dc
    or w49, wCurrTrackIdxBitfield                                                  ; $0867 : $09, $47, $49

; The noise clock directory is also the SRCN
    mov A, Y                                                  ; $086a : $dd
    bra @setFromSrcn                                                  ; $086b : $2f, $07

@br_086d:
;
    mov A, wCurrTrackIdxBitfield                                                  ; $086d : $e4, $47
    tclr1 !w49                                                  ; $086f : $4e, $49, $00

@nextDSPreg:
; With X starting at x4, this writes to SRCN, ADSR1/2, and GAIN
    mov A, [wInstrumentDataPtr]+Y                                             ; $0872 : $f7, $14

@setFromSrcn:
    mov !DSP_REG_ADDR, X                                                      ; $0874 : $c9, $f2, $00
    mov !DSP_REG_DATA, A                                                      ; $0877 : $c5, $f3, $00
    inc X                                                                     ; $087a : $3d
    inc Y                                                                     ; $087b : $fc
    cmp Y, #$04                                                               ; $087c : $ad, $04
    bne @nextDSPreg                                                           ; $087e : $d0, $f2

    pop X                                                                     ; $0880 : $ce

; Last word is pitch base multiplier
    mov A, [wInstrumentDataPtr]+Y                                             ; $0881 : $f7, $14
    mov !wPitchBaseMultiplier+1+X, A                                          ; $0883 : $d5, $21, $02
    inc Y                                                                     ; $0886 : $fc

    mov A, [wInstrumentDataPtr]+Y                                             ; $0887 : $f7, $14
    mov !wPitchBaseMultiplier+X, A                                            ; $0889 : $d5, $20, $02

@done:
    ret                                                                       ; $088c : $6f


; A - pan value (low 5 bits is pan value, high 2 bits is phase reverse switch)
; Note: only values $00-$14 are intended
VCMDE1h_SetPanA:
; Pan value is high byte of a pan word
    mov !wTrackPanFullVal+X, A                                                ; $088d : $d5, $51, $03
    and A, #$1f                                                               ; $0890 : $28, $1f
    mov !wTrackPanValue+1+X, A                                                ; $0892 : $d5, $31, $03
    mov A, #$00                                                               ; $0895 : $e8, $00
    mov !wTrackPanValue+X, A                                                  ; $0897 : $d5, $30, $03
    ret                                                                       ; $089a : $6f


; A - length
; Next track byte - pan dest
VCMDE2h_PanFade:
; Set length and stack it
    mov wTrackPanLength+X,A                                                   ; $089b : $d4, $91
    push A                                                                    ; $089d : $2d

; Get pan dest (high) - pan val high in A
    call !YequNextTrackDataByte                                               ; $089e : $3f, $1c, $08
    mov !wTrackPanDest+X, A                                                   ; $08a1 : $d5, $50, $03
    setc                                                                      ; $08a4 : $80
    sbc A, !wTrackPanValue+1+X                                                ; $08a5 : $b5, $31, $03

; X = length, A = pan range. Store the range increment per 1 length
    pop X                                                                     ; $08a8 : $ce
    call !YAequRangeDivLength                                                 ; $08a9 : $3f, $e9, $0a
    mov !wTrackPanIncrPer1Length+X, A                                         ; $08ac : $d5, $40, $03
    mov A, Y                                                                  ; $08af : $dd
    mov !wTrackPanIncrPer1Length+1+X, A                                       ; $08b0 : $d5, $41, $03
    ret                                                                       ; $08b3 : $6f


; A - delay
; Next track byte - rate
; Next track byte - depth
VCMDE3h_VibratoOn:
; Set delay and rate
    mov !wTrackVibratoDelay+X, A                                              ; $08b4 : $d5, $b0, $02
    call !YequNextTrackDataByte                                               ; $08b7 : $3f, $1c, $08
    mov !wTrackVibratoRate+X, A                                               ; $08ba : $d5, $a1, $02

; Set depth
    call !YequNextTrackDataByte                                               ; $08bd : $3f, $1c, $08

; A - vibrato depth, 0 if directly calling VCMD $e4
VCMDE4h_VibratoOff:
; Set depth (curr/target vibrato val)
    mov wTrackCurrVibratoVal+X,A                                              ; $08c0 : $d4, $b1
    mov !wTrackVibratoDepth+X, A                                              ; $08c2 : $d5, $c1, $02

; Reset fade
    mov A, #$00                                                               ; $08c5 : $e8, $00
    mov !wTrackVibratoFadeLen+X, A                                            ; $08c7 : $d5, $b1, $02
    ret                                                                       ; $08ca : $6f


; A - length (fades from 0 to curr value)
VCMDF0h_VibratoFade:
; Store length, and do curr vibrato val / length
    mov !wTrackVibratoFadeLen+X, A                                            ; $08cb : $d5, $b1, $02
    push A                                                                    ; $08ce : $2d
    mov Y, #$00                                                               ; $08cf : $8d, $00
    mov A, wTrackCurrVibratoVal+X                                             ; $08d1 : $f4, $b1
    pop X                                                                     ; $08d3 : $ce
    div YA, X                                                                 ; $08d4 : $9e

; Restore track word idx, and save incr per 1 length
    mov X, wBackupTrackWordIdx                                                ; $08d5 : $f8, $44
    mov !wTrackVibratoIcrPer1Length+X, A                                      ; $08d7 : $d5, $c0, $02
    ret                                                                       ; $08da : $6f


; Y - high byte of master volume
VCMDE5h_SetMasterVolume:
    mov A, #$00                                                               ; $08db : $e8, $00
    movw wMasterVolume, YA                                                    ; $08dd : $da, $58
    ret                                                                       ; $08df : $6f


; A - length
; Next track byte - destination
VCMDE6h_MasterVolumeFade:
; Save length and dest
    mov wMasterVolLength, A                                                   ; $08e0 : $c4, $5a
    call !YequNextTrackDataByte                                               ; $08e2 : $3f, $1c, $08
    mov wMasterVolDest, A                                                     ; $08e5 : $c4, $5b

; Get range from dest-vol, and save volume incr per length ctr
    setc                                                                      ; $08e7 : $80
    sbc A, wMasterVolume+1                                                    ; $08e8 : $a4, $59
    mov X, wMasterVolLength                                                   ; $08ea : $f8, $5a
    call !YAequRangeDivLength                                                 ; $08ec : $3f, $e9, $0a
    movw wMasterVolIncrPer1Length, YA                                         ; $08ef : $da, $5c
    ret                                                                       ; $08f1 : $6f


; Y - high byte of tempo word
VCMDE7h_SetTempo:
    mov A, #$00                                                               ; $08f2 : $e8, $00
    movw wTempoVal, YA                                                        ; $08f4 : $da, $52
    ret                                                                       ; $08f6 : $6f


; A - length
; Next track byte - destination
VCMDE8h_TempoFade:
; Save length and dest
    mov wTempoLength, A                                                       ; $08f7 : $c4, $54
    call !YequNextTrackDataByte                                               ; $08f9 : $3f, $1c, $08
    mov wTempoDest, A                                                         ; $08fc : $c4, $55

; Get range from dest-vol, and save tempo incr per length ctr
    setc                                                                      ; $08fe : $80
    sbc A, wTempoVal+1                                                        ; $08ff : $a4, $53
    mov X, wTempoLength                                                       ; $0901 : $f8, $54
    call !YAequRangeDivLength                                                 ; $0903 : $3f, $e9, $0a
    movw wTempoIncrPer1Length, YA                                             ; $0906 : $da, $56
    ret                                                                       ; $0908 : $6f


VCMDE9h_GlobalTranspose:
    mov wGlobalTranspose, A                                                   ; $0909 : $c4, $50
    ret                                                                       ; $090b : $6f


VCMDEAh_PerVoiceTranspose:
    mov !wTrackTranspose+X, A                                                 ; $090c : $d5, $f0, $02
    ret                                                                       ; $090f : $6f


; A - delay
; Next track byte - rate
; Next track byte - depth
VCMDEBh_TremoloOn:
; Save delay and rate
    mov !wTrackTremoloDelay+X, A                                              ; $0910 : $d5, $e0, $02
    call !YequNextTrackDataByte                                               ; $0913 : $3f, $1c, $08
    mov !wTrackTremoloRate+X, A                                               ; $0916 : $d5, $d1, $02

; Set depth
    call !YequNextTrackDataByte                                               ; $0919 : $3f, $1c, $08

; A - tremolo depth, 0 if directly calling VCMD $e4
VCMDECh_TremoloOff:
    mov wTrackTremoloDepth+X,A                                                ; $091c : $d4, $c1
    ret                                                                       ; $091e : $6f


; Y - delay
; Next track byte - length
; Next track byte - key (signed)
VCMDF1h_PitchEnvelopeTo:
    mov A, #$01                                                               ; $091f : $e8, $01
    bra +                                                                     ; $0921 : $2f, $02

; Y - delay
; Next track byte - length
; Next track byte - key (signed)
VCMDF2h_PitchEnvelopeFrom:
    mov A, #$00                                                               ; $0923 : $e8, $00
+   mov !wTrackPitchEnvelopeIsTo+X, A                                         ; $0925 : $d5, $90, $02

; Set delay, length and key
    mov A, Y                                                                  ; $0928 : $dd
    mov !wTrackPitchEnvelopeDelay+X, A                                        ; $0929 : $d5, $81, $02
    call !YequNextTrackDataByte                                               ; $092c : $3f, $1c, $08
    mov !wTrackPitchEnvelopeLen+X, A                                          ; $092f : $d5, $80, $02
    call !YequNextTrackDataByte                                               ; $0932 : $3f, $1c, $08
    mov !wTrackPitchEnvelopeKey+X, A                                          ; $0935 : $d5, $91, $02
    ret                                                                       ; $0938 : $6f


VCMDF3h_PitchEnvelopeOff:
    mov !wTrackPitchEnvelopeLen+X, A                                          ; $0939 : $d5, $80, $02
    ret                                                                       ; $093c : $6f


; A - high byte of volume
VCMDEDh_TrackVolume:
    mov !wTrackVolume+1+X, A                                                  ; $093d : $d5, $01, $03
    mov A, #$00                                                               ; $0940 : $e8, $00
    mov !wTrackVolume+X, A                                                    ; $0942 : $d5, $00, $03
    ret                                                                       ; $0945 : $6f


; A - length
; Next track byte - destination
VCMDEEh_VolumeFade:
; Save length and stack it
    mov wTrackVolLen+X,A                                                      ; $0946 : $d4, $90
    push A                                                                    ; $0948 : $2d

; Get vol dest (high) - vol high in A
    call !YequNextTrackDataByte                                               ; $0949 : $3f, $1c, $08
    mov !wTrackVolDest+X, A                                                   ; $094c : $d5, $20, $03
    setc                                                                      ; $094f : $80
    sbc A, !wTrackVolume+1+X                                                  ; $0950 : $b5, $01, $03

; X = length, A = vol range. Store the range increment per 1 length
    pop X                                                                     ; $0953 : $ce
    call !YAequRangeDivLength                                                 ; $0954 : $3f, $e9, $0a
    mov !wTrackVolIncrPer1Length+X, A                                         ; $0957 : $d5, $10, $03
    mov A, Y                                                                  ; $095a : $dd
    mov !wTrackVolIncrPer1Length+1+X, A                                       ; $095b : $d5, $11, $03
    ret                                                                       ; $095e : $6f


VCMDF4h_Tuning:
    mov !wTrackTuning+X, A                                                    ; $095f : $d5, $81, $03
    ret                                                                       ; $0962 : $6f


; A - low byte of subroutine
; Next track byte - high byte
; Next track byte - +1 is num times to loop
VCMDEFh_CallSubroutine:
; Set subroutine address
    mov !wTrackSubroutineAddr+X, A                                            ; $0963 : $d5, $40, $02
    call !YequNextTrackDataByte                                               ; $0966 : $3f, $1c, $08
    mov !wTrackSubroutineAddr+1+X, A                                          ; $0969 : $d5, $41, $02

; Set loop times
    call !YequNextTrackDataByte                                               ; $096c : $3f, $1c, $08
    mov wBlockLoopCtr+X,A                                                     ; $096f : $d4, $80

; Save return address
    mov A, wCurrPhraseTracksAddrs+X                                           ; $0971 : $f4, $30
    mov !wTrackRetAddr+X, A                                                   ; $0973 : $d5, $30, $02
    mov A, wCurrPhraseTracksAddrs+1+X                                         ; $0976 : $f4, $31
    mov !wTrackRetAddr+1+X, A                                                 ; $0978 : $d5, $31, $02

JumpSubroutine:
    mov A, !wTrackSubroutineAddr+X                                            ; $097b : $f5, $40, $02
    mov wCurrPhraseTracksAddrs+X,A                                            ; $097e : $d4, $30
    mov A, !wTrackSubroutineAddr+1+X                                          ; $0980 : $f5, $41, $02
    mov wCurrPhraseTracksAddrs+1+X,A                                          ; $0983 : $d4, $31
    ret                                                                       ; $0985 : $6f


; A - echo switch (EON)
; Next track byte - EVOL L
; Next track byte - EVOL R
VCMDF5h_EchoVBitsVolume:
    mov wd4, A                                                  ; $0986 : $c4, $d4
    mov Y, !wSoundEffectAIdxForTrack7                                                  ; $0988 : $ec, $67, $02
    bne @cont_0998                                                  ; $098b : $d0, $0b

    mov A, wd4                                                  ; $098d : $e4, $d4
    and A, #$80                                                  ; $098f : $28, $80
    and w4a, #$7f                                                  ; $0991 : $38, $7f, $4a
    or A, w4a                                                  ; $0994 : $04, $4a
    mov w4a, A                                                  ; $0996 : $c4, $4a

@cont_0998:
    mov Y, !wSoundEffectAIdxForTrack6                                                  ; $0998 : $ec, $66, $02
    bne @cont_09a8                                                  ; $099b : $d0, $0b

    mov A, wd4                                                  ; $099d : $e4, $d4
    and A, #$40                                                  ; $099f : $28, $40
    and w4a, #$bf                                                  ; $09a1 : $38, $bf, $4a
    or A, w4a                                                  ; $09a4 : $04, $4a
    mov w4a, A                                                  ; $09a6 : $c4, $4a

@cont_09a8:
    mov Y, !wSoundEffectBIdxForTrack5                                                  ; $09a8 : $ec, $65, $02
    bne @cont_09b8                                                  ; $09ab : $d0, $0b

    mov A, wd4                                                  ; $09ad : $e4, $d4
    and A, #$20                                                  ; $09af : $28, $20
    and w4a, #$df                                                  ; $09b1 : $38, $df, $4a
    or A, w4a                                                  ; $09b4 : $04, $4a
    mov w4a, A                                                  ; $09b6 : $c4, $4a

@cont_09b8:
    mov Y, !wSoundEffectBIdxForTrack4                                                  ; $09b8 : $ec, $64, $02
    bne @cont_09c8                                                  ; $09bb : $d0, $0b

    mov A, wd4                                                  ; $09bd : $e4, $d4
    and A, #$10                                                  ; $09bf : $28, $10
    and w4a, #$ef                                                  ; $09c1 : $38, $ef, $4a
    or A, w4a                                                  ; $09c4 : $04, $4a
    mov w4a, A                                                  ; $09c6 : $c4, $4a

@cont_09c8:
    mov A, wd4                                                  ; $09c8 : $e4, $d4
    and A, #$08                                                  ; $09ca : $28, $08
    and w4a, #$f7                                                  ; $09cc : $38, $f7, $4a
    or A, w4a                                                  ; $09cf : $04, $4a
    mov w4a, A                                                  ; $09d1 : $c4, $4a
    mov A, wd4                                                  ; $09d3 : $e4, $d4
    and A, #$04                                                  ; $09d5 : $28, $04
    and w4a, #$fb                                                  ; $09d7 : $38, $fb, $4a
    or A, w4a                                                  ; $09da : $04, $4a
    mov w4a, A                                                  ; $09dc : $c4, $4a
    mov Y, !wSoundEffectBIdxForTrack1                                                  ; $09de : $ec, $61, $02
    bne @cont_09ee                                                  ; $09e1 : $d0, $0b

    mov A, wd4                                                  ; $09e3 : $e4, $d4
    and A, #$02                                                  ; $09e5 : $28, $02
    and w4a, #$fd                                                  ; $09e7 : $38, $fd, $4a
    or A, w4a                                                  ; $09ea : $04, $4a
    mov w4a, A                                                  ; $09ec : $c4, $4a

@cont_09ee:
    mov Y, !wSoundEffectBIdxForTrack0                                                  ; $09ee : $ec, $60, $02
    bne @cont_09fe                                                  ; $09f1 : $d0, $0b

    mov A, wd4                                                  ; $09f3 : $e4, $d4
    and A, #$01                                                  ; $09f5 : $28, $01
    and w4a, #$fe                                                  ; $09f7 : $38, $fe, $4a
    or A, w4a                                                  ; $09fa : $04, $4a
    mov w4a, A                                                  ; $09fc : $c4, $4a

@cont_09fe:
; get evoll
    call !YequNextTrackDataByte                                                  ; $09fe : $3f, $1c, $08
    mov A, #$00                                                  ; $0a01 : $e8, $00
    movw wEchoVolL, YA                                                  ; $0a03 : $da, $60
    mov $d9, Y                                                  ; $0a05 : $cb, $d9

; get evolr
    call !YequNextTrackDataByte                                                  ; $0a07 : $3f, $1c, $08
    mov A, #$00                                                  ; $0a0a : $e8, $00
    movw wEchoVolR, YA                                                  ; $0a0c : $da, $62
    mov $da, Y                                                  ; $0a0e : $cb, $da

; Enable echo
    clr1 wDSPflags.FLGB_ECHO_DISABLE                                                  ; $0a10 : $b2, $48
    ret                                                  ; $0a12 : $6f


; A - length
; Next track byte - left vol dest
; Next track byte - right vol dest
VCMDF8h_EchoVolumeFade:
    mov wEchoVolFadeLen, A                                                    ; $0a13 : $c4, $68

; Get range from left dest - vol, and save left vol incr per length ctr
    call !YequNextTrackDataByte                                               ; $0a15 : $3f, $1c, $08
    mov wEchoVolDestLeft, A                                                   ; $0a18 : $c4, $69
    setc                                                                      ; $0a1a : $80
    sbc A, wEchoVolL+1                                                        ; $0a1b : $a4, $61
    mov X, wEchoVolFadeLen                                                    ; $0a1d : $f8, $68
    call !YAequRangeDivLength                                                 ; $0a1f : $3f, $e9, $0a
    movw wEchoLeftVolIncrPer1Length, YA                                       ; $0a22 : $da, $64

; Get range from right dest - vol, and save right vol incr per length ctr
    call !YequNextTrackDataByte                                               ; $0a24 : $3f, $1c, $08
    mov wEchoVolDestRight, A                                                  ; $0a27 : $c4, $6a
    setc                                                                      ; $0a29 : $80
    sbc A, wEchoVolR+1                                                        ; $0a2a : $a4, $63
    mov X, wEchoVolFadeLen                                                    ; $0a2c : $f8, $68
    call !YAequRangeDivLength                                                 ; $0a2e : $3f, $e9, $0a
    movw wEchoRightVolIncrPer1Length, YA                                      ; $0a31 : $da, $66
    ret                                                                       ; $0a33 : $6f


; YA - 0
VCMDF6h_EchoOff:
; Clear echo volume and disable echo
    movw wEchoVolL, YA                                                        ; $0a34 : $da, $60
    movw wEchoVolR, YA                                                        ; $0a36 : $da, $62
    set1 wDSPflags.FLGB_ECHO_DISABLE                                          ; $0a38 : $a2, $48
    ret                                                                       ; $0a3a : $6f


; A - Echo delay (EDL)
; Next track byte - EFB
; Next track byte - Echo filter (0-3 idx in table)
VCMDF7h_EchoParameters:
; 1st param byte sets echo delay
    call !SetEchoDelayAndBufferStart                                          ; $0a3b : $3f, $5d, $0a

; 2nd param is echo feedback
    call !YequNextTrackDataByte                                               ; $0a3e : $3f, $1c, $08
    mov wEchoFeedback, A                                                      ; $0a41 : $c4, $4e

; 3rd param is echo filter idx
    call !YequNextTrackDataByte                                               ; $0a43 : $3f, $1c, $08

; A - Echo filter idx
SetEchoFilterCoef:
; Get 8-byte entry for filter
    mov Y, #$08                                                               ; $0a46 : $8d, $08
    mul YA                                                                    ; $0a48 : $cf
    mov X, A                                                                  ; $0a49 : $5d

; Set all 8 bytes of the filter coefficient
    mov Y, #COEF                                                              ; $0a4a : $8d, $0f

@nextByte:
    mov A, !FilterCoefficients+X                                              ; $0a4c : $f5, $d5, $0d
    call !SetDspAddrDataToYA                                                  ; $0a4f : $3f, $1d, $06
    inc X                                                                     ; $0a52 : $3d

; To next xCOEF
    mov A, Y                                                                  ; $0a53 : $dd
    clrc                                                                      ; $0a54 : $60
    adc A, #$10                                                               ; $0a55 : $88, $10
    mov Y, A                                                                  ; $0a57 : $fd
    bpl @nextByte                                                             ; $0a58 : $10, $f2

; Restore track word idx
    mov X, wBackupTrackWordIdx                                                ; $0a5a : $f8, $44
    ret                                                                       ; $0a5c : $6f


; A - echo delay
SetEchoDelayAndBufferStart:
    mov wEchoDelay, A                                                         ; $0a5d : $c4, $4d

; Skip below if echo delay is the same
    mov Y, #EDL                                                               ; $0a5f : $8d, $7d
    mov !DSP_REG_ADDR, Y                                                      ; $0a61 : $cc, $f2, $00
    mov A, !DSP_REG_DATA                                                      ; $0a64 : $e5, $f3, $00
    cmp A, wEchoDelay                                                         ; $0a67 : $64, $4d
    beq @setEchoStartAddr                                                     ; $0a69 : $f0, $2b

;
    and A, #$0f                                                  ; $0a6b : $28, $0f
    eor A, #$ff                                                  ; $0a6d : $48, $ff
    bbc $4c.7, +                                                  ; $0a6f : $f3, $4c, $03

    clrc                                                  ; $0a72 : $60
    adc A, $4c                                                  ; $0a73 : $84, $4c

+   mov $4c, A                                                  ; $0a75 : $c4, $4c

; Clear all echo registers
    mov Y, #$04                                                               ; $0a77 : $8d, $04
-   mov A, !EchoDSPregs-1+Y                                                   ; $0a79 : $f6, $f4, $0d
    mov !DSP_REG_ADDR, A                                                      ; $0a7c : $c5, $f2, $00
    mov A, #$00                                                               ; $0a7f : $e8, $00
    mov !DSP_REG_DATA, A                                                      ; $0a81 : $c5, $f3, $00
    dbnz Y, -                                                                 ; $0a84 : $fe, $f3

; Set DSP flags to disable echo
    mov A, wDSPflags                                                          ; $0a86 : $e4, $48
    or A, #FLGF_ECHO_DISABLE                                                  ; $0a88 : $08, $20
    mov Y, #FLG                                                               ; $0a8a : $8d, $6c
    call !SetDspAddrDataToYA                                                  ; $0a8c : $3f, $1d, $06

; Update echo delay
    mov A, wEchoDelay                                                         ; $0a8f : $e4, $4d
    mov Y, #EDL                                                               ; $0a91 : $8d, $7d
    call !SetDspAddrDataToYA                                                  ; $0a93 : $3f, $1d, $06

@setEchoStartAddr:
; Convert eg 1->$f7, 2->$ef, 3->$e7
    asl A                                                                     ; $0a96 : $1c
    asl A                                                                     ; $0a97 : $1c
    asl A                                                                     ; $0a98 : $1c
    eor A, #$ff                                                               ; $0a99 : $48, $ff
    setc                                                                      ; $0a9b : $80
    adc A, #$ff                                                               ; $0a9c : $88, $ff
    mov Y, #ESA                                                               ; $0a9e : $8d, $6d
    jmp !SetDspAddrDataToYA                                                   ; $0aa0 : $5f, $1d, $06


VCMDFAh_PercussionPatchBase:
    mov wPercussionPatchBase, A                                               ; $0aa3 : $c4, $5f
    ret                                                                       ; $0aa5 : $6f


Call_00_0aa6:
    mov A, wPitchSlideLength+X                                                  ; $0aa6 : $f4, $a0
    bne Stub_0add                                                  ; $0aa8 : $d0, $33

    mov A, [wCurrPhraseTracksAddrs+X]                                                  ; $0aaa : $e7, $30
    cmp A, #$f9                                                  ; $0aac : $68, $f9
    bne Stub_0add                                                  ; $0aae : $d0, $2d

    call !IncTrackDataSrc                                                  ; $0ab0 : $3f, $1e, $08
    call !YequNextTrackDataByte                                                  ; $0ab3 : $3f, $1c, $08

; A - delay
; Next track byte - length
; Next track byte - note vbyte
VCMDF9h_PitchSlide:
; Set delay and length
    mov wPitchSlideDelay+X,A                                                  ; $0ab6 : $d4, $a1
    call !YequNextTrackDataByte                                                  ; $0ab8 : $3f, $1c, $08
    mov wPitchSlideLength+X,A                                                  ; $0abb : $d4, $a0

; Get note and adjust with transposes
    call !YequNextTrackDataByte                                                  ; $0abd : $3f, $1c, $08
    clrc                                                  ; $0ac0 : $60
    adc A, wGlobalTranspose                                                  ; $0ac1 : $84, $50
    adc A, !wTrackTranspose+X                                                  ; $0ac3 : $95, $f0, $02

; A - note after transpose
Call_00_0ac6:
    and A, #$7f                                                  ; $0ac6 : $28, $7f
    mov !$0380+X, A                                                  ; $0ac8 : $d5, $80, $03
    setc                                                  ; $0acb : $80
    sbc A, !wTrackNoteAfterTransposeTuning+1+X                                                  ; $0acc : $b5, $61, $03
    mov Y, wPitchSlideLength+X                                                  ; $0acf : $fb, $a0
    push Y                                                  ; $0ad1 : $6d
    pop X                                                  ; $0ad2 : $ce
    call !YAequRangeDivLength                                                  ; $0ad3 : $3f, $e9, $0a
    mov !$0370+X, A                                                  ; $0ad6 : $d5, $70, $03
    mov A, Y                                                  ; $0ad9 : $dd
    mov !$0371+X, A                                                  ; $0ada : $d5, $71, $03

Stub_0add:
    ret                                                  ; $0add : $6f


SetZpNoteAfterTransposeTuning:
    mov A, !wTrackNoteAfterTransposeTuning+1+X                                ; $0ade : $f5, $61, $03
    mov wZpNoteAfterTransposeTuning+1, A                                      ; $0ae1 : $c4, $11
    mov A, !wTrackNoteAfterTransposeTuning+X                                  ; $0ae3 : $f5, $60, $03
    mov wZpNoteAfterTransposeTuning, A                                        ; $0ae6 : $c4, $10
    ret                                                                       ; $0ae8 : $6f


; A - value2 - value1 (high bytes of a word value)
; X - split length
; Carry - set if value2 >= value 1
YAequRangeDivLength:
; If negative range, make it positive
    notc                                                                      ; $0ae9 : $ed
    ror wRangeSplitNegSign                                                    ; $0aea : $6b, $12
    bpl +                                                                     ; $0aec : $10, $03

    eor A, #$ff                                                               ; $0aee : $48, $ff
    inc A                                                                     ; $0af0 : $bc

; Do range / legth, A = div, Y = mod
+   mov Y, #$00                                                               ; $0af1 : $8d, $00
    div YA, X                                                                 ; $0af3 : $9e
    push A                                                                    ; $0af4 : $2d

; Do mod*$100 / length, A = div
    mov A, #$00                                                               ; $0af5 : $e8, $00
    div YA, X                                                                 ; $0af7 : $9e

; YA = range*$100 / length, restore track word idx
    pop Y                                                                     ; $0af8 : $ee
    mov X, wBackupTrackWordIdx                                                ; $0af9 : $f8, $44

; YA - range*$100 / length
YAequCorrectSignRangeSplit:
; If range was negative...
    bbc wRangeSplitNegSign.7, @done                                           ; $0afb : $f3, $12, $06

; Return 0-range
    movw wTempRangeSplitVal, YA                                               ; $0afe : $da, $14
    movw YA, wKnown0word                                                      ; $0b00 : $ba, $0e
    subw YA, wTempRangeSplitVal                                               ; $0b02 : $9a, $14

@done:
    ret                                                                       ; $0b04 : $6f


VCMDGteE0hHandlers:
    .dw VCMDE0h_SetInstrumentA
    .dw VCMDE1h_SetPanA
    .dw VCMDE2h_PanFade
    .dw VCMDE3h_VibratoOn
    .dw VCMDE4h_VibratoOff
    .dw VCMDE5h_SetMasterVolume
    .dw VCMDE6h_MasterVolumeFade
    .dw VCMDE7h_SetTempo
    .dw VCMDE8h_TempoFade
    .dw VCMDE9h_GlobalTranspose
    .dw VCMDEAh_PerVoiceTranspose
    .dw VCMDEBh_TremoloOn
    .dw VCMDECh_TremoloOff
    .dw VCMDEDh_TrackVolume
    .dw VCMDEEh_VolumeFade
    .dw VCMDEFh_CallSubroutine
    .dw VCMDF0h_VibratoFade
    .dw VCMDF1h_PitchEnvelopeTo
    .dw VCMDF2h_PitchEnvelopeFrom
    .dw VCMDF3h_PitchEnvelopeOff
    .dw VCMDF4h_Tuning
    .dw VCMDF5h_EchoVBitsVolume
    .dw VCMDF6h_EchoOff
    .dw VCMDF7h_EchoParameters
    .dw VCMDF8h_EchoVolumeFade
    .dw VCMDF9h_PitchSlide
    .dw VCMDFAh_PercussionPatchBase
    .dw $0000
    .dw $0000
    .dw $0000
    .dw $0000


VCMDGteE0hNumParams:
    .db $01 ; $e0
    .db $01
    .db $02
    .db $03
    .db $00
    .db $01
    .db $02
    .db $01
    .db $02
    .db $01
    .db $01
    .db $03
    .db $00
    .db $01
    .db $02
    .db $03
    .db $01 ; $f0
    .db $03
    .db $03
    .db $00
    .db $01
    .db $03
    .db $00
    .db $03
    .db $03
    .db $03
    .db $01 ; $fa
    .db $02
    .db $00
    .db $00
    .db $00


Call_00_0b62:
    mov A, wTrackVolLen+X                                                  ; $0b62 : $f4, $90
    beq @afterVolFade                                                  ; $0b64 : $f0, $24

    or $5e, wCurrTrackIdxBitfield                                                  ; $0b66 : $09, $47, $5e
    dec wTrackVolLen+X                                                  ; $0b69 : $9b, $90
    bne @addFadeIncrToVol                                                  ; $0b6b : $d0, $0a

    mov A, #$00                                                  ; $0b6d : $e8, $00
    mov !wTrackVolume+X, A                                                  ; $0b6f : $d5, $00, $03
    mov A, !wTrackVolDest+X                                                  ; $0b72 : $f5, $20, $03
    bra @setVolHigh                                                  ; $0b75 : $2f, $10

@addFadeIncrToVol:
    clrc                                                  ; $0b77 : $60
    mov A, !wTrackVolume+X                                                  ; $0b78 : $f5, $00, $03
    adc A, !wTrackVolIncrPer1Length+X                                                  ; $0b7b : $95, $10, $03
    mov !wTrackVolume+X, A                                                  ; $0b7e : $d5, $00, $03
    mov A, !wTrackVolume+1+X                                                  ; $0b81 : $f5, $01, $03
    adc A, !wTrackVolIncrPer1Length+1+X                                                  ; $0b84 : $95, $11, $03

@setVolHigh:
    mov !wTrackVolume+1+X, A                                                  ; $0b87 : $d5, $01, $03

@afterVolFade:
    mov Y, wTrackTremoloDepth+X                                                  ; $0b8a : $fb, $c1
    beq @br_0bb1                                                  ; $0b8c : $f0, $23

    mov A, !wTrackTremoloDelay+X                                                  ; $0b8e : $f5, $e0, $02
    cbne wc0+X, @br_0baf                                                  ; $0b91 : $de, $c0, $1b

    or $5e, wCurrTrackIdxBitfield                                                  ; $0b94 : $09, $47, $5e
    mov A, !w2d0+X                                                  ; $0b97 : $f5, $d0, $02
    bpl @br_0ba3                                                  ; $0b9a : $10, $07

    inc Y                                                  ; $0b9c : $fc
    bne @br_0ba3                                                  ; $0b9d : $d0, $04

    mov A, #$80                                                  ; $0b9f : $e8, $80
    bra +                                                  ; $0ba1 : $2f, $04

@br_0ba3:
    clrc                                                  ; $0ba3 : $60
    adc A, !wTrackTremoloRate+X                                                  ; $0ba4 : $95, $d1, $02

+   mov !w2d0+X, A                                                  ; $0ba7 : $d5, $d0, $02
    call !Call_00_0da3                                                  ; $0baa : $3f, $a3, $0d
    bra @cont_0bb6                                                  ; $0bad : $2f, $07

@br_0baf:
    inc wc0+X                                                  ; $0baf : $bb, $c0

@br_0bb1:
    mov A, #$ff                                                  ; $0bb1 : $e8, $ff
    call !ApplyTremoloToVolsAndVelocity                                                  ; $0bb3 : $3f, $ae, $0d

@cont_0bb6:
    mov A, wTrackPanLength+X                                                  ; $0bb6 : $f4, $91
    beq @applyPanAndVol                                                  ; $0bb8 : $f0, $24

    or $5e, wCurrTrackIdxBitfield                                                  ; $0bba : $09, $47, $5e
    dec wTrackPanLength+X                                                  ; $0bbd : $9b, $91
    bne @br_0bcb                                                  ; $0bbf : $d0, $0a

    mov A, #$00                                                  ; $0bc1 : $e8, $00
    mov !wTrackPanValue+X, A                                                  ; $0bc3 : $d5, $30, $03
    mov A, !wTrackPanDest+X                                                  ; $0bc6 : $f5, $50, $03
    bra @cont_0bdb                                                  ; $0bc9 : $2f, $10

@br_0bcb:
    clrc                                                  ; $0bcb : $60
    mov A, !wTrackPanValue+X                                                  ; $0bcc : $f5, $30, $03
    adc A, !wTrackPanIncrPer1Length+X                                                  ; $0bcf : $95, $40, $03
    mov !wTrackPanValue+X, A                                                  ; $0bd2 : $d5, $30, $03
    mov A, !wTrackPanValue+1+X                                                  ; $0bd5 : $f5, $31, $03
    adc A, !wTrackPanIncrPer1Length+1+X                                                  ; $0bd8 : $95, $41, $03

@cont_0bdb:
    mov !wTrackPanValue+1+X, A                                                  ; $0bdb : $d5, $31, $03

@applyPanAndVol:
    mov A, wCurrTrackIdxBitfield                                                  ; $0bde : $e4, $47
    and A, $5e                                                  ; $0be0 : $24, $5e
    beq Stub_0c2a                                                  ; $0be2 : $f0, $46

    mov A, !wTrackPanValue+1+X                                                  ; $0be4 : $f5, $31, $03
    mov Y, A                                                  ; $0be7 : $fd
    mov A, !wTrackPanValue+X                                                  ; $0be8 : $f5, $30, $03
    movw wCurrTracksPanVal, YA                                                  ; $0beb : $da, $10

; X - track word idx
; wCurrTracksPanVal
ApplyPanAndSetVolRegs:
; Save offset of track's VOL_L
    mov A, X                                                  ; $0bed : $7d
    xcn A                                                  ; $0bee : $9f
    lsr A                                                  ; $0bef : $5c
    mov wTempVolLorR, A                                                  ; $0bf0 : $c4, $12

@nextVol:
; Get range between curr pan level to next
    mov Y, wCurrTracksPanVal+1                                                  ; $0bf2 : $eb, $11
    mov A, !VolPanLevels+1+Y                                                  ; $0bf4 : $f6, $c1, $0d
    setc                                                  ; $0bf7 : $80
    sbc A, !VolPanLevels+Y                                                  ; $0bf8 : $b6, $c0, $0d

; a = fine pan val * above range
    mov Y, wCurrTracksPanVal                                                  ; $0bfb : $eb, $10
    mul YA                                                  ; $0bfd : $cf
    mov A, Y                                                  ; $0bfe : $dd

; y = above added onto curr pan level
    mov Y, wCurrTracksPanVal+1                                                  ; $0bff : $eb, $11
    clrc                                                  ; $0c01 : $60
    adc A, !VolPanLevels+Y                                                  ; $0c02 : $96, $c0, $0d
    mov Y, A                                                  ; $0c05 : $fd

; y =
    mov A, !w321+X                                                  ; $0c06 : $f5, $21, $03
    mul YA                                                  ; $0c09 : $cf

;
    mov A, !wTrackPanFullVal+X                                                  ; $0c0a : $f5, $51, $03
    asl A                                                  ; $0c0d : $1c

; for vol R, double again
    bbc wTempVolLorR.0, +                                                  ; $0c0e : $13, $12, $01
    asl A                                                  ; $0c11 : $1c

;
+   mov A, Y                                                  ; $0c12 : $dd
    bcc +                                                  ; $0c13 : $90, $03

    eor A, #$ff                                                  ; $0c15 : $48, $ff
    inc A                                                  ; $0c17 : $bc

+   mov Y, wTempVolLorR                                                  ; $0c18 : $eb, $12
    call !SetDspAddrDataIfNoSndEffectToYA                                                  ; $0c1a : $3f, $15, $06

; Choose the mirrored entry in the pan level table for VOL_R
    mov Y, #NUM_VOL_PAN_LEVELS                                                  ; $0c1d : $8d, $14
    mov A, #$00                                                  ; $0c1f : $e8, $00
    subw YA, wCurrTracksPanVal                                                  ; $0c21 : $9a, $10
    movw wCurrTracksPanVal, YA                                                  ; $0c23 : $da, $10

; Go from VOL_L (0) to VOL_R (1), or return if VOL_R
    inc wTempVolLorR                                                  ; $0c25 : $ab, $12
    bbc wTempVolLorR.1, @nextVol                                                  ; $0c27 : $33, $12, $c8

Stub_0c2a:
    ret                                                  ; $0c2a : $6f


; X - track word idx
tickTrackUpdate:
    mov A, wFramesTilNextTrackByte+X                                                  ; $0c2b : $f4, $71
    beq @br_0c94                                                  ; $0c2d : $f0, $65

    dec wFramesTilNextTrackByte+X                                                  ; $0c2f : $9b, $71
    beq @br_0c38                                                  ; $0c31 : $f0, $05

    mov A, #$02                                                  ; $0c33 : $e8, $02
    cbne wCtrlTilNextTrackByte+X, @br_0c94                                                  ; $0c35 : $de, $70, $5c

@br_0c38:
    mov A, wBlockLoopCtr+X                                                  ; $0c38 : $f4, $80
    mov $17, A                                                  ; $0c3a : $c4, $17
    mov A, wCurrPhraseTracksAddrs+X                                                  ; $0c3c : $f4, $30
    mov Y, wCurrPhraseTracksAddrs+1+X                                                  ; $0c3e : $fb, $31

@loop_0c40:
    movw wTrackAddr, YA                                                  ; $0c40 : $da, $14
    mov Y, #$00                                                  ; $0c42 : $8d, $00

@loop_0c44:
    mov A, [wTrackAddr]+Y                                                  ; $0c44 : $f7, $14
    beq @br_0c66                                                  ; $0c46 : $f0, $1e

    bmi @br_0c51                                                  ; $0c48 : $30, $07

@loop_0c4a:
    inc Y                                                  ; $0c4a : $fc
    bmi @br_0c8d                                                  ; $0c4b : $30, $40

    mov A, [wTrackAddr]+Y                                                  ; $0c4d : $f7, $14
    bpl @loop_0c4a                                                  ; $0c4f : $10, $f9

@br_0c51:
    cmp A, #$c8                                                  ; $0c51 : $68, $c8
    beq @br_0c94                                                  ; $0c53 : $f0, $3f

    cmp A, #$ef                                                  ; $0c55 : $68, $ef
    beq @br_0c82                                                  ; $0c57 : $f0, $29

    cmp A, #$e0                                                  ; $0c59 : $68, $e0
    bcc @br_0c8d                                                  ; $0c5b : $90, $30

    push Y                                                  ; $0c5d : $6d
    mov Y, A                                                  ; $0c5e : $fd
    pop A                                                  ; $0c5f : $ae
    adc A, !VCMDGteE0hNumParams-$e0+Y                                                  ; $0c60 : $96, $63, $0a
    mov Y, A                                                  ; $0c63 : $fd
    bra @loop_0c44                                                  ; $0c64 : $2f, $de

@br_0c66:
    mov A, $17                                                  ; $0c66 : $e4, $17
    beq @br_0c8d                                                  ; $0c68 : $f0, $23

    dec $17                                                  ; $0c6a : $8b, $17
    bne @br_0c78                                                  ; $0c6c : $d0, $0a

    mov A, !wTrackRetAddr+1+X                                                  ; $0c6e : $f5, $31, $02
    push A                                                  ; $0c71 : $2d
    mov A, !wTrackRetAddr+X                                                  ; $0c72 : $f5, $30, $02
    pop Y                                                  ; $0c75 : $ee
    bra @loop_0c40                                                  ; $0c76 : $2f, $c8

@br_0c78:
    mov A, !wTrackSubroutineAddr+1+X                                                  ; $0c78 : $f5, $41, $02
    push A                                                  ; $0c7b : $2d
    mov A, !wTrackSubroutineAddr+X                                                  ; $0c7c : $f5, $40, $02
    pop Y                                                  ; $0c7f : $ee
    bra @loop_0c40                                                  ; $0c80 : $2f, $be

@br_0c82:
    inc Y                                                  ; $0c82 : $fc
    mov A, [wTrackAddr]+Y                                                  ; $0c83 : $f7, $14
    push A                                                  ; $0c85 : $2d
    inc Y                                                  ; $0c86 : $fc
    mov A, [wTrackAddr]+Y                                                  ; $0c87 : $f7, $14
    mov Y, A                                                  ; $0c89 : $fd
    pop A                                                  ; $0c8a : $ae
    bra @loop_0c40                                                  ; $0c8b : $2f, $b3

@br_0c8d:
    mov A, wCurrTrackIdxBitfield                                                  ; $0c8d : $e4, $47
    mov Y, #$5c                                                  ; $0c8f : $8d, $5c
    call !SetDspAddrDataIfNoSndEffectToYA                                                  ; $0c91 : $3f, $15, $06

@br_0c94:
    clr1 $13.7                                                  ; $0c94 : $f2, $13
    mov A, wPitchSlideLength+X                                                  ; $0c96 : $f4, $a0
    beq @cont_0cc6                                                  ; $0c98 : $f0, $2c

    mov A, wPitchSlideDelay+X                                                  ; $0c9a : $f4, $a1
    beq @br_0ca2                                                  ; $0c9c : $f0, $04

    dec wPitchSlideDelay+X                                                  ; $0c9e : $9b, $a1
    bra @cont_0cc6                                                  ; $0ca0 : $2f, $24

@br_0ca2:
    set1 $13.7                                                  ; $0ca2 : $e2, $13
    dec wPitchSlideLength+X                                                  ; $0ca4 : $9b, $a0
    bne @br_0cb3                                                  ; $0ca6 : $d0, $0b

    mov A, !wTrackTuning+X                                                  ; $0ca8 : $f5, $81, $03
    mov !wTrackNoteAfterTransposeTuning+X, A                                                  ; $0cab : $d5, $60, $03
    mov A, !$0380+X                                                  ; $0cae : $f5, $80, $03
    bra @cont_0cc3                                                  ; $0cb1 : $2f, $10

@br_0cb3:
    clrc                                                  ; $0cb3 : $60
    mov A, !wTrackNoteAfterTransposeTuning+X                                                  ; $0cb4 : $f5, $60, $03
    adc A, !$0370+X                                                  ; $0cb7 : $95, $70, $03
    mov !wTrackNoteAfterTransposeTuning+X, A                                                  ; $0cba : $d5, $60, $03
    mov A, !wTrackNoteAfterTransposeTuning+1+X                                                  ; $0cbd : $f5, $61, $03
    adc A, !$0371+X                                                  ; $0cc0 : $95, $71, $03

@cont_0cc3:
    mov !wTrackNoteAfterTransposeTuning+1+X, A                                                  ; $0cc3 : $d5, $61, $03

@cont_0cc6:
    call !SetZpNoteAfterTransposeTuning                                                  ; $0cc6 : $3f, $de, $0a
    mov A, wTrackCurrVibratoVal+X                                                  ; $0cc9 : $f4, $b1
    beq @brLoop_0d19                                                  ; $0ccb : $f0, $4c

    mov A, !wTrackVibratoDelay+X                                                  ; $0ccd : $f5, $b0, $02
    cbne $b0+X, @br_0d17                                                  ; $0cd0 : $de, $b0, $44

    mov A, !$0100+X                                                  ; $0cd3 : $f5, $00, $01
    cmp A, !wTrackVibratoFadeLen+X                                                  ; $0cd6 : $75, $b1, $02
    bne @br_0ce0                                                  ; $0cd9 : $d0, $05

    mov A, !wTrackVibratoDepth+X                                                  ; $0cdb : $f5, $c1, $02
    bra @cont_0ced                                                  ; $0cde : $2f, $0d

@br_0ce0:
    setp                                                  ; $0ce0 : $40
    inc <w100+X                                                  ; $0ce1 : $bb, $00
    clrp                                                  ; $0ce3 : $20
    mov Y, A                                                  ; $0ce4 : $fd
    beq +                                                  ; $0ce5 : $f0, $02
    mov A, wTrackCurrVibratoVal+X                                                  ; $0ce7 : $f4, $b1
+   clrc                                                  ; $0ce9 : $60
    adc A, !wTrackVibratoIcrPer1Length+X                                                  ; $0cea : $95, $c0, $02

@cont_0ced:
    mov wTrackCurrVibratoVal+X,A                                                  ; $0ced : $d4, $b1
    mov A, !w2a0+X                                                  ; $0cef : $f5, $a0, $02
    clrc                                                  ; $0cf2 : $60
    adc A, !wTrackVibratoRate+X                                                  ; $0cf3 : $95, $a1, $02
    mov !w2a0+X, A                                                  ; $0cf6 : $d5, $a0, $02

@bigLoop_0cf9:
    mov wRangeSplitNegSign, A                                                  ; $0cf9 : $c4, $12
    asl A                                                  ; $0cfb : $1c
    asl A                                                  ; $0cfc : $1c
    bcc +                                                  ; $0cfd : $90, $02
    eor A, #$ff                                                  ; $0cff : $48, $ff
+   mov Y, A                                                  ; $0d01 : $fd
    mov A, wTrackCurrVibratoVal+X                                                  ; $0d02 : $f4, $b1
    cmp A, #$f1                                                  ; $0d04 : $68, $f1
    bcc @br_0d0d                                                  ; $0d06 : $90, $05

    and A, #$0f                                                  ; $0d08 : $28, $0f
    mul YA                                                  ; $0d0a : $cf
    bra @cont_0d11                                                  ; $0d0b : $2f, $04

@br_0d0d:
    mul YA                                                  ; $0d0d : $cf
    mov A, Y                                                  ; $0d0e : $dd
    mov Y, #$00                                                  ; $0d0f : $8d, $00

@cont_0d11:
    call !Call_00_0d8e                                                  ; $0d11 : $3f, $8e, $0d

@loop_0d14:
    jmp !HandleVCMDBetween80hAndDFh@func_0592                                                  ; $0d14 : $5f, $92, $05

@br_0d17:
    inc $b0+X                                                  ; $0d17 : $bb, $b0

@brLoop_0d19:
    bbs $13.7, @loop_0d14                                                  ; $0d19 : $e3, $13, $f8

    ret                                                  ; $0d1c : $6f

@func_0d1d:
    clr1 $13.7                                                  ; $0d1d : $f2, $13
    mov A, wTrackTremoloDepth+X                                                  ; $0d1f : $f4, $c1
    beq @cont_0d2c                                                  ; $0d21 : $f0, $09

    mov A, !wTrackTremoloDelay+X                                                  ; $0d23 : $f5, $e0, $02
    cbne wc0+X, @cont_0d2c                                                  ; $0d26 : $de, $c0, $03

    call !Call_00_0d96                                                  ; $0d29 : $3f, $96, $0d

@cont_0d2c:
    mov A, !wTrackPanValue+1+X                                                  ; $0d2c : $f5, $31, $03
    mov Y, A                                                  ; $0d2f : $fd
    mov A, !wTrackPanValue+X                                                  ; $0d30 : $f5, $30, $03
    movw wCurrTracksPanVal, YA                                                  ; $0d33 : $da, $10
    mov A, wTrackPanLength+X                                                  ; $0d35 : $f4, $91
    beq @cont_0d43                                                  ; $0d37 : $f0, $0a

    mov A, !wTrackPanIncrPer1Length+1+X                                                  ; $0d39 : $f5, $41, $03
    mov Y, A                                                  ; $0d3c : $fd
    mov A, !wTrackPanIncrPer1Length+X                                                  ; $0d3d : $f5, $40, $03
    call !Call_00_0d78                                                  ; $0d40 : $3f, $78, $0d

@cont_0d43:
    bbc $13.7, +                                                  ; $0d43 : $f3, $13, $03
    call !ApplyPanAndSetVolRegs                                                  ; $0d46 : $3f, $ed, $0b
+   clr1 $13.7                                                  ; $0d49 : $f2, $13
    call !SetZpNoteAfterTransposeTuning                                                  ; $0d4b : $3f, $de, $0a
    mov A, wPitchSlideLength+X                                                  ; $0d4e : $f4, $a0
    beq @cont_0d60                                                  ; $0d50 : $f0, $0e

    mov A, wPitchSlideDelay+X                                                  ; $0d52 : $f4, $a1
    bne @cont_0d60                                                  ; $0d54 : $d0, $0a

    mov A, !$0371+X                                                  ; $0d56 : $f5, $71, $03
    mov Y, A                                                  ; $0d59 : $fd
    mov A, !$0370+X                                                  ; $0d5a : $f5, $70, $03
    call !Call_00_0d78                                                  ; $0d5d : $3f, $78, $0d

@cont_0d60:
    mov A, wTrackCurrVibratoVal+X                                                  ; $0d60 : $f4, $b1
    beq @brLoop_0d19                                                  ; $0d62 : $f0, $b5

    mov A, !wTrackVibratoDelay+X                                                  ; $0d64 : $f5, $b0, $02
    cbne $b0+X, @brLoop_0d19                                                  ; $0d67 : $de, $b0, $af

    mov Y, $51                                                  ; $0d6a : $eb, $51
    mov A, !wTrackVibratoRate+X                                                  ; $0d6c : $f5, $a1, $02
    mul YA                                                  ; $0d6f : $cf
    mov A, Y                                                  ; $0d70 : $dd
    clrc                                                  ; $0d71 : $60
    adc A, !w2a0+X                                                  ; $0d72 : $95, $a0, $02
    jmp !@bigLoop_0cf9                                                  ; $0d75 : $5f, $f9, $0c


Call_00_0d78:
    set1 $13.7                                                  ; $0d78 : $e2, $13
    mov wRangeSplitNegSign, Y                                                  ; $0d7a : $cb, $12
    call !YAequCorrectSignRangeSplit                                                  ; $0d7c : $3f, $fb, $0a
    push Y                                                  ; $0d7f : $6d
    mov Y, $51                                                  ; $0d80 : $eb, $51
    mul YA                                                  ; $0d82 : $cf
    mov $14, Y                                                  ; $0d83 : $cb, $14
    mov $15, #$00                                                  ; $0d85 : $8f, $00, $15
    mov Y, $51                                                  ; $0d88 : $eb, $51
    pop A                                                  ; $0d8a : $ae
    mul YA                                                  ; $0d8b : $cf
    addw YA, $14                                                  ; $0d8c : $7a, $14

Call_00_0d8e:
    call !YAequCorrectSignRangeSplit                                                  ; $0d8e : $3f, $fb, $0a
    addw YA, $10                                                  ; $0d91 : $7a, $10
    movw $10, YA                                                  ; $0d93 : $da, $10
    ret                                                  ; $0d95 : $6f


Call_00_0d96:
    set1 $13.7                                                  ; $0d96 : $e2, $13
    mov Y, $51                                                  ; $0d98 : $eb, $51
    mov A, !wTrackTremoloRate+X                                                  ; $0d9a : $f5, $d1, $02
    mul YA                                                  ; $0d9d : $cf
    mov A, Y                                                  ; $0d9e : $dd
    clrc                                                  ; $0d9f : $60
    adc A, !w2d0+X                                                  ; $0da0 : $95, $d0, $02

; A -
Call_00_0da3:
    asl A                                                  ; $0da3 : $1c
    bcc +                                                  ; $0da4 : $90, $02
    eor A, #$ff                                                  ; $0da6 : $48, $ff
+   mov Y, wTrackTremoloDepth+X                                                  ; $0da8 : $fb, $c1
    mul YA                                                  ; $0daa : $cf
    mov A, Y                                                  ; $0dab : $dd
    eor A, #$ff                                                  ; $0dac : $48, $ff

; A - tremolo val
ApplyTremoloToVolsAndVelocity:
; Y = tremolo val * master vol * track velocity * track vol
    mov Y, wMasterVolume+1                                                  ; $0dae : $eb, $59
    mul YA                                                  ; $0db0 : $cf
    mov A, !wTrackVelocityOfNote+X                                                  ; $0db1 : $f5, $10, $02
    mul YA                                                  ; $0db4 : $cf
    mov A, !wTrackVolume+1+X                                                  ; $0db5 : $f5, $01, $03
    mul YA                                                  ; $0db8 : $cf

; Square Y and store it
    mov A, Y                                                  ; $0db9 : $dd
    mul YA                                                  ; $0dba : $cf
    mov A, Y                                                  ; $0dbb : $dd
    mov !w321+X, A                                                  ; $0dbc : $d5, $21, $03
    ret                                                  ; $0dbf : $6f


VolPanLevels:
	.db $00, $01, $03, $07, $0d, $15, $1e, $29
	.db $34, $42, $51, $5e, $67, $6e, $73, $77
	.db $7a, $7c, $7d, $7e, $7f


FilterCoefficients:
    .db $7f, $00, $00, $00, $00, $00, $00, $00
    .db $58, $bf, $db, $f0, $fe, $07, $0c, $0c
    .db $0c, $21, $2b, $2b, $13, $fe, $f3, $f9
    .db $34, $33, $00, $d9, $e5, $01, $fc, $eb
    
    
EchoDSPregs:
    .db EVOL_L
    .db EVOL_R
    .db EFB
    .db EON


;
    ror !$5c4c                                                  ; $0df9 : $6c, $4c, $5c
    inc X                                                  ; $0dfc : $3d
    push A                                                  ; $0dfd : $2d
    lsr A                                                  ; $0dfe : $5c
    tcall 6                                                  ; $0dff : $61
    bbs $4e.3, $4a                                                  ; $0e00 : $63, $4e, $4a

    eor A, #$45                                                  ; $0e03 : $48, $45
    tset1 !$4b49                                                  ; $0e05 : $0e, $49, $4b
    eor A, (X)                                                  ; $0e08 : $46


Octave0NotePitches:
	.dw $085f
	.dw $08de
	.dw $0965
	.dw $09f4
	.dw $0a8c
	.dw $0b2c
	.dw $0bd6
	.dw $0c8b
	.dw $0d4a
	.dw $0e14
	.dw $0eea
	.dw $0fcd
	.dw $10be


;
    .db $2a, $56                                                  ; $0e23 : $2a, $56
    .db $65, $72                                                  ; $0e25 : $65, $72
    clrp                                                  ; $0e27 : $20
    bbc $31.2, $2e                                                  ; $0e28 : $53, $31, $2e

    clr1 $30.1                                                  ; $0e2b : $32, $30
    .db $2a


MimicIPL:
; Send $bbaa back to SNES so it knows we want to process data
    mov A, #$aa                                                               ; $0e2e : $e8, $aa
    mov !PORT_0, A                                                            ; $0e30 : $c5, $f4, $00
    mov A, #$bb                                                               ; $0e33 : $e8, $bb
    mov !PORT_1, A                                                            ; $0e35 : $c5, $f5, $00

; Wait until SNES sends back $cc
-   mov A, !PORT_0                                                            ; $0e38 : $e5, $f4, $00
    cmp A, #$cc                                                               ; $0e3b : $68, $cc
    bne -                                                                     ; $0e3d : $d0, $f9

    bra @getDestAndTransfer                                                   ; $0e3f : $2f, $20

@startTransfer:
; Wait until SNES sends a 0 (idx of transferred byte)
-   mov Y, !PORT_0                                                            ; $0e41 : $ec, $f4, $00
    bne -                                                                     ; $0e44 : $d0, $fb

@nextDataByte:
; Wait until SNES sends back a new byte idx to load
    cmp Y, !PORT_0                                                            ; $0e46 : $5e, $f4, $00
    bne @snesNotReady                                                         ; $0e49 : $d0, $0f

; Get byte to transfer from port 1, and store in dest
; Send to SNES the data byte we're using
    mov A, !PORT_1                                                            ; $0e4b : $e5, $f5, $00
    mov !PORT_0, Y                                                            ; $0e4e : $cc, $f4, $00
    mov [wIPLMimicDataDest]+Y, A                                              ; $0e51 : $d7, $14

; Inc dest address
    inc Y                                                                     ; $0e53 : $fc
    bne @nextDataByte                                                         ; $0e54 : $d0, $f0

    inc wIPLMimicDataDest+1                                                   ; $0e56 : $ab, $15
    bra @nextDataByte                                                         ; $0e58 : $2f, $ec

@snesNotReady:
;
    bpl @nextDataByte                                                  ; $0e5a : $10, $ea

    cmp Y, !PORT_0                                                  ; $0e5c : $5e, $f4, $00
    bpl @nextDataByte                                                  ; $0e5f : $10, $e5

@getDestAndTransfer:
; Save dest addr
    mov A, !PORT_2                                                            ; $0e61 : $e5, $f6, $00
    mov Y, !PORT_3                                                            ; $0e64 : $ec, $f7, $00
    movw wIPLMimicDataDest, YA                                                ; $0e67 : $da, $14

; Get command from port 1 (1 = start transfer), and send back 
; $cc as an acknowledgement to SNES
    mov Y, !PORT_0                                                            ; $0e69 : $ec, $f4, $00
    mov A, !PORT_1                                                            ; $0e6c : $e5, $f5, $00
    mov !PORT_0, Y                                                            ; $0e6f : $cc, $f4, $00
    bne @startTransfer                                                        ; $0e72 : $d0, $cd

; Reset port inputs to 0 and timer 0
; todo: what is timer 0 for?
    mov X, #_CTRL_PC32|_CTRL_PC10|_CTRL_TIMER_0                                                  ; $0e74 : $cd, $31
    mov !CTRL_REG, X                                                  ; $0e76 : $c9, $f1, $00
    ret                                                  ; $0e79 : $6f


; For the tables in "data/soundEffects.s"
SoundEffectsTableOffs:
; id $01
.rept 28 index i
    .db 1+i*9
.endr
; id $1d
.rept 28 index i
    .db 1+i*9
.endr


data_0eb2:
    eor A, $2a+X                                                  ; $0eb2 : $54, $2a
    cmp Y, $54                                                  ; $0eb4 : $7e, $54
    rol !$4414                                                  ; $0eb6 : $2c, $14, $44
    rol !$0810                                                  ; $0eb9 : $2c, $10, $08
    or $54, #$10                                                  ; $0ebc : $18, $10, $54
    or1 c, /$147e.2                                                  ; $0ebf : $2a, $7e, $54


data_0ec2:
    eor A, $7e+X                                                  ; $0ec2 : $54, $7e
    or1 c, /$0c54.1                                                  ; $0ec4 : $2a, $54, $2c
    eor A, $14                                                  ; $0ec7 : $44, $14
    rol !$1810                                                  ; $0ec9 : $2c, $10, $18
    or A, #$10                                                  ; $0ecc : $08, $10
    eor A, $7e+X                                                  ; $0ece : $54, $7e
    .db $2a, $54


TrackToDspRegBaseAndBitfield:
; byte 0 - track to its DSP regs
; byte 1 - bitfield for the track
    .db $00, $01
    .db $10, $02
    .db $20, $04
    .db $30, $08
    .db $40, $10
    .db $50, $20
    .db $60, $40
    .db $70, $80
    .db $70, $80


data_0ee4:
    .db $58, $28, $10, $58 ; last unused?


data_0ee8:
    .db $00, $08, $10, $18


data_0eec:
    .db $00, $04, $08, $0c


ProcessSndEffectAttrs:
; Bit 2-3 - Sound Effect A Volume (0..2=High..Low, 3=Mute on)
; Branch based on if mute chosen
    mov A, wSndEffectAttrs                                                    ; $0ef0 : $e4, $03
    and A, #$0c                                                               ; $0ef2 : $28, $0c
    cmp A, #$0c                                                               ; $0ef4 : $68, $0c
    beq sndEffectAttrsMuteOn                                                  ; $0ef6 : $f0, $52

    bne sndEffectAttrsNoMute                                                  ; $0ef8 : $d0, $25


SaveSndEffectAttrSettings:
; Bit 0-1 - Sound Effect A Pitch  (0..3=Low..High)
    mov A, wSndEffectAttrs                                                    ; $0efa : $e4, $03
    and A, #$03                                                               ; $0efc : $28, $03
    mov wSndEffectAttrApitch, A                                               ; $0efe : $c4, $2c

; Bit 2-3 - Sound Effect A Volume (0..2=High..Low, 3=Mute on)
    mov A, wSndEffectAttrs                                                    ; $0f00 : $e4, $03
    and A, #$0c                                                               ; $0f02 : $28, $0c
    lsr A                                                                     ; $0f04 : $5c
    lsr A                                                                     ; $0f05 : $5c
    mov wSndEffectAttrAvol, A                                                 ; $0f06 : $c4, $2d

; Bit 4-5 - Sound Effect B Pitch  (0..3=Low..High)
    mov A, wSndEffectAttrs                                                    ; $0f08 : $e4, $03
    and A, #$30                                                               ; $0f0a : $28, $30
    lsr A                                                                     ; $0f0c : $5c
    lsr A                                                                     ; $0f0d : $5c
    lsr A                                                                     ; $0f0e : $5c
    lsr A                                                                     ; $0f0f : $5c
    mov wSndEffectAttrBpitch, A                                               ; $0f10 : $c4, $2e

; Bit 6-7 - Sound Effect B Volume (0..2=High..Low, 3=Not used)
    mov A, wSndEffectAttrs                                                    ; $0f12 : $e4, $03
    and A, #$c0                                                               ; $0f14 : $28, $c0
    lsr A                                                                     ; $0f16 : $5c
    lsr A                                                                     ; $0f17 : $5c
    lsr A                                                                     ; $0f18 : $5c
    lsr A                                                                     ; $0f19 : $5c
    lsr A                                                                     ; $0f1a : $5c
    lsr A                                                                     ; $0f1b : $5c
    mov wSndEffectAttrBvol, A                                                 ; $0f1c : $c4, $2f
    ret                                                                       ; $0f1e : $6f


sndEffectAttrsNoMute:
; Fade main vol up, jumping if already hit $60
    mov A, wSndEffectMVols                                                    ; $0f1f : $e4, $d8
    cmp A, #$60                                                               ; $0f21 : $68, $60
    bcs @fullyFadedMvol                                                       ; $0f23 : $b0, $10

    inc wSndEffectMVols                                                       ; $0f25 : $ab, $d8

; Update main vols
    mov A, wSndEffectMVols                                                    ; $0f27 : $e4, $d8
    mov Y, #MVOL_L                                                            ; $0f29 : $8d, $0c
    call !SetDspAddrDataToYA                                                  ; $0f2b : $3f, $1d, $06
    mov Y, #MVOL_R                                                            ; $0f2e : $8d, $1c
    call !SetDspAddrDataToYA                                                  ; $0f30 : $3f, $1d, $06
    bra @saveAttrSettings                                                     ; $0f33 : $2f, $12

@fullyFadedMvol:
;
    mov A, wd4                                                  ; $0f35 : $e4, $d4
    bne @br_0f3d                                                  ; $0f37 : $d0, $04

    mov A, wd7                                                  ; $0f39 : $e4, $d7
    beq @saveAttrSettings                                                  ; $0f3b : $f0, $0a

@br_0f3d:
    mov A, wEchoVolL+1                                                  ; $0f3d : $e4, $61
    clrc                                                  ; $0f3f : $60
    adc A, wEchoVolR+1                                                  ; $0f40 : $84, $63
    bne @saveAttrSettings                                                  ; $0f42 : $d0, $03

    call !Call_00_1cb6                                                  ; $0f44 : $3f, $b6, $1c

@saveAttrSettings:
    jmp !SaveSndEffectAttrSettings                                                  ; $0f47 : $5f, $fa, $0e


sndEffectAttrsMuteOn:
; If either echo vols are non-0, clear both
    mov A, wEchoVolL+1                                                        ; $0f4a : $e4, $61
    clrc                                                                      ; $0f4c : $60
    adc A, wEchoVolR+1                                                        ; $0f4d : $84, $63
    beq +                                                                     ; $0f4f : $f0, $03
    call !ClearShadowEchoVols                                                 ; $0f51 : $3f, $9a, $1b

; Fade main vol down, jumping if already hit $00
+   mov A, wSndEffectMVols                                                    ; $0f54 : $e4, $d8
    beq @saveAttrSettings                                                     ; $0f56 : $f0, $0e

    dec wSndEffectMVols                                                       ; $0f58 : $8b, $d8

; Update main vols
    mov A, wSndEffectMVols                                                    ; $0f5a : $e4, $d8
    mov Y, #MVOL_L                                                            ; $0f5c : $8d, $0c
    call !SetDspAddrDataToYA                                                  ; $0f5e : $3f, $1d, $06
    mov Y, #MVOL_R                                                            ; $0f61 : $8d, $1c
    call !SetDspAddrDataToYA                                                  ; $0f63 : $3f, $1d, $06

@saveAttrSettings:
    jmp !SaveSndEffectAttrSettings                                            ; $0f66 : $5f, $fa, $0e


ProcessSndEffectAdecrescendo:
@loop_0f69:
    mov A, #$00                                                  ; $0f69 : $e8, $00
    mov !$03da, A                                                  ; $0f6b : $c5, $da, $03
    mov A, #$05                                                  ; $0f6e : $e8, $05
    mov !$025f, A                                                  ; $0f70 : $c5, $5f, $02
    mov A, #$05                                                  ; $0f73 : $e8, $05
    mov !$025e, A                                                  ; $0f75 : $c5, $5e, $02
    jmp !@tryStartingTrack7or6                                                  ; $0f78 : $5f, $7c, $10

; unused?
    mov A, #$05                                                  ; $0f7b : $e8, $05
    mov !$025f, A                                                  ; $0f7d : $c5, $5f, $02
    jmp !@tryStartingTrack7or6                                                  ; $0f80 : $5f, $7c, $10

@start:
    mov A, wSPCDisabled                                                  ; $0f83 : $e4, $dd
    beq @br_0f8e                                                  ; $0f85 : $f0, $07

; if $80 - stop/silent
    mov A, wSndEffectAdecrescendo                                                  ; $0f87 : $e4, $01
    cmp A, #$80                                                  ; $0f89 : $68, $80
    beq @loop_0f69                                                  ; $0f8b : $f0, $dc

    ret                                                  ; $0f8d : $6f

@br_0f8e:
; valid sound effects are $00-$30
    mov A, wSndEffectAdecrescendo                                                  ; $0f8e : $e4, $01
    cmp A, #$31                                                  ; $0f90 : $68, $31
    bcc +                                                  ; $0f92 : $90, $04

    mov A, #$80                                                  ; $0f94 : $e8, $80
    mov wSndEffectAdecrescendo, A                                                  ; $0f96 : $c4, $01

; retrigger if sound effect to play is unchanged
+   mov Y, wSndEffectAtoPlay                                                  ; $0f98 : $eb, $09
    mov A, wSndEffectAdecrescendo                                                  ; $0f9a : $e4, $01
    mov wSndEffectAtoPlay, A                                                  ; $0f9c : $c4, $09
    cmp Y, wSndEffectAdecrescendo                                                  ; $0f9e : $7e, $01
    beq @br_0fdd                                                  ; $0fa0 : $f0, $3b

; 0 = dummy flag, re-trigger
    mov A, wSndEffectAtoPlay                                                  ; $0fa2 : $e4, $09
    beq @br_0fdd                                                  ; $0fa4 : $f0, $37

; stop/silent if $80
    cmp A, #$80                                                  ; $0fa6 : $68, $80
    beq @loop_0f69                                                  ; $0fa8 : $f0, $bf

; put snd effect in Y
    mov Y, A                                                  ; $0faa : $fd
    mov A, !SoundEffectsTableOffs-1+Y                                                  ; $0fab : $f6, $79, $0e
    mov Y, A                                                  ; $0fae : $fd

; Save 1st byte in table entry (enabled tracks, bit 0 - track 7, bit 1 - track 6)
    mov A, wSndEffectAtoPlay                                                  ; $0faf : $e4, $09
    cmp A, #$1d                                                               ; $0fb1 : $68, $1d
    bcs @@useTable2                                                           ; $0fb3 : $b0, $05

    mov A, !SoundEffectsA_01hTo1Ch.w-1+Y                                      ; $0fb5 : $f6, $ce, $1c
    bra +                                                                     ; $0fb8 : $2f, $03

@@useTable2:
    mov A, !SoundEffectsA_1DhTo30h.w-1+Y                                      ; $0fba : $f6, $ca, $1d

+   mov !wActiveSndEffectATracks, A                                           ; $0fbd : $c5, $d0, $03

;
    bpl @br_0fc6                                                  ; $0fc0 : $10, $04

    mov A, wSndEffectAtoPlay                                                  ; $0fc2 : $e4, $09
    bra +                                                  ; $0fc4 : $2f, $02

@br_0fc6:
    mov A, #$00                                                  ; $0fc6 : $e8, $00

+   mov !$03da, A                                                  ; $0fc8 : $c5, $da, $03

; Save A tracks in low 7 bits
    mov A, !wActiveSndEffectATracks                                           ; $0fcb : $e5, $d0, $03
    and A, #$7f                                                               ; $0fce : $28, $7f
    mov !wActiveSndEffectATracks, A                                           ; $0fd0 : $c5, $d0, $03

; Branch based on which of track 7, then 6 is enabled
    lsr !wActiveSndEffectATracks                                              ; $0fd3 : $4c, $d0, $03
    bcs @processTrack7                                                        ; $0fd6 : $b0, $08

    lsr !wActiveSndEffectATracks                                              ; $0fd8 : $4c, $d0, $03
    bcs @processTrack6                                                        ; $0fdb : $b0, $54

@br_0fdd:
    jmp !@tryStartingTrack7or6                                                  ; $0fdd : $5f, $7c, $10

@processTrack7:
    mov A, wSndEffectAtoPlay                                                  ; $0fe0 : $e4, $09

@bigLoop_0fe2:
    mov !wSoundEffectAIdxForTrack7, A                                                  ; $0fe2 : $c5, $67, $02
    mov Y, A                                                  ; $0fe5 : $fd
    mov A, !SoundEffectsTableOffs-1+Y                                                  ; $0fe6 : $f6, $79, $0e
    mov !wSndEffectATableOffs, A                                                  ; $0fe9 : $c5, $d5, $03
    mov A, #$00                                                  ; $0fec : $e8, $00
    mov !$025f, A                                                  ; $0fee : $c5, $5f, $02
    mov X, #$0e                                                  ; $0ff1 : $cd, $0e
    call !Call_00_1bae                                                  ; $0ff3 : $3f, $ae, $1b
    mov A, #$03                                                  ; $0ff6 : $e8, $03
    mov !$026f, A                                                  ; $0ff8 : $c5, $6f, $02
    set1 wBitfieldOfSndEffectsTracksUsed.7                                                  ; $0ffb : $e2, $1a
    and w4b, #$7f                                                  ; $0ffd : $38, $7f, $4b
    clr1 wd7.7                                                  ; $1000 : $f2, $d7
    clr1 w4a.7                                                  ; $1002 : $f2, $4a
    mov Y, !wSndEffectATableOffs                                                  ; $1004 : $ec, $d5, $03

; Save 1st word in table entry (track 7 ptr)
    mov A, !wSoundEffectAIdxForTrack7                                         ; $1007 : $e5, $67, $02
    cmp A, #$1d                                                               ; $100a : $68, $1d
    bcs @@useTable2                                                           ; $100c : $b0, $0e

    mov A, !SoundEffectsA_01hTo1Ch+1+Y                                        ; $100e : $f6, $d0, $1c
    mov !wSndEffectACopyOfTrack7Ptr+1, A                                      ; $1011 : $c5, $2f, $01
    mov A, !SoundEffectsA_01hTo1Ch+Y                                          ; $1014 : $f6, $cf, $1c
    mov !wSndEffectACopyOfTrack7Ptr, A                                        ; $1017 : $c5, $2e, $01
    bra @@tryTrack6                                                           ; $101a : $2f, $0c

@@useTable2:
    mov A, !SoundEffectsA_1DhTo30h+1+Y                                        ; $101c : $f6, $cc, $1d
    mov !wSndEffectACopyOfTrack7Ptr+1, A                                      ; $101f : $c5, $2f, $01
    mov A, !SoundEffectsA_1DhTo30h+Y                                          ; $1022 : $f6, $cb, $1d
    mov !wSndEffectACopyOfTrack7Ptr, A                                        ; $1025 : $c5, $2e, $01

@@tryTrack6:
; If the next bit of this flag is set, track 6 is enabled
    clrc                                                                      ; $1028 : $60
    lsr !wActiveSndEffectATracks                                              ; $1029 : $4c, $d0, $03
    bcs @processTrack6                                                        ; $102c : $b0, $03

;
    jmp !@tryStartingTrack7or6                                                  ; $102e : $5f, $7c, $10

@processTrack6:
    mov A, wSndEffectAtoPlay                                                  ; $1031 : $e4, $09

@bigLoop_1033:
    mov !wSoundEffectAIdxForTrack6, A                                                  ; $1033 : $c5, $66, $02
    mov Y, A                                                  ; $1036 : $fd
    mov A, !SoundEffectsTableOffs-1+Y                                                  ; $1037 : $f6, $79, $0e
    mov !wSndEffectATableOffs, A                                                  ; $103a : $c5, $d5, $03
    mov A, #$00                                                  ; $103d : $e8, $00
    mov !$025e, A                                                  ; $103f : $c5, $5e, $02
    mov X, #$0c                                                  ; $1042 : $cd, $0c
    call !Call_00_1bae                                                  ; $1044 : $3f, $ae, $1b
    mov A, #$03                                                  ; $1047 : $e8, $03
    mov !$026e, A                                                  ; $1049 : $c5, $6e, $02
    set1 wBitfieldOfSndEffectsTracksUsed.6                                                  ; $104c : $c2, $1a
    and w4b, #$7f                                                  ; $104e : $38, $7f, $4b
    clr1 wd7.6                                                  ; $1051 : $d2, $d7
    clr1 w4a.6                                                  ; $1053 : $d2, $4a
    mov Y, !wSndEffectATableOffs                                                  ; $1055 : $ec, $d5, $03

; Save 2nd word in table entry (track 6 ptr)
    mov A, !wSoundEffectAIdxForTrack6                                         ; $1058 : $e5, $66, $02
    cmp A, #$1d                                                               ; $105b : $68, $1d
    bcs @@useTable2                                                           ; $105d : $b0, $0e

    mov A, !SoundEffectsA_01hTo1Ch+3+Y                                        ; $105f : $f6, $d2, $1c
    mov !wSndEffectACopyOfTrack6Ptr+1, A                                      ; $1062 : $c5, $2d, $01
    mov A, !SoundEffectsA_01hTo1Ch+2+Y                                        ; $1065 : $f6, $d1, $1c
    mov !wSndEffectACopyOfTrack6Ptr, A                                        ; $1068 : $c5, $2c, $01
    bra @@tryTrack6                                                           ; $106b : $2f, $0c

@@useTable2:
    mov A, !SoundEffectsA_1DhTo30h+3+Y                                        ; $106d : $f6, $ce, $1d
    mov !wSndEffectACopyOfTrack6Ptr+1, A                                      ; $1070 : $c5, $2d, $01
    mov A, !SoundEffectsA_1DhTo30h+2+Y                                        ; $1073 : $f6, $cd, $1d
    mov !wSndEffectACopyOfTrack6Ptr, A                                        ; $1076 : $c5, $2c, $01

@@tryTrack6:
    jmp !@tryStartingTrack6                                                   ; $1079 : $5f, $81, $10

@tryStartingTrack7or6:
    mov A, !wSoundEffectAIdxForTrack7                                         ; $107c : $e5, $67, $02
    bne @startTrack7                                                          ; $107f : $d0, $06

@tryStartingTrack6:
    mov A, !wSoundEffectAIdxForTrack6                                         ; $1081 : $e5, $66, $02
    bne @startTrack6                                                          ; $1084 : $d0, $1a

@done:
    ret                                                                       ; $1086 : $6f

@startTrack7:
    clr1 $47.7                                                  ; $1087 : $f2, $47
    mov A, !$025f                                                  ; $1089 : $e5, $5f, $02
    bne @brLoop_10b9                                                  ; $108c : $d0, $2b

    mov A, !$026f                                                  ; $108e : $e5, $6f, $02
    beq @br_10c2                                                  ; $1091 : $f0, $2f

    dec !$026f                                                  ; $1093 : $8c, $6f, $02
    cmp A, #$02                                                  ; $1096 : $68, $02
    bne +                                                  ; $1098 : $d0, $04

    set1 w46.7                                                  ; $109a : $e2, $46
    clr1 w49.7                                                  ; $109c : $f2, $49

+   bra @tryStartingTrack6                                                  ; $109e : $2f, $e1

@startTrack6:
    clr1 $47.6                                                  ; $10a0 : $d2, $47
    mov A, !$025e                                                  ; $10a2 : $e5, $5e, $02
    bne @brLoop_10bc                                                  ; $10a5 : $d0, $15

    mov A, !$026e                                                  ; $10a7 : $e5, $6e, $02
    beq @br_10bf                                                  ; $10aa : $f0, $13

    dec !$026e                                                  ; $10ac : $8c, $6e, $02
    cmp A, #$02                                                  ; $10af : $68, $02
    bne +                                                  ; $10b1 : $d0, $04

    set1 w46.6                                                  ; $10b3 : $c2, $46
    clr1 w49.6                                                  ; $10b5 : $d2, $49

+   bra @done                                                  ; $10b7 : $2f, $cd

@brLoop_10b9:
    jmp !@bigBr_1126                                                  ; $10b9 : $5f, $26, $11

@brLoop_10bc:
    jmp !@bigBr_1167                                                  ; $10bc : $5f, $67, $11

@br_10bf:
    jmp !@br_10f9                                                  ; $10bf : $5f, $f9, $10

@br_10c2:
    mov X, #$0e                                                  ; $10c2 : $cd, $0e
    mov A, !wSndEffectACopyOfTrack7Ptr                                                  ; $10c4 : $e5, $2e, $01
    mov wSndEffectTrackDataPtr, A                                                  ; $10c7 : $c4, $d2
    mov A, !wSndEffectACopyOfTrack7Ptr+1                                                  ; $10c9 : $e5, $2f, $01
    mov wSndEffectTrackDataPtr+1, A                                                  ; $10cc : $c4, $d3
    call !ProcessSndEffectData@start                                                  ; $10ce : $3f, $4f, $16
    cmp A, #$ff                                                  ; $10d1 : $68, $ff
    bne @br_10dc                                                  ; $10d3 : $d0, $07

    mov A, #$05                                                  ; $10d5 : $e8, $05
    mov !$025f, A                                                  ; $10d7 : $c5, $5f, $02
    bra @brLoop_10b9                                                  ; $10da : $2f, $dd

@br_10dc:
    cmp A, #$fe                                                  ; $10dc : $68, $fe
    bne @br_10e9                                                  ; $10de : $d0, $09

    call !Call_00_1bce                                                  ; $10e0 : $3f, $ce, $1b
    mov A, !wSoundEffectAIdxForTrack7                                                  ; $10e3 : $e5, $67, $02
    jmp !@bigLoop_0fe2                                                  ; $10e6 : $5f, $e2, $0f

@br_10e9:
    cmp A, #$fc                                                  ; $10e9 : $68, $fc
    bne @br_10f3                                                  ; $10eb : $d0, $06

    mov A, !wSoundEffectAIdxForTrack7                                                  ; $10ed : $e5, $67, $02
    jmp !@bigLoop_1033                                                  ; $10f0 : $5f, $33, $10

@br_10f3:
    dec !$03be                                                  ; $10f3 : $8c, $be, $03
    jmp !@tryStartingTrack6                                                  ; $10f6 : $5f, $81, $10

@br_10f9:
    mov X, #$0c                                                  ; $10f9 : $cd, $0c

; eg 1e82
    mov A, !wSndEffectACopyOfTrack6Ptr                                                  ; $10fb : $e5, $2c, $01
    mov wSndEffectTrackDataPtr, A                                                  ; $10fe : $c4, $d2
    mov A, !wSndEffectACopyOfTrack6Ptr+1                                                  ; $1100 : $e5, $2d, $01
    mov wSndEffectTrackDataPtr+1, A                                                  ; $1103 : $c4, $d3

;
    call !ProcessSndEffectData@start                                                  ; $1105 : $3f, $4f, $16
    cmp A, #$ff                                                  ; $1108 : $68, $ff
    bne @br_1113                                                  ; $110a : $d0, $07

    mov A, #$05                                                  ; $110c : $e8, $05
    mov !$025e, A                                                  ; $110e : $c5, $5e, $02
    bra @brLoop_10bc                                                  ; $1111 : $2f, $a9

@br_1113:
    cmp A, #$fe                                                  ; $1113 : $68, $fe
    bne @br_1120                                                  ; $1115 : $d0, $09

    call !Call_00_1be8                                                  ; $1117 : $3f, $e8, $1b
    mov A, !wSoundEffectAIdxForTrack6                                                  ; $111a : $e5, $66, $02
    jmp !@bigLoop_1033                                                  ; $111d : $5f, $33, $10

@br_1120:
    dec !$03bc                                                  ; $1120 : $8c, $bc, $03
    jmp !@done                                                  ; $1123 : $5f, $86, $10

@bigBr_1126:
    mov A, !$025f                                                  ; $1126 : $e5, $5f, $02
    cmp A, #$05                                                  ; $1129 : $68, $05
    bne @cont_113b                                                  ; $112b : $d0, $0e

    mov A, #$00                                                  ; $112d : $e8, $00
    mov Y, #$70|ADSR_1                                                  ; $112f : $8d, $75
    call !SetDspAddrDataToYA                                                  ; $1131 : $3f, $1d, $06
    mov A, #$9c                                                  ; $1134 : $e8, $9c
    mov Y, #$70|GAIN                                                  ; $1136 : $8d, $77
    call !SetDspAddrDataToYA                                                  ; $1138 : $3f, $1d, $06

@cont_113b:
    dec !$025f                                                  ; $113b : $8c, $5f, $02
    mov A, !$025f                                                  ; $113e : $e5, $5f, $02
    cmp A, #$02                                                  ; $1141 : $68, $02
    bne @br_1152                                                  ; $1143 : $d0, $0d

    set1 w46.7                                                  ; $1145 : $e2, $46
    and w4b, #$7f                                                  ; $1147 : $38, $7f, $4b
    mov Y, #$70                                                  ; $114a : $8d, $70
    call !Call_00_1b87                                                  ; $114c : $3f, $87, $1b
    jmp !@tryStartingTrack6                                                  ; $114f : $5f, $81, $10

@br_1152:
    mov A, !$025f                                                  ; $1152 : $e5, $5f, $02
    bne @cont_1164                                                  ; $1155 : $d0, $0d

    mov Y, #$00                                                  ; $1157 : $8d, $00
    mov !wSoundEffectAIdxForTrack7, Y                                                  ; $1159 : $cc, $67, $02
    mov A, !wSoundEffectAIdxForTrack6                                                  ; $115c : $e5, $66, $02
    bne +                                                  ; $115f : $d0, $00

+   call !Call_00_1bc1                                                  ; $1161 : $3f, $c1, $1b

@cont_1164:
    jmp !@tryStartingTrack6                                                  ; $1164 : $5f, $81, $10

@bigBr_1167:
    mov A, !$025e                                                  ; $1167 : $e5, $5e, $02
    cmp A, #$05                                                  ; $116a : $68, $05
    bne @cont_117c                                                  ; $116c : $d0, $0e

    mov A, #$00                                                  ; $116e : $e8, $00
    mov Y, #$65                                                  ; $1170 : $8d, $65
    call !SetDspAddrDataToYA                                                  ; $1172 : $3f, $1d, $06
    mov A, #$9c                                                  ; $1175 : $e8, $9c
    mov Y, #$67                                                  ; $1177 : $8d, $67
    call !SetDspAddrDataToYA                                                  ; $1179 : $3f, $1d, $06

@cont_117c:
    dec !$025e                                                  ; $117c : $8c, $5e, $02
    mov A, !$025e                                                  ; $117f : $e5, $5e, $02
    cmp A, #$02                                                  ; $1182 : $68, $02
    bne @br_1193                                                  ; $1184 : $d0, $0d

    set1 w46.6                                                  ; $1186 : $c2, $46
    and w4b, #$7f                                                  ; $1188 : $38, $7f, $4b
    mov Y, #$60                                                  ; $118b : $8d, $60
    call !Call_00_1b87                                                  ; $118d : $3f, $87, $1b
    jmp !@done                                                  ; $1190 : $5f, $86, $10

@br_1193:
    mov A, !$025e                                                  ; $1193 : $e5, $5e, $02
    bne @cont_11a5                                                  ; $1196 : $d0, $0d

    mov Y, #$00                                                  ; $1198 : $8d, $00
    mov !wSoundEffectAIdxForTrack6, Y                                                  ; $119a : $cc, $66, $02
    mov A, !wSoundEffectAIdxForTrack7                                                  ; $119d : $e5, $67, $02
    bne +                                                  ; $11a0 : $d0, $00

+   call !Call_00_1bdb                                                  ; $11a2 : $3f, $db, $1b

@cont_11a5:
    jmp !@done                                                  ; $11a5 : $5f, $86, $10


ProcessSndEffectBsustain:
    mov A, #$00                                                  ; $11a8 : $e8, $00
    mov !$03db, A                                                  ; $11aa : $c5, $db, $03
    mov A, #$05                                                  ; $11ad : $e8, $05
    mov !$0259, A                                                  ; $11af : $c5, $59, $02
    mov !$0258, A                                                  ; $11b2 : $c5, $58, $02
    mov A, #$05                                                  ; $11b5 : $e8, $05
    mov !$025c, A                                                  ; $11b7 : $c5, $5c, $02
    mov A, #$05                                                  ; $11ba : $e8, $05
    mov !$025d, A                                                  ; $11bc : $c5, $5d, $02
    jmp !@bigBr_13d8                                                  ; $11bf : $5f, $d8, $13

; unused?
    mov A, #$05                                                  ; $11c2 : $e8, $05
    mov !$025c, A                                                  ; $11c4 : $c5, $5c, $02
    jmp !@bigBr_13d8                                                  ; $11c7 : $5f, $d8, $13

; unused?
    mov A, #$05                                                  ; $11ca : $e8, $05
    mov !$0259, A                                                  ; $11cc : $c5, $59, $02
    jmp !@bigBr_13d8                                                  ; $11cf : $5f, $d8, $13

; unused?
    mov A, #$05                                                  ; $11d2 : $e8, $05
    mov !$0258, A                                                  ; $11d4 : $c5, $58, $02
    jmp !@bigBr_13d8                                                  ; $11d7 : $5f, $d8, $13

@start:
    mov A, wSndEffectBsustain                                                  ; $11da : $e4, $02
    cmp A, #SNDB_DISABLE_SOUND                                                  ; $11dc : $68, $81
    bne @not81h                                                  ; $11de : $d0, $26

    mov A, #$01                                                  ; $11e0 : $e8, $01
    mov wSPCDisabled, A                                                  ; $11e2 : $c4, $dd
    set1 wDSPflags.FLGB_MUTE                                                  ; $11e4 : $c2, $48
    mov A, #$00                                                  ; $11e6 : $e8, $00
    mov $04, A                                                  ; $11e8 : $c4, $04
    mov !wSoundEffectAIdxForTrack7, A                                                  ; $11ea : $c5, $67, $02
    mov !wSoundEffectAIdxForTrack6, A                                                  ; $11ed : $c5, $66, $02
    mov !wSoundEffectBIdxForTrack5, A                                                  ; $11f0 : $c5, $65, $02
    mov !wSoundEffectBIdxForTrack4, A                                                  ; $11f3 : $c5, $64, $02
    mov !$0263, A                                                  ; $11f6 : $c5, $63, $02
    mov !$0262, A                                                  ; $11f9 : $c5, $62, $02
    mov !wSoundEffectBIdxForTrack1, A                                                  ; $11fc : $c5, $61, $02
    mov !wSoundEffectBIdxForTrack0, A                                                  ; $11ff : $c5, $60, $02
    or w46, #$ff                                                  ; $1202 : $18, $ff, $46
    ret                                                  ; $1205 : $6f

@not81h:
; Reset engine if SPC is disabled and SNDB_REENABLE_SOUND sent
    mov X, wSPCDisabled                                                  ; $1206 : $f8, $dd
    beq @afterResetCheck                                                  ; $1208 : $f0, $07

    cmp A, #SNDB_REENABLE_SOUND                                                  ; $120a : $68, $82
    bne @afterResetCheck                                                  ; $120c : $d0, $03

    jmp !Begin                                                  ; $120e : $5f, $00, $04

@afterResetCheck:
;
    cmp A, #SNDB_REENABLE_SOUND                                                  ; $1211 : $68, $82
    bne @not82h                                                  ; $1213 : $d0, $03

    jmp !@bigBr_13d8                                                  ; $1215 : $5f, $d8, $13

@not82h:
; For any non-$81/SNDB_REENABLE_SOUND effects, stop music if SPC is disabled
    mov A, wSPCDisabled                                                  ; $1218 : $e4, $dd
    beq @notDisabled                                                  ; $121a : $f0, $0a

    mov A, $02                                                  ; $121c : $e4, $02
    cmp A, #$80                                                  ; $121e : $68, $80
    beq ProcessSndEffectBsustain                                                  ; $1220 : $f0, $86

    ret                                                  ; $1222 : $6f

@loop_1223:
    jmp !ProcessSndEffectBsustain                                                  ; $1223 : $5f, $a8, $11

@notDisabled:
; valid is $01 to $19
    mov A, $02                                                  ; $1226 : $e4, $02
    cmp A, #$1a                                                  ; $1228 : $68, $1a
    bcc +                                                  ; $122a : $90, $04

    mov A, #$80                                                  ; $122c : $e8, $80
    mov $02, A                                                  ; $122e : $c4, $02

+   mov Y, wSndEffectBtoPlay                                                  ; $1230 : $eb, $0a
    mov A, $02                                                  ; $1232 : $e4, $02
    mov wSndEffectBtoPlay, A                                                  ; $1234 : $c4, $0a
    cmp Y, $02                                                  ; $1236 : $7e, $02
    beq @br_127f                                                  ; $1238 : $f0, $45

    mov A, wSndEffectBtoPlay                                                  ; $123a : $e4, $0a
    beq @br_127f                                                  ; $123c : $f0, $41

    cmp A, #$80                                                  ; $123e : $68, $80
    beq @loop_1223                                                  ; $1240 : $f0, $e1

    mov Y, A                                                  ; $1242 : $fd
    mov A, !SoundEffectsTableOffs-1+Y                                                  ; $1243 : $f6, $79, $0e
    mov Y, A                                                  ; $1246 : $fd
    mov A, wSndEffectBtoPlay                                                  ; $1247 : $e4, $0a
    cmp A, #$1d                                                  ; $1249 : $68, $1d
    bcs @br_1252                                                  ; $124b : $b0, $05

    mov A, !SoundEffectsB_01hTo1Ch-1+Y                                                  ; $124d : $f6, $13, $26
    bra +                                                  ; $1250 : $2f, $03

@br_1252:
    mov A, !SoundEffectsB_1Dh-1+Y                                                  ; $1252 : $f6, $0f, $27

+   mov !wActiveSndEffectBTracks, A                                                  ; $1255 : $c5, $d1, $03
    bpl @br_125e                                                  ; $1258 : $10, $04

    mov A, wSndEffectBtoPlay                                                  ; $125a : $e4, $0a
    bra +                                                  ; $125c : $2f, $02

@br_125e:
    mov A, #$00                                                  ; $125e : $e8, $00

+   mov !$03db, A                                                  ; $1260 : $c5, $db, $03
    mov A, !wActiveSndEffectBTracks                                                  ; $1263 : $e5, $d1, $03
    and A, #$7f                                                  ; $1266 : $28, $7f
    mov !wActiveSndEffectBTracks, A                                                  ; $1268 : $c5, $d1, $03
    lsr !wActiveSndEffectBTracks                                                  ; $126b : $4c, $d1, $03
    bcs @br_128b                                                  ; $126e : $b0, $1b

    lsr !wActiveSndEffectBTracks                                                  ; $1270 : $4c, $d1, $03
    bcs @br_1282                                                  ; $1273 : $b0, $0d

    lsr !wActiveSndEffectBTracks                                                  ; $1275 : $4c, $d1, $03
    bcs @br_1285                                                  ; $1278 : $b0, $0b

    lsr !wActiveSndEffectBTracks                                                  ; $127a : $4c, $d1, $03
    bcs @brLoop_1288                                                  ; $127d : $b0, $09

@br_127f:
    jmp !@bigBr_13d8                                                  ; $127f : $5f, $d8, $13

@br_1282:
    jmp !@br_12e6                                                  ; $1282 : $5f, $e6, $12

@br_1285:
    jmp !@bigBr_133c                                                  ; $1285 : $5f, $3c, $13

@brLoop_1288:
    jmp !@bigBr_138d                                                  ; $1288 : $5f, $8d, $13

@br_128b:
    mov A, wSndEffectBtoPlay                                                 ; $128b : $e4, $0a

@bigLoop_128d:
    mov !wSoundEffectBIdxForTrack5, A                                                  ; $128d : $c5, $65, $02
    mov Y, A                                                  ; $1290 : $fd
    mov A, !SoundEffectsTableOffs-1+Y                                                  ; $1291 : $f6, $79, $0e
    mov !wSndEffectBTableOffs, A                                                  ; $1294 : $c5, $d6, $03
    mov A, #$00                                                  ; $1297 : $e8, $00
    mov !$025d, A                                                  ; $1299 : $c5, $5d, $02
    mov X, #$0a                                                  ; $129c : $cd, $0a
    call !Call_00_1bae                                                  ; $129e : $3f, $ae, $1b
    mov A, #$03                                                  ; $12a1 : $e8, $03
    mov !$026d, A                                                  ; $12a3 : $c5, $6d, $02
    set1 wBitfieldOfSndEffectsTracksUsed.5                                                  ; $12a6 : $a2, $1a
    and w4b, #$df                                                  ; $12a8 : $38, $df, $4b
    clr1 wd7.5                                                  ; $12ab : $b2, $d7
    clr1 w4a.5                                                  ; $12ad : $b2, $4a
    mov Y, !wSndEffectBTableOffs                                                  ; $12af : $ec, $d6, $03

; Save 1st word in table entry (track 5 ptr)
    mov A, !wSoundEffectBIdxForTrack5                                                  ; $12b2 : $e5, $65, $02
    cmp A, #$1d                                                  ; $12b5 : $68, $1d
    bcs @br_12c7                                                  ; $12b7 : $b0, $0e

    mov A, !SoundEffectsB_01hTo1Ch+1+Y                                                  ; $12b9 : $f6, $15, $26
    mov !wSndEffectBCopyOfTrack5Ptr+1, A                                                  ; $12bc : $c5, $2b, $01
    mov A, !SoundEffectsB_01hTo1Ch+Y                                                  ; $12bf : $f6, $14, $26
    mov !wSndEffectBCopyOfTrack5Ptr, A                                                  ; $12c2 : $c5, $2a, $01
    bra @cont_12d3                                                  ; $12c5 : $2f, $0c

@br_12c7:
    mov A, !SoundEffectsB_1Dh+1+Y                                                  ; $12c7 : $f6, $11, $27
    mov !wSndEffectBCopyOfTrack5Ptr+1, A                                                  ; $12ca : $c5, $2b, $01
    mov A, !SoundEffectsB_1Dh+Y                                                  ; $12cd : $f6, $10, $27
    mov !wSndEffectBCopyOfTrack5Ptr, A                                                  ; $12d0 : $c5, $2a, $01

@cont_12d3:
    clrc                                                  ; $12d3 : $60
    lsr !wActiveSndEffectBTracks                                                  ; $12d4 : $4c, $d1, $03
    bcs @br_12e6                                                  ; $12d7 : $b0, $0d

    lsr !wActiveSndEffectBTracks                                                  ; $12d9 : $4c, $d1, $03
    bcs @bigBr_133c                                                  ; $12dc : $b0, $5e

    lsr !wActiveSndEffectBTracks                                                  ; $12de : $4c, $d1, $03
    bcs @brLoop_1288                                                  ; $12e1 : $b0, $a5

    jmp !@bigBr_13d8                                                  ; $12e3 : $5f, $d8, $13

@br_12e6:
    mov A, wSndEffectBtoPlay                                                  ; $12e6 : $e4, $0a

@bigLoop_12e8:
    mov !wSoundEffectBIdxForTrack4, A                                                  ; $12e8 : $c5, $64, $02
    mov Y, A                                                  ; $12eb : $fd
    mov A, !SoundEffectsTableOffs-1+Y                                                  ; $12ec : $f6, $79, $0e
    mov !wSndEffectBTableOffs, A                                                  ; $12ef : $c5, $d6, $03
    mov A, #$00                                                  ; $12f2 : $e8, $00
    mov !$025c, A                                                  ; $12f4 : $c5, $5c, $02
    mov X, #$08                                                  ; $12f7 : $cd, $08
    call !Call_00_1bae                                                  ; $12f9 : $3f, $ae, $1b
    mov A, #$03                                                  ; $12fc : $e8, $03
    mov !$026c, A                                                  ; $12fe : $c5, $6c, $02
    set1 wBitfieldOfSndEffectsTracksUsed.4                                                  ; $1301 : $82, $1a
    and w4b, #$df                                                  ; $1303 : $38, $df, $4b
    clr1 wd7.4                                                  ; $1306 : $92, $d7
    clr1 w4a.4                                                  ; $1308 : $92, $4a
    mov Y, !wSndEffectBTableOffs                                                  ; $130a : $ec, $d6, $03

; Save 2nd word in table entry (track 4 ptr)
    mov A, !wSoundEffectBIdxForTrack4                                                  ; $130d : $e5, $64, $02
    cmp A, #$1d                                                  ; $1310 : $68, $1d
    bcs @br_1322                                                  ; $1312 : $b0, $0e

    mov A, !SoundEffectsB_01hTo1Ch+3+Y                                                  ; $1314 : $f6, $17, $26
    mov !wSndEffectBCopyOfTrack4Ptr+1, A                                                  ; $1317 : $c5, $29, $01
    mov A, !SoundEffectsB_01hTo1Ch+2+Y                                                  ; $131a : $f6, $16, $26
    mov !wSndEffectBCopyOfTrack4Ptr, A                                                  ; $131d : $c5, $28, $01
    bra @cont_132e                                                  ; $1320 : $2f, $0c

@br_1322:
    mov A, !SoundEffectsB_1Dh+3+Y                                                  ; $1322 : $f6, $13, $27
    mov !wSndEffectBCopyOfTrack4Ptr+1, A                                                  ; $1325 : $c5, $29, $01
    mov A, !SoundEffectsB_1Dh+2+Y                                                  ; $1328 : $f6, $12, $27
    mov !wSndEffectBCopyOfTrack4Ptr, A                                                  ; $132b : $c5, $28, $01

@cont_132e:
    clrc                                                  ; $132e : $60
    lsr !wActiveSndEffectBTracks                                                  ; $132f : $4c, $d1, $03
    bcs @bigBr_133c                                                  ; $1332 : $b0, $08

    lsr !wActiveSndEffectBTracks                                                  ; $1334 : $4c, $d1, $03
    bcs @bigBr_138d                                                  ; $1337 : $b0, $54

    jmp !@bigBrBigLoop_13dd                                                  ; $1339 : $5f, $dd, $13

@bigBr_133c:
    mov A, wSndEffectBtoPlay                                                 ; $133c : $e4, $0a

@bigLoop_133e:
    mov !wSoundEffectBIdxForTrack1, A                                                  ; $133e : $c5, $61, $02
    mov Y, A                                                  ; $1341 : $fd
    mov A, !SoundEffectsTableOffs-1+Y                                                  ; $1342 : $f6, $79, $0e
    mov !wSndEffectBTableOffs, A                                                  ; $1345 : $c5, $d6, $03
    mov A, #$00                                                  ; $1348 : $e8, $00
    mov !$0259, A                                                  ; $134a : $c5, $59, $02
    mov X, #$02                                                  ; $134d : $cd, $02
    call !Call_00_1bae                                                  ; $134f : $3f, $ae, $1b
    mov A, #$03                                                  ; $1352 : $e8, $03
    mov !$0269, A                                                  ; $1354 : $c5, $69, $02
    set1 wBitfieldOfSndEffectsTracksUsed.1                                                  ; $1357 : $22, $1a
    and w4b, #$fd                                                  ; $1359 : $38, $fd, $4b
    clr1 wd7.1                                                  ; $135c : $32, $d7
    clr1 w4a.1                                                  ; $135e : $32, $4a
    mov Y, !wSndEffectBTableOffs                                                  ; $1360 : $ec, $d6, $03

; Save 3rd word in table entry (track 1 ptr)
    mov A, !wSoundEffectBIdxForTrack1                                                  ; $1363 : $e5, $61, $02
    cmp A, #$1d                                                  ; $1366 : $68, $1d
    bcs @br_1378                                                  ; $1368 : $b0, $0e

    mov A, !SoundEffectsB_01hTo1Ch+5+Y                                                  ; $136a : $f6, $19, $26
    mov !wSndEffectBCopyOfTrack1Ptr+1, A                                                  ; $136d : $c5, $23, $01
    mov A, !SoundEffectsB_01hTo1Ch+4+Y                                                  ; $1370 : $f6, $18, $26
    mov !wSndEffectBCopyOfTrack1Ptr, A                                                  ; $1373 : $c5, $22, $01
    bra @cont_1384                                                  ; $1376 : $2f, $0c

@br_1378:
    mov A, !SoundEffectsB_1Dh+5+Y                                                  ; $1378 : $f6, $15, $27
    mov !wSndEffectBCopyOfTrack1Ptr+1, A                                                  ; $137b : $c5, $23, $01
    mov A, !SoundEffectsB_1Dh+4+Y                                                  ; $137e : $f6, $14, $27
    mov !wSndEffectBCopyOfTrack1Ptr, A                                                  ; $1381 : $c5, $22, $01

@cont_1384:
    clrc                                                  ; $1384 : $60
    lsr !wActiveSndEffectBTracks                                                  ; $1385 : $4c, $d1, $03
    bcs @bigBr_138d                                                  ; $1388 : $b0, $03

    jmp !@brBigLoop_13e2                                                  ; $138a : $5f, $e2, $13

@bigBr_138d:
    mov A, wSndEffectBtoPlay                                                 ; $138d : $e4, $0a

@bigLoop_138f:
    mov !wSoundEffectBIdxForTrack0, A                                                  ; $138f : $c5, $60, $02
    mov Y, A                                                  ; $1392 : $fd
    mov A, !SoundEffectsTableOffs-1+Y                                                  ; $1393 : $f6, $79, $0e
    mov !wSndEffectBTableOffs, A                                                  ; $1396 : $c5, $d6, $03
    mov A, #$00                                                  ; $1399 : $e8, $00
    mov !$0258, A                                                  ; $139b : $c5, $58, $02
    mov X, #$00                                                  ; $139e : $cd, $00
    call !Call_00_1bae                                                  ; $13a0 : $3f, $ae, $1b
    mov A, #$03                                                  ; $13a3 : $e8, $03
    mov !$0268, A                                                  ; $13a5 : $c5, $68, $02
    set1 wBitfieldOfSndEffectsTracksUsed.0                                                  ; $13a8 : $02, $1a
    and w4b, #$fd                                                  ; $13aa : $38, $fd, $4b
    clr1 wd7.0                                                  ; $13ad : $12, $d7
    clr1 w4a.0                                                  ; $13af : $12, $4a
    mov Y, !wSndEffectBTableOffs                                                  ; $13b1 : $ec, $d6, $03

; Save 4th word in table enntry (track 0 ptr)
    mov A, !wSoundEffectBIdxForTrack0                                                  ; $13b4 : $e5, $60, $02
    cmp A, #$1d                                                  ; $13b7 : $68, $1d
    bcs @@useTable2                                                  ; $13b9 : $b0, $0e

    mov A, !SoundEffectsB_01hTo1Ch+7+Y                                                  ; $13bb : $f6, $1b, $26
    mov !wSndEffectBCopyOfTrack0Ptr+1, A                                                  ; $13be : $c5, $21, $01
    mov A, !SoundEffectsB_01hTo1Ch+6+Y                                                  ; $13c1 : $f6, $1a, $26
    mov !wSndEffectBCopyOfTrack0Ptr, A                                                  ; $13c4 : $c5, $20, $01
    bra @cont_13d5                                                  ; $13c7 : $2f, $0c

@@useTable2:
    mov A, !SoundEffectsB_1Dh+7+Y                                                  ; $13c9 : $f6, $17, $27
    mov !wSndEffectBCopyOfTrack0Ptr+1, A                                                  ; $13cc : $c5, $21, $01
    mov A, !SoundEffectsB_1Dh+6+Y                                                  ; $13cf : $f6, $16, $27
    mov !wSndEffectBCopyOfTrack0Ptr, A                                                  ; $13d2 : $c5, $20, $01

@cont_13d5:
    jmp !@brBigLoop_13e7                                                  ; $13d5 : $5f, $e7, $13

@bigBr_13d8:
    mov A, !wSoundEffectBIdxForTrack5                                                  ; $13d8 : $e5, $65, $02
    bne @br_13ed                                                  ; $13db : $d0, $10

@bigBrBigLoop_13dd:
    mov A, !wSoundEffectBIdxForTrack4                                                  ; $13dd : $e5, $64, $02
    bne @br_1406                                                  ; $13e0 : $d0, $24

@brBigLoop_13e2:
    mov A, !wSoundEffectBIdxForTrack1                                                  ; $13e2 : $e5, $61, $02
    bne @br_141f                                                  ; $13e5 : $d0, $38

@brBigLoop_13e7:
    mov A, !wSoundEffectBIdxForTrack0                                                  ; $13e7 : $e5, $60, $02
    bne @br_1438                                                  ; $13ea : $d0, $4c

@done_13ec:
    ret                                                  ; $13ec : $6f

@br_13ed:
    clr1 $47.5                                                  ; $13ed : $b2, $47
    mov A, !$025d                                                  ; $13ef : $e5, $5d, $02
    bne @brLoop_1451                                                  ; $13f2 : $d0, $5d

    mov A, !$026d                                                  ; $13f4 : $e5, $6d, $02
    beq @bigBr_1466                                                  ; $13f7 : $f0, $6d

    dec !$026d                                                  ; $13f9 : $8c, $6d, $02
    cmp A, #$02                                                  ; $13fc : $68, $02
    bne +                                                  ; $13fe : $d0, $04

    set1 w46.5                                                  ; $1400 : $a2, $46
    clr1 w49.5                                                  ; $1402 : $b2, $49

+   bra @bigBrBigLoop_13dd                                                  ; $1404 : $2f, $d7

@br_1406:
    clr1 $47.4                                                  ; $1406 : $92, $47
    mov A, !$025c                                                  ; $1408 : $e5, $5c, $02
    bne @brBigLoop_1454                                                  ; $140b : $d0, $47

    mov A, !$026c                                                  ; $140d : $e5, $6c, $02
    beq @br_145d                                                  ; $1410 : $f0, $4b

    dec !$026c                                                  ; $1412 : $8c, $6c, $02
    cmp A, #$02                                                  ; $1415 : $68, $02
    bne +                                                  ; $1417 : $d0, $04

    set1 w46.4                                                  ; $1419 : $82, $46
    clr1 w49.4                                                  ; $141b : $92, $49

+   bra @brBigLoop_13e2                                                  ; $141d : $2f, $c3

@br_141f:
    clr1 $47.1                                                  ; $141f : $32, $47
    mov A, !$0259                                                  ; $1421 : $e5, $59, $02
    bne @br_1457                                                  ; $1424 : $d0, $31

    mov A, !$0269                                                  ; $1426 : $e5, $69, $02
    beq @br_1460                                                  ; $1429 : $f0, $35

    dec !$0269                                                  ; $142b : $8c, $69, $02
    cmp A, #$02                                                  ; $142e : $68, $02
    bne +                                                  ; $1430 : $d0, $04

    set1 w46.1                                                  ; $1432 : $22, $46
    clr1 w49.1                                                  ; $1434 : $32, $49

+   bra @brBigLoop_13e7                                                  ; $1436 : $2f, $af

@br_1438:
    clr1 $47.0                                                  ; $1438 : $12, $47
    mov A, !$0258                                                  ; $143a : $e5, $58, $02
    bne @br_145a                                                  ; $143d : $d0, $1b

    mov A, !$0268                                                  ; $143f : $e5, $68, $02
    beq @br_1463                                                  ; $1442 : $f0, $1f

    dec !$0268                                                  ; $1444 : $8c, $68, $02
    cmp A, #$02                                                  ; $1447 : $68, $02
    bne +                                                  ; $1449 : $d0, $04

    set1 w46.0                                                  ; $144b : $02, $46
    clr1 w49.0                                                  ; $144d : $12, $49

+   bra @done_13ec                                                  ; $144f : $2f, $9b

@brLoop_1451:
    jmp !@bigBr_1530                                                  ; $1451 : $5f, $30, $15

@brBigLoop_1454:
    jmp !@bigBr_1577                                                  ; $1454 : $5f, $77, $15

@br_1457:
    jmp !@bigBr_15be                                                  ; $1457 : $5f, $be, $15

@br_145a:
    jmp !@bigBr_1605                                                  ; $145a : $5f, $05, $16

@br_145d:
    jmp !@br_149d                                                  ; $145d : $5f, $9d, $14

@br_1460:
    jmp !@br_14ca                                                  ; $1460 : $5f, $ca, $14

@br_1463:
    jmp !@bigBr_1502                                                  ; $1463 : $5f, $02, $15

@bigBr_1466:
    mov X, #$0a                                                  ; $1466 : $cd, $0a
    mov A, !wSndEffectBCopyOfTrack5Ptr                                                  ; $1468 : $e5, $2a, $01
    mov wSndEffectTrackDataPtr, A                                                  ; $146b : $c4, $d2
    mov A, !wSndEffectBCopyOfTrack5Ptr+1                                                  ; $146d : $e5, $2b, $01
    mov wSndEffectTrackDataPtr+1, A                                                  ; $1470 : $c4, $d3
    call !ProcessSndEffectData@start                                                  ; $1472 : $3f, $4f, $16
    cmp A, #$ff                                                  ; $1475 : $68, $ff
    bne @br_1480                                                  ; $1477 : $d0, $07

    mov A, #$05                                                  ; $1479 : $e8, $05
    mov !$025d, A                                                  ; $147b : $c5, $5d, $02
    bra @brLoop_1451                                                  ; $147e : $2f, $d1

@br_1480:
    cmp A, #$fe                                                  ; $1480 : $68, $fe
    bne @br_148d                                                  ; $1482 : $d0, $09

    call !Call_00_1c02                                                  ; $1484 : $3f, $02, $1c
    mov A, !wSoundEffectBIdxForTrack5                                                  ; $1487 : $e5, $65, $02
    jmp !@bigLoop_128d                                                  ; $148a : $5f, $8d, $12

@br_148d:
    cmp A, #$fc                                                  ; $148d : $68, $fc
    bne @br_1497                                                  ; $148f : $d0, $06

    mov A, !wSoundEffectBIdxForTrack5                                                  ; $1491 : $e5, $65, $02
    jmp !@bigLoop_12e8                                                  ; $1494 : $5f, $e8, $12

@br_1497:
    dec !$03ba                                                  ; $1497 : $8c, $ba, $03
    jmp !@bigBrBigLoop_13dd                                                  ; $149a : $5f, $dd, $13

@br_149d:
    mov X, #$08                                                  ; $149d : $cd, $08
    mov A, !wSndEffectBCopyOfTrack4Ptr                                                  ; $149f : $e5, $28, $01
    mov wSndEffectTrackDataPtr, A                                                  ; $14a2 : $c4, $d2
    mov A, !wSndEffectBCopyOfTrack4Ptr+1                                                  ; $14a4 : $e5, $29, $01
    mov wSndEffectTrackDataPtr+1, A                                                  ; $14a7 : $c4, $d3
    call !ProcessSndEffectData@start                                                  ; $14a9 : $3f, $4f, $16
    cmp A, #$ff                                                  ; $14ac : $68, $ff
    bne @br_14b7                                                  ; $14ae : $d0, $07

    mov A, #$05                                                  ; $14b0 : $e8, $05
    mov !$025c, A                                                  ; $14b2 : $c5, $5c, $02
    bra @brBigLoop_1454                                                  ; $14b5 : $2f, $9d

@br_14b7:
    cmp A, #$fe                                                  ; $14b7 : $68, $fe
    bne @br_14c4                                                  ; $14b9 : $d0, $09

    call !Call_00_1c1c                                                  ; $14bb : $3f, $1c, $1c
    mov A, !wSoundEffectBIdxForTrack4                                                  ; $14be : $e5, $64, $02
    jmp !@bigLoop_12e8                                                  ; $14c1 : $5f, $e8, $12

@br_14c4:
    dec !$03b8                                                  ; $14c4 : $8c, $b8, $03
    jmp !@brBigLoop_13e2                                                  ; $14c7 : $5f, $e2, $13

@br_14ca:
    mov X, #$02                                                  ; $14ca : $cd, $02
    mov A, !wSndEffectBCopyOfTrack1Ptr                                                  ; $14cc : $e5, $22, $01
    mov wSndEffectTrackDataPtr, A                                                  ; $14cf : $c4, $d2
    mov A, !wSndEffectBCopyOfTrack1Ptr+1                                                  ; $14d1 : $e5, $23, $01
    mov wSndEffectTrackDataPtr+1, A                                                  ; $14d4 : $c4, $d3
    call !ProcessSndEffectData@start                                                  ; $14d6 : $3f, $4f, $16
    cmp A, #$ff                                                  ; $14d9 : $68, $ff
    bne @br_14e5                                                  ; $14db : $d0, $08

    mov A, #$05                                                  ; $14dd : $e8, $05
    mov !$0259, A                                                  ; $14df : $c5, $59, $02
    jmp !@bigBr_15be                                                  ; $14e2 : $5f, $be, $15

@br_14e5:
    cmp A, #$fe                                                  ; $14e5 : $68, $fe
    bne @br_14f2                                                  ; $14e7 : $d0, $09

    call !Call_00_1c6a                                                  ; $14e9 : $3f, $6a, $1c
    mov A, !wSoundEffectBIdxForTrack1                                                  ; $14ec : $e5, $61, $02
    jmp !@bigLoop_133e                                                  ; $14ef : $5f, $3e, $13

@br_14f2:
    cmp A, #$fc                                                  ; $14f2 : $68, $fc
    bne @br_14fc                                                  ; $14f4 : $d0, $06

    mov A, !wSoundEffectBIdxForTrack1                                                  ; $14f6 : $e5, $61, $02
    jmp !@bigLoop_138f                                                  ; $14f9 : $5f, $8f, $13

@br_14fc:
    dec !$03b2                                                  ; $14fc : $8c, $b2, $03
    jmp !@brBigLoop_13e7                                                  ; $14ff : $5f, $e7, $13

@bigBr_1502:
    mov X, #$00                                                  ; $1502 : $cd, $00
    mov A, !wSndEffectBCopyOfTrack0Ptr                                                  ; $1504 : $e5, $20, $01
    mov wSndEffectTrackDataPtr, A                                                  ; $1507 : $c4, $d2
    mov A, !wSndEffectBCopyOfTrack0Ptr+1                                                  ; $1509 : $e5, $21, $01
    mov wSndEffectTrackDataPtr+1, A                                                  ; $150c : $c4, $d3
    call !ProcessSndEffectData@start                                                  ; $150e : $3f, $4f, $16
    cmp A, #$ff                                                  ; $1511 : $68, $ff
    bne @br_151d                                                  ; $1513 : $d0, $08

    mov A, #$05                                                  ; $1515 : $e8, $05
    mov !$0258, A                                                  ; $1517 : $c5, $58, $02
    jmp !@bigBr_1605                                                  ; $151a : $5f, $05, $16

@br_151d:
    cmp A, #$fe                                                  ; $151d : $68, $fe
    bne @br_152a                                                  ; $151f : $d0, $09

    call !Call_00_1c84                                                  ; $1521 : $3f, $84, $1c
    mov A, !wSoundEffectBIdxForTrack0                                                  ; $1524 : $e5, $60, $02
    jmp !@bigLoop_138f                                                  ; $1527 : $5f, $8f, $13

@br_152a:
    dec !w3b0                                                  ; $152a : $8c, $b0, $03
    jmp !@done_13ec                                                  ; $152d : $5f, $ec, $13

@bigBr_1530:
    mov A, !$025d                                                  ; $1530 : $e5, $5d, $02
    cmp A, #$05                                                  ; $1533 : $68, $05
    bne @cont_1545                                                  ; $1535 : $d0, $0e

    mov A, #$00                                                  ; $1537 : $e8, $00
    mov Y, #$55                                                  ; $1539 : $8d, $55
    call !SetDspAddrDataToYA                                                  ; $153b : $3f, $1d, $06
    mov A, #$9c                                                  ; $153e : $e8, $9c
    mov Y, #$57                                                  ; $1540 : $8d, $57
    call !SetDspAddrDataToYA                                                  ; $1542 : $3f, $1d, $06

@cont_1545:
    dec !$025d                                                  ; $1545 : $8c, $5d, $02
    mov A, !$025d                                                  ; $1548 : $e5, $5d, $02
    cmp A, #$02                                                  ; $154b : $68, $02
    bne @br_155c                                                  ; $154d : $d0, $0d

    set1 w46.5                                                  ; $154f : $a2, $46
    and w4b, #$df                                                  ; $1551 : $38, $df, $4b
    mov Y, #$50                                                  ; $1554 : $8d, $50
    call !Call_00_1b87                                                  ; $1556 : $3f, $87, $1b
    jmp !@bigBrBigLoop_13dd                                                  ; $1559 : $5f, $dd, $13

@br_155c:
    mov A, !$025d                                                  ; $155c : $e5, $5d, $02
    bne @cont_1574                                                  ; $155f : $d0, $13

    mov Y, #$00                                                  ; $1561 : $8d, $00
    mov !wSoundEffectBIdxForTrack5, Y                                                  ; $1563 : $cc, $65, $02
    mov A, !wSoundEffectBIdxForTrack4                                                  ; $1566 : $e5, $64, $02
    or A, !wSoundEffectBIdxForTrack1                                                  ; $1569 : $05, $61, $02
    or A, !wSoundEffectBIdxForTrack0                                                  ; $156c : $05, $60, $02
    bne +                                                  ; $156f : $d0, $00

+   call !Call_00_1bf5                                                  ; $1571 : $3f, $f5, $1b

@cont_1574:
    jmp !@bigBrBigLoop_13dd                                                  ; $1574 : $5f, $dd, $13

@bigBr_1577:
    mov A, !$025c                                                  ; $1577 : $e5, $5c, $02
    cmp A, #$05                                                  ; $157a : $68, $05
    bne @cont_158c                                                  ; $157c : $d0, $0e

    mov A, #$00                                                  ; $157e : $e8, $00
    mov Y, #$45                                                  ; $1580 : $8d, $45
    call !SetDspAddrDataToYA                                                  ; $1582 : $3f, $1d, $06
    mov A, #$9c                                                  ; $1585 : $e8, $9c
    mov Y, #$47                                                  ; $1587 : $8d, $47
    call !SetDspAddrDataToYA                                                  ; $1589 : $3f, $1d, $06

@cont_158c:
    dec !$025c                                                  ; $158c : $8c, $5c, $02
    mov A, !$025c                                                  ; $158f : $e5, $5c, $02
    cmp A, #$02                                                  ; $1592 : $68, $02
    bne @br_15a3                                                  ; $1594 : $d0, $0d

    set1 w46.4                                                  ; $1596 : $82, $46
    and w4b, #$df                                                  ; $1598 : $38, $df, $4b
    mov Y, #$40                                                  ; $159b : $8d, $40
    call !Call_00_1b87                                                  ; $159d : $3f, $87, $1b
    jmp !@done_13ec                                                  ; $15a0 : $5f, $ec, $13

@br_15a3:
    mov A, !$025c                                                  ; $15a3 : $e5, $5c, $02
    bne @cont_15bb                                                  ; $15a6 : $d0, $13

    mov Y, #$00                                                  ; $15a8 : $8d, $00
    mov !wSoundEffectBIdxForTrack4, Y                                                  ; $15aa : $cc, $64, $02
    mov A, !wSoundEffectBIdxForTrack5                                                  ; $15ad : $e5, $65, $02
    or A, !wSoundEffectBIdxForTrack1                                                  ; $15b0 : $05, $61, $02
    or A, !wSoundEffectBIdxForTrack0                                                  ; $15b3 : $05, $60, $02
    bne +                                                  ; $15b6 : $d0, $00

+   call !Call_00_1c0f                                                  ; $15b8 : $3f, $0f, $1c

@cont_15bb:
    jmp !@brBigLoop_13e2                                                  ; $15bb : $5f, $e2, $13

@bigBr_15be:
    mov A, !$0259                                                  ; $15be : $e5, $59, $02
    cmp A, #$05                                                  ; $15c1 : $68, $05
    bne @cont_15d3                                                  ; $15c3 : $d0, $0e

    mov A, #$00                                                  ; $15c5 : $e8, $00
    mov Y, #$15                                                  ; $15c7 : $8d, $15
    call !SetDspAddrDataToYA                                                  ; $15c9 : $3f, $1d, $06
    mov A, #$9c                                                  ; $15cc : $e8, $9c
    mov Y, #$17                                                  ; $15ce : $8d, $17
    call !SetDspAddrDataToYA                                                  ; $15d0 : $3f, $1d, $06

@cont_15d3:
    dec !$0259                                                  ; $15d3 : $8c, $59, $02
    mov A, !$0259                                                  ; $15d6 : $e5, $59, $02
    cmp A, #$02                                                  ; $15d9 : $68, $02
    bne @br_15ea                                                  ; $15db : $d0, $0d

    set1 w46.1                                                  ; $15dd : $22, $46
    and w4b, #$fd                                                  ; $15df : $38, $fd, $4b
    mov Y, #$10                                                  ; $15e2 : $8d, $10
    call !Call_00_1b87                                                  ; $15e4 : $3f, $87, $1b
    jmp !@brBigLoop_13e7                                                  ; $15e7 : $5f, $e7, $13

@br_15ea:
    mov A, !$0259                                                  ; $15ea : $e5, $59, $02
    bne @cont_1602                                                  ; $15ed : $d0, $13

    mov Y, #$00                                                  ; $15ef : $8d, $00
    mov !wSoundEffectBIdxForTrack1, Y                                                  ; $15f1 : $cc, $61, $02
    mov A, !wSoundEffectBIdxForTrack5                                                  ; $15f4 : $e5, $65, $02
    or A, !wSoundEffectBIdxForTrack4                                                  ; $15f7 : $05, $64, $02
    or A, !wSoundEffectBIdxForTrack0                                                  ; $15fa : $05, $60, $02
    bne +                                                  ; $15fd : $d0, $00

+   call !Call_00_1c5d                                                  ; $15ff : $3f, $5d, $1c

@cont_1602:
    jmp !@brBigLoop_13e7                                                  ; $1602 : $5f, $e7, $13

@bigBr_1605:
    mov A, !$0258                                                  ; $1605 : $e5, $58, $02
    cmp A, #$05                                                  ; $1608 : $68, $05
    bne @cont_161a                                                  ; $160a : $d0, $0e

    mov A, #$00                                                  ; $160c : $e8, $00
    mov Y, #$05                                                  ; $160e : $8d, $05
    call !SetDspAddrDataToYA                                                  ; $1610 : $3f, $1d, $06
    mov A, #$9c                                                  ; $1613 : $e8, $9c
    mov Y, #$07                                                  ; $1615 : $8d, $07
    call !SetDspAddrDataToYA                                                  ; $1617 : $3f, $1d, $06

@cont_161a:
    dec !$0258                                                  ; $161a : $8c, $58, $02
    mov A, !$0258                                                  ; $161d : $e5, $58, $02
    cmp A, #$02                                                  ; $1620 : $68, $02
    bne @br_1631                                                  ; $1622 : $d0, $0d

    set1 w46.0                                                  ; $1624 : $02, $46
    and w4b, #$fd                                                  ; $1626 : $38, $fd, $4b
    mov Y, #$00                                                  ; $1629 : $8d, $00
    call !Call_00_1b87                                                  ; $162b : $3f, $87, $1b
    jmp !@done_13ec                                                  ; $162e : $5f, $ec, $13

@br_1631:
    mov A, !$0258                                                  ; $1631 : $e5, $58, $02
    bne @cont_1649                                                  ; $1634 : $d0, $13

    mov Y, #$00                                                  ; $1636 : $8d, $00
    mov !wSoundEffectBIdxForTrack0, Y                                                  ; $1638 : $cc, $60, $02
    mov A, !wSoundEffectBIdxForTrack5                                                  ; $163b : $e5, $65, $02
    or A, !wSoundEffectBIdxForTrack1                                                  ; $163e : $05, $61, $02
    or A, !wSoundEffectBIdxForTrack4                                                  ; $1641 : $05, $64, $02
    bne +                                                  ; $1644 : $d0, $00

+   call !Call_00_1c77                                                  ; $1646 : $3f, $77, $1c

@cont_1649:
    jmp !@done_13ec                                                  ; $1649 : $5f, $ec, $13


ProcessSndEffectData:
@loop_164c:
    jmp !@bigBr_1a0a                                                  ; $164c : $5f, $0a, $1a

@start:
    mov A, !w3b0+X                                                  ; $164f : $f5, $b0, $03
    bne @loop_164c                                                  ; $1652 : $d0, $f8

    @loop_1654:
    ; Get a data byte for the next command
        mov A, !wTrackSndEffectsDataOffset+X                                                  ; $1654 : $f5, $40, $01
        mov Y, A                                                  ; $1657 : $fd
        mov A, [wSndEffectTrackDataPtr]+Y                                                  ; $1658 : $f7, $d2

    ; end when $ff
        cmp A, #$ff                                                  ; $165a : $68, $ff
        bne @br_165f                                                  ; $165c : $d0, $01

        ret                                                  ; $165e : $6f

    @br_165f:
    ; or when $fe
        cmp A, #$fe                                                  ; $165f : $68, $fe
        bne @br_1664                                                  ; $1661 : $d0, $01

        ret                                                  ; $1663 : $6f

    @br_1664:
    ; or if $fc, inc a thing
        cmp A, #$fc                                                  ; $1664 : $68, $fc
        bne @br_166d                                                  ; $1666 : $d0, $05

        setp                                                  ; $1668 : $40
        inc <wTrackSndEffectsDataOffset+X                                                  ; $1669 : $bb, $40
        clrp                                                  ; $166b : $20
        ret                                                  ; $166c : $6f

    @br_166d:
    ; or if $fd, move a var and get a new data byte
        cmp A, #$fd                                                  ; $166d : $68, $fd
        bne @br_1679                                                  ; $166f : $d0, $08

        mov A, !w141+X                                                  ; $1671 : $f5, $41, $01
        mov !wTrackSndEffectsDataOffset+X, A                                                  ; $1674 : $d5, $40, $01
        bra @loop_1654                                                  ; $1677 : $2f, $db

@br_1679:
; store data byte here
    mov !w3b0+X, A                                                  ; $1679 : $d5, $b0, $03

; save return? idx, and inc it
    mov A, !wTrackSndEffectsDataOffset+X                                                  ; $167c : $f5, $40, $01
    mov !w141+X, A                                                  ; $167f : $d5, $41, $01
    inc A                                                  ; $1682 : $bc
    mov !wTrackSndEffectsDataOffset+X, A                                                  ; $1683 : $d5, $40, $01
    mov Y, A                                                  ; $1686 : $fd

; get $1e83:$e0 here
    mov A, [wSndEffectTrackDataPtr]+Y                                                  ; $1687 : $f7, $d2

    @bigLoop_1689:
        cmp A, #$e0                                                  ; $1689 : $68, $e0
        bne @cont_16a4                                                  ; $168b : $d0, $17

    ; $e0: get next byte (instrument), and apply the instrument
        mov A, !wTrackSndEffectsDataOffset+X                                  ; $168d : $f5, $40, $01
        inc A                                                                 ; $1690 : $bc
        mov !wTrackSndEffectsDataOffset+X, A                                  ; $1691 : $d5, $40, $01
        mov Y, A                                                              ; $1694 : $fd
        mov A, [wSndEffectTrackDataPtr]+Y                                     ; $1695 : $f7, $d2
        call !ApplyInstrumentA                                                ; $1697 : $3f, $29, $08

    ; Inc idx into data bytes and check the command for it
        setp                                                                  ; $169a : $40
        inc <wTrackSndEffectsDataOffset+X                                     ; $169b : $bb, $40
        clrp                                                                  ; $169d : $20
        mov A, !wTrackSndEffectsDataOffset+X                                  ; $169e : $f5, $40, $01
        mov Y, A                                                              ; $16a1 : $fd
        mov A, [wSndEffectTrackDataPtr]+Y                                     ; $16a2 : $f7, $d2

    @cont_16a4:
        cmp A, #$e1                                                  ; $16a4 : $68, $e1
        bne @cont_16e9                                                  ; $16a6 : $d0, $41

    ; $e1:
        mov A, #$00                                                  ; $16a8 : $e8, $00
        mov !w3b1+X, A                                                  ; $16aa : $d5, $b1, $03
        setp                                                  ; $16ad : $40
        inc <wTrackSndEffectsDataOffset+X                                                  ; $16ae : $bb, $40
        clrp                                                  ; $16b0 : $20
        mov A, !wTrackSndEffectsDataOffset+X                                                  ; $16b1 : $f5, $40, $01
        mov Y, A                                                  ; $16b4 : $fd
        mov A, [wSndEffectTrackDataPtr]+Y                                                  ; $16b5 : $f7, $d2
        mov Y, A                                                  ; $16b7 : $fd
        mov !wSndEffectB_ADSR1, Y                                                  ; $16b8 : $cc, $76, $02
        mov A, !data_0eb2+Y                                                  ; $16bb : $f6, $b2, $0e
        mov !wSndEffectB_ADSR2, A                                                  ; $16be : $c5, $77, $02
        mov A, !TrackToDspRegBaseAndBitfield+X                                                  ; $16c1 : $f5, $d2, $0e
        mov Y, A                                                  ; $16c4 : $fd
        mov A, !wSndEffectB_ADSR2                                                  ; $16c5 : $e5, $77, $02
        call !SetDspAddrDataToYA                                                  ; $16c8 : $3f, $1d, $06
        mov Y, !wSndEffectB_ADSR1                                                  ; $16cb : $ec, $76, $02
        mov A, !data_0ec2+Y                                                  ; $16ce : $f6, $c2, $0e
        mov !wSndEffectB_ADSR2, A                                                  ; $16d1 : $c5, $77, $02
        mov A, !TrackToDspRegBaseAndBitfield+X                                                  ; $16d4 : $f5, $d2, $0e
        mov Y, A                                                  ; $16d7 : $fd
        inc Y                                                  ; $16d8 : $fc
        mov A, !wSndEffectB_ADSR2                                                  ; $16d9 : $e5, $77, $02
        call !SetDspAddrDataToYA                                                  ; $16dc : $3f, $1d, $06

    ; Inc idx into data bytes and check the command for it
        setp                                                                  ; $16df : $40
        inc <wTrackSndEffectsDataOffset+X                                     ; $16e0 : $bb, $40
        clrp                                                                  ; $16e2 : $20
        mov A, !wTrackSndEffectsDataOffset+X                                  ; $16e3 : $f5, $40, $01
        mov Y, A                                                              ; $16e6 : $fd
        mov A, [wSndEffectTrackDataPtr]+Y                                     ; $16e7 : $f7, $d2

    @cont_16e9:
        cmp A, #$e2                                                  ; $16e9 : $68, $e2
        bne @cont_1723                                                  ; $16eb : $d0, $36

        mov A, #$01                                                  ; $16ed : $e8, $01
        mov !w3b1+X, A                                                  ; $16ef : $d5, $b1, $03
        setp                                                  ; $16f2 : $40
        inc <wTrackSndEffectsDataOffset+X                                                  ; $16f3 : $bb, $40
        clrp                                                  ; $16f5 : $20
        mov A, !wTrackSndEffectsDataOffset+X                                                  ; $16f6 : $f5, $40, $01
        mov Y, A                                                  ; $16f9 : $fd
        mov A, [wSndEffectTrackDataPtr]+Y                                                  ; $16fa : $f7, $d2
        mov !w150+X, A                                                  ; $16fc : $d5, $50, $01
        cmp A, #$7f                                                  ; $16ff : $68, $7f
        bne @br_1707                                                  ; $1701 : $d0, $04

        mov A, #$00                                                  ; $1703 : $e8, $00
        beq +                                                  ; $1705 : $f0, $02

    @br_1707:
        mov A, #$7f                                                  ; $1707 : $e8, $7f

    +   mov !w151+X, A                                                  ; $1709 : $d5, $51, $01
        setp                                                  ; $170c : $40
        inc <wTrackSndEffectsDataOffset+X                                                  ; $170d : $bb, $40
        clrp                                                  ; $170f : $20
        mov A, !wTrackSndEffectsDataOffset+X                                                  ; $1710 : $f5, $40, $01
        mov Y, A                                                  ; $1713 : $fd
        mov A, [wSndEffectTrackDataPtr]+Y                                                  ; $1714 : $f7, $d2
        mov !w160+X, A                                                  ; $1716 : $d5, $60, $01

    ; Inc idx into data bytes and check the command for it
        setp                                                                  ; $1719 : $40
        inc <wTrackSndEffectsDataOffset+X                                     ; $171a : $bb, $40
        clrp                                                                  ; $171c : $20
        mov A, !wTrackSndEffectsDataOffset+X                                  ; $171d : $f5, $40, $01
        mov Y, A                                                              ; $1720 : $fd
        mov A, [wSndEffectTrackDataPtr]+Y                                     ; $1721 : $f7, $d2

    @cont_1723:
        cmp A, #$f5                                                  ; $1723 : $68, $f5
        bne @cont_174f                                                  ; $1725 : $d0, $28

        cmp X, #$0c                                                  ; $1727 : $c8, $0c
        bcc @br_172f                                                  ; $1729 : $90, $04

        mov Y, wSndEffectAttrAvol                                                  ; $172b : $eb, $2d
        bra +                                                  ; $172d : $2f, $02

    @br_172f:
        mov Y, wSndEffectAttrBvol                                                  ; $172f : $eb, $2f

    +   mov A, !data_0ee4+Y                                                  ; $1731 : $f6, $e4, $0e
        mov !wSndEffectB_ADSR1, A                                                  ; $1734 : $c5, $76, $02
        mov A, !TrackToDspRegBaseAndBitfield+X                                                  ; $1737 : $f5, $d2, $0e
        mov Y, A                                                  ; $173a : $fd

    ; set VOL_L and VOL_R
        mov A, !wSndEffectB_ADSR1                                                  ; $173b : $e5, $76, $02
        call !SetDspAddrDataToYA                                                  ; $173e : $3f, $1d, $06
        inc Y                                                  ; $1741 : $fc
        call !SetDspAddrDataToYA                                                  ; $1742 : $3f, $1d, $06

    ; Inc idx into data bytes and check the command for it
        setp                                                                  ; $1745 : $40
        inc <wTrackSndEffectsDataOffset+X                                     ; $1746 : $bb, $40
        clrp                                                                  ; $1748 : $20
        mov A, !wTrackSndEffectsDataOffset+X                                  ; $1749 : $f5, $40, $01
        mov Y, A                                                              ; $174c : $fd
        mov A, [wSndEffectTrackDataPtr]+Y                                     ; $174d : $f7, $d2

    @cont_174f:
        cmp A, #$f2                                                  ; $174f : $68, $f2
        bne @cont_17b8                                                  ; $1751 : $d0, $65

        setp                                                  ; $1753 : $40
        inc <wTrackSndEffectsDataOffset+X                                                  ; $1754 : $bb, $40
        clrp                                                  ; $1756 : $20
        mov A, !wTrackSndEffectsDataOffset+X                                                  ; $1757 : $f5, $40, $01
        mov Y, A                                                  ; $175a : $fd
        mov A, [wSndEffectTrackDataPtr]+Y                                                  ; $175b : $f7, $d2
        mov !w170+X, A                                                  ; $175d : $d5, $70, $01
        setp                                                  ; $1760 : $40
        inc <wTrackSndEffectsDataOffset+X                                                  ; $1761 : $bb, $40
        clrp                                                  ; $1763 : $20
        mov A, !wTrackSndEffectsDataOffset+X                                                  ; $1764 : $f5, $40, $01
        mov Y, A                                                  ; $1767 : $fd
        mov A, [wSndEffectTrackDataPtr]+Y                                                  ; $1768 : $f7, $d2
        mov !w180+X, A                                                  ; $176a : $d5, $80, $01
        setp                                                  ; $176d : $40
        inc <wTrackSndEffectsDataOffset+X                                                  ; $176e : $bb, $40
        clrp                                                  ; $1770 : $20
        mov A, !wTrackSndEffectsDataOffset+X                                                  ; $1771 : $f5, $40, $01
        mov Y, A                                                  ; $1774 : $fd
        mov A, [wSndEffectTrackDataPtr]+Y                                                  ; $1775 : $f7, $d2
        mov !w181+X, A                                                  ; $1777 : $d5, $81, $01
        setp                                                  ; $177a : $40
        inc <wTrackSndEffectsDataOffset+X                                                  ; $177b : $bb, $40
        clrp                                                  ; $177d : $20
        mov A, !wTrackSndEffectsDataOffset+X                                                  ; $177e : $f5, $40, $01
        mov Y, A                                                  ; $1781 : $fd
        mov A, [wSndEffectTrackDataPtr]+Y                                                  ; $1782 : $f7, $d2
        mov !wSndEffectB_ADSR1, A                                                  ; $1784 : $c5, $76, $02
        cmp X, #$0c                                                  ; $1787 : $c8, $0c
        bcc @br_178f                                                  ; $1789 : $90, $04

        mov Y, wSndEffectAttrApitch                                                  ; $178b : $eb, $2c
        bra +                                                  ; $178d : $2f, $02

    @br_178f:
        mov Y, wSndEffectAttrBpitch                                                  ; $178f : $eb, $2e

    +   mov A, !data_0ee8+Y                                                  ; $1791 : $f6, $e8, $0e
        clrc                                                  ; $1794 : $60
        adc A, !wSndEffectB_ADSR1                                                  ; $1795 : $85, $76, $02
        cmp A, #$80                                                  ; $1798 : $68, $80
        bcs @br_17a0                                                  ; $179a : $b0, $04

        mov A, #$80                                                  ; $179c : $e8, $80
        bra @cont_17a6                                                  ; $179e : $2f, $06

    @br_17a0:
        cmp A, #$c8                                                  ; $17a0 : $68, $c8
        bcc @cont_17a6                                                  ; $17a2 : $90, $02

        mov A, #$c7                                                  ; $17a4 : $e8, $c7

    @cont_17a6:
        mov !w171+X, A                                                  ; $17a6 : $d5, $71, $01
        mov A, #$00                                                  ; $17a9 : $e8, $00
        mov !w190+X, A                                                  ; $17ab : $d5, $90, $01

    ; Inc idx into data bytes and check the command for it
        setp                                                                  ; $17ae : $40
        inc <wTrackSndEffectsDataOffset+X                                     ; $17af : $bb, $40
        clrp                                                                  ; $17b1 : $20
        mov A, !wTrackSndEffectsDataOffset+X                                  ; $17b2 : $f5, $40, $01
        mov Y, A                                                              ; $17b5 : $fd
        mov A, [wSndEffectTrackDataPtr]+Y                                     ; $17b6 : $f7, $d2

    @cont_17b8:
        cmp A, #$f3                                                  ; $17b8 : $68, $f3
        bne @cont_17cb                                                  ; $17ba : $d0, $0f

        mov A, #$00                                                  ; $17bc : $e8, $00
        mov !w170+X, A                                                  ; $17be : $d5, $70, $01

    ; Inc idx into data bytes and check the command for it
        setp                                                                  ; $17c1 : $40
        inc <wTrackSndEffectsDataOffset+X                                     ; $17c2 : $bb, $40
        clrp                                                                  ; $17c4 : $20
        mov A, !wTrackSndEffectsDataOffset+X                                  ; $17c5 : $f5, $40, $01
        mov Y, A                                                              ; $17c8 : $fd
        mov A, [wSndEffectTrackDataPtr]+Y                                     ; $17c9 : $f7, $d2

    @cont_17cb:
        cmp A, #$ed                                                  ; $17cb : $68, $ed
        bne @cont_17fc                                                  ; $17cd : $d0, $2d

        setp                                                  ; $17cf : $40
        inc <wTrackSndEffectsDataOffset+X                                                  ; $17d0 : $bb, $40
        clrp                                                  ; $17d2 : $20
        mov A, !wTrackSndEffectsDataOffset+X                                                  ; $17d3 : $f5, $40, $01
        mov Y, A                                                  ; $17d6 : $fd
        mov A, [wSndEffectTrackDataPtr]+Y                                                  ; $17d7 : $f7, $d2
        mov !wSndEffectB_ADSR1, A                                                  ; $17d9 : $c5, $76, $02
        mov A, !TrackToDspRegBaseAndBitfield+X                                                  ; $17dc : $f5, $d2, $0e
        mov Y, A                                                  ; $17df : $fd
        mov !wSndEffectB_ADSR2, X                                                  ; $17e0 : $c9, $77, $02
        mov A, !wSndEffectB_ADSR1                                                  ; $17e3 : $e5, $76, $02
        mov X, A                                                  ; $17e6 : $5d
        inc Y                                                  ; $17e7 : $fc
        inc Y                                                  ; $17e8 : $fc
        inc Y                                                  ; $17e9 : $fc
        inc Y                                                  ; $17ea : $fc
        inc Y                                                  ; $17eb : $fc
        call !Call_00_1b78                                                  ; $17ec : $3f, $78, $1b
        mov X, !wSndEffectB_ADSR2                                                  ; $17ef : $e9, $77, $02

    ; Inc idx into data bytes and check the command for it
        setp                                                                  ; $17f2 : $40
        inc <wTrackSndEffectsDataOffset+X                                     ; $17f3 : $bb, $40
        clrp                                                                  ; $17f5 : $20
        mov A, !wTrackSndEffectsDataOffset+X                                  ; $17f6 : $f5, $40, $01
        mov Y, A                                                              ; $17f9 : $fd
        mov A, [wSndEffectTrackDataPtr]+Y                                     ; $17fa : $f7, $d2

    @cont_17fc:
        cmp A, #$e3                                                  ; $17fc : $68, $e3
        bne @cont_1836                                                  ; $17fe : $d0, $36

        mov A, #$01                                                  ; $1800 : $e8, $01
        mov !w3c0+X, A                                                  ; $1802 : $d5, $c0, $03
        setp                                                  ; $1805 : $40
        inc <wTrackSndEffectsDataOffset+X                                                  ; $1806 : $bb, $40
        clrp                                                  ; $1808 : $20
        mov A, !wTrackSndEffectsDataOffset+X                                                  ; $1809 : $f5, $40, $01
        mov Y, A                                                  ; $180c : $fd
        mov A, [wSndEffectTrackDataPtr]+Y                                                  ; $180d : $f7, $d2
        mov !w1b0+X, A                                                  ; $180f : $d5, $b0, $01
        setp                                                  ; $1812 : $40
        inc <wTrackSndEffectsDataOffset+X                                                  ; $1813 : $bb, $40
        clrp                                                  ; $1815 : $20
        mov A, !wTrackSndEffectsDataOffset+X                                                  ; $1816 : $f5, $40, $01
        mov Y, A                                                  ; $1819 : $fd
        mov A, [wSndEffectTrackDataPtr]+Y                                                  ; $181a : $f7, $d2
        mov !w1b1+X, A                                                  ; $181c : $d5, $b1, $01
        setp                                                  ; $181f : $40
        inc <wTrackSndEffectsDataOffset+X                                                  ; $1820 : $bb, $40
        clrp                                                  ; $1822 : $20
        mov A, !wTrackSndEffectsDataOffset+X                                                  ; $1823 : $f5, $40, $01
        mov Y, A                                                  ; $1826 : $fd
        mov A, [wSndEffectTrackDataPtr]+Y                                                  ; $1827 : $f7, $d2
        mov !w130+X, A                                                  ; $1829 : $d5, $30, $01

    ; Inc idx into data bytes and check the command for it
        setp                                                                  ; $182c : $40
        inc <wTrackSndEffectsDataOffset+X                                     ; $182d : $bb, $40
        clrp                                                                  ; $182f : $20
        mov A, !wTrackSndEffectsDataOffset+X                                  ; $1830 : $f5, $40, $01
        mov Y, A                                                              ; $1833 : $fd
        mov A, [wSndEffectTrackDataPtr]+Y                                     ; $1834 : $f7, $d2

    @cont_1836:
        cmp A, #$e4                                                  ; $1836 : $68, $e4
        bne @cont_1849                                                  ; $1838 : $d0, $0f

        mov A, #$00                                                  ; $183a : $e8, $00
        mov !w3c0+X, A                                                  ; $183c : $d5, $c0, $03

    ; Inc idx into data bytes and check the command for it
        setp                                                                  ; $183f : $40
        inc <wTrackSndEffectsDataOffset+X                                     ; $1840 : $bb, $40
        clrp                                                                  ; $1842 : $20
        mov A, !wTrackSndEffectsDataOffset+X                                  ; $1843 : $f5, $40, $01
        mov Y, A                                                              ; $1846 : $fd
        mov A, [wSndEffectTrackDataPtr]+Y                                     ; $1847 : $f7, $d2

    @cont_1849:
        cmp A, #$f8                                                  ; $1849 : $68, $f8
        bne @cont_185e                                                  ; $184b : $d0, $11

    ; get eg $40 and or into $45
        mov A, !TrackToDspRegBaseAndBitfield+1+X                                                  ; $184d : $f5, $d3, $0e
        or A, w45                                                  ; $1850 : $04, $45
        mov w45, A                                                  ; $1852 : $c4, $45
    
    ; Inc idx into data bytes and check the command for it
        setp                                                                  ; $1854 : $40
        inc <wTrackSndEffectsDataOffset+X                                     ; $1855 : $bb, $40
        clrp                                                                  ; $1857 : $20
        mov A, !wTrackSndEffectsDataOffset+X                                  ; $1858 : $f5, $40, $01
        mov Y, A                                                              ; $185b : $fd
        mov A, [wSndEffectTrackDataPtr]+Y                                     ; $185c : $f7, $d2

    @cont_185e:
        cmp A, #$f9                                                  ; $185e : $68, $f9
        bne @cont_1873                                                  ; $1860 : $d0, $11

    ; eg $46 |= $40
        mov A, !TrackToDspRegBaseAndBitfield+1+X                                                  ; $1862 : $f5, $d3, $0e
        or A, w46                                                  ; $1865 : $04, $46
        mov w46, A                                                  ; $1867 : $c4, $46

    ; Inc idx into data bytes and check the command for it
        setp                                                                  ; $1869 : $40
        inc <wTrackSndEffectsDataOffset+X                                     ; $186a : $bb, $40
        clrp                                                                  ; $186c : $20
        mov A, !wTrackSndEffectsDataOffset+X                                  ; $186d : $f5, $40, $01
        mov Y, A                                                              ; $1870 : $fd
        mov A, [wSndEffectTrackDataPtr]+Y                                     ; $1871 : $f7, $d2

    @cont_1873:
        cmp A, #$f6                                                  ; $1873 : $68, $f6
        bne @cont_1895                                                  ; $1875 : $d0, $1e

        mov A, !$0ed5+X                                                  ; $1877 : $f5, $d5, $0e
        or A, w4b                                                  ; $187a : $04, $4b
        mov w4b, A                                                  ; $187c : $c4, $4b
        mov A, !TrackToDspRegBaseAndBitfield+X                                                  ; $187e : $f5, $d2, $0e
        mov Y, A                                                  ; $1881 : $fd
        mov A, #$00                                                  ; $1882 : $e8, $00
        call !SetDspAddrDataToYA                                                  ; $1884 : $3f, $1d, $06
        inc Y                                                  ; $1887 : $fc
        call !SetDspAddrDataToYA                                                  ; $1888 : $3f, $1d, $06

    ; Inc idx into data bytes and check the command for it
        setp                                                                  ; $188b : $40
        inc <wTrackSndEffectsDataOffset+X                                     ; $188c : $bb, $40
        clrp                                                                  ; $188e : $20
        mov A, !wTrackSndEffectsDataOffset+X                                  ; $188f : $f5, $40, $01
        mov Y, A                                                              ; $1892 : $fd
        mov A, [wSndEffectTrackDataPtr]+Y                                     ; $1893 : $f7, $d2

    @cont_1895:
        cmp A, #$f7                                                  ; $1895 : $68, $f7
        bne @cont_18aa                                                  ; $1897 : $d0, $11

        mov A, !$0ed5+X                                                  ; $1899 : $f5, $d5, $0e
        eor A, w4b                                                  ; $189c : $44, $4b
        mov w4b, A                                                  ; $189e : $c4, $4b

    ; Inc idx into data bytes and check the command for it
        setp                                                                  ; $18a0 : $40
        inc <wTrackSndEffectsDataOffset+X                                     ; $18a1 : $bb, $40
        clrp                                                                  ; $18a3 : $20
        mov A, !wTrackSndEffectsDataOffset+X                                  ; $18a4 : $f5, $40, $01
        mov Y, A                                                              ; $18a7 : $fd
        mov A, [wSndEffectTrackDataPtr]+Y                                     ; $18a8 : $f7, $d2

    @cont_18aa:
        cmp A, #$fa                                                  ; $18aa : $68, $fa
        bne @cont_18c6                                                  ; $18ac : $d0, $18

        mov A, !TrackToDspRegBaseAndBitfield+1+X                                                  ; $18ae : $f5, $d3, $0e
        or A, w4a                                                  ; $18b1 : $04, $4a
        mov w4a, A                                                  ; $18b3 : $c4, $4a
        mov A, !TrackToDspRegBaseAndBitfield+1+X                                                  ; $18b5 : $f5, $d3, $0e
        or A, wd7                                                  ; $18b8 : $04, $d7
        mov wd7, A                                                  ; $18ba : $c4, $d7

    ; Inc idx into data bytes and check the command for it
        setp                                                                  ; $18bc : $40
        inc <wTrackSndEffectsDataOffset+X                                     ; $18bd : $bb, $40
        clrp                                                                  ; $18bf : $20
        mov A, !wTrackSndEffectsDataOffset+X                                  ; $18c0 : $f5, $40, $01
        mov Y, A                                                              ; $18c3 : $fd
        mov A, [wSndEffectTrackDataPtr]+Y                                     ; $18c4 : $f7, $d2

    @cont_18c6:
        cmp A, #$fb                                                  ; $18c6 : $68, $fb
        bne @cont_18f4                                                  ; $18c8 : $d0, $2a

        mov A, !TrackToDspRegBaseAndBitfield+1+X                                                  ; $18ca : $f5, $d3, $0e
        eor A, #$ff                                                  ; $18cd : $48, $ff
        and A, w4a                                                  ; $18cf : $24, $4a
        mov w4a, A                                                  ; $18d1 : $c4, $4a
        mov A, !TrackToDspRegBaseAndBitfield+1+X                                                  ; $18d3 : $f5, $d3, $0e
        eor A, #$ff                                                  ; $18d6 : $48, $ff
        and A, wd7                                                  ; $18d8 : $24, $d7
        mov wd7, A                                                  ; $18da : $c4, $d7
        mov A, wd7                                                  ; $18dc : $e4, $d7
        bne @cont_18ea                                                  ; $18de : $d0, $0a

        mov A, wd4                                                  ; $18e0 : $e4, $d4
        bne @cont_18ea                                                  ; $18e2 : $d0, $06

        mov A, #$00                                                  ; $18e4 : $e8, $00
        mov wEchoVolL+1, A                                                  ; $18e6 : $c4, $61
        mov wEchoVolR+1, A                                                  ; $18e8 : $c4, $63

    @cont_18ea:
    ; Inc idx into data bytes and check the command for it
        setp                                                                  ; $18ea : $40
        inc <wTrackSndEffectsDataOffset+X                                     ; $18eb : $bb, $40
        clrp                                                                  ; $18ed : $20
        mov A, !wTrackSndEffectsDataOffset+X                                  ; $18ee : $f5, $40, $01
        mov Y, A                                                              ; $18f1 : $fd
        mov A, [wSndEffectTrackDataPtr]+Y                                     ; $18f2 : $f7, $d2

    @cont_18f4:
    ; $ee: ADSR1 and ADSR2
        cmp A, #$ee                                                           ; $18f4 : $68, $ee
        bne @notEEh                                                           ; $18f6 : $d0, $3a

    ; Next data byte is ADSR1
        setp                                                                  ; $18f8 : $40
        inc <wTrackSndEffectsDataOffset+X                                     ; $18f9 : $bb, $40
        clrp                                                                  ; $18fb : $20
        mov A, !wTrackSndEffectsDataOffset+X                                  ; $18fc : $f5, $40, $01
        mov Y, A                                                              ; $18ff : $fd
        mov A, [wSndEffectTrackDataPtr]+Y                                     ; $1900 : $f7, $d2
        mov !wSndEffectB_ADSR1, A                                             ; $1902 : $c5, $76, $02
    
    ; Next data byte is ADS2
        setp                                                                  ; $1905 : $40
        inc <wTrackSndEffectsDataOffset+X                                     ; $1906 : $bb, $40
        clrp                                                                  ; $1908 : $20
        mov A, !wTrackSndEffectsDataOffset+X                                  ; $1909 : $f5, $40, $01
        mov Y, A                                                              ; $190c : $fd
        mov A, [wSndEffectTrackDataPtr]+Y                                     ; $190d : $f7, $d2
        mov !wSndEffectB_ADSR2, A                                             ; $190f : $c5, $77, $02
    
    ;
        mov A, !TrackToDspRegBaseAndBitfield+X                                         ; $1912 : $f5, $d2, $0e
        mov Y, A                                                     ; $1915 : $fd

    ; Set DSP reg x5 (adsr1)
        mov A, !wSndEffectB_ADSR1                                             ; $1916 : $e5, $76, $02
        inc Y                                                                 ; $1919 : $fc
        inc Y                                                                 ; $191a : $fc
        inc Y                                                                 ; $191b : $fc
        inc Y                                                                 ; $191c : $fc
        inc Y                                                                 ; $191d : $fc
        call !SetDspAddrDataToYA                                              ; $191e : $3f, $1d, $06
    
    ; Set DSP reg x6 (adsr2)
        inc Y                                                                 ; $1921 : $fc
        mov A, !wSndEffectB_ADSR2                                             ; $1922 : $e5, $77, $02
        call !SetDspAddrDataToYA                                              ; $1925 : $3f, $1d, $06
    
    ; Inc idx into data bytes and check the command for it
        setp                                                                  ; $1928 : $40
        inc <wTrackSndEffectsDataOffset+X                                     ; $1929 : $bb, $40
        clrp                                                                  ; $192b : $20
        mov A, !wTrackSndEffectsDataOffset+X                                  ; $192c : $f5, $40, $01
        mov Y, A                                                              ; $192f : $fd
        mov A, [wSndEffectTrackDataPtr]+Y                                     ; $1930 : $f7, $d2

    @notEEh:
    ; $ef: VOL_L and VOL_R
        cmp A, #$ef                                                           ; $1932 : $68, $ef
        bne @notEFh                                                           ; $1934 : $d0, $35

    ; Next data byte is VOL_L
        setp                                                                  ; $1936 : $40
        inc <wTrackSndEffectsDataOffset+X                                     ; $1937 : $bb, $40
        clrp                                                                  ; $1939 : $20
        mov A, !wTrackSndEffectsDataOffset+X                                  ; $193a : $f5, $40, $01
        mov Y, A                                                              ; $193d : $fd
        mov A, [wSndEffectTrackDataPtr]+Y                                     ; $193e : $f7, $d2
        mov !wSndEffectB_VOL_L, A                                             ; $1940 : $c5, $76, $02

    ; Next data byte is VOL_R
        setp                                                                  ; $1943 : $40
        inc <wTrackSndEffectsDataOffset+X                                     ; $1944 : $bb, $40
        clrp                                                                  ; $1946 : $20
        mov A, !wTrackSndEffectsDataOffset+X                                  ; $1947 : $f5, $40, $01
        mov Y, A                                                              ; $194a : $fd
        mov A, [wSndEffectTrackDataPtr]+Y                                     ; $194b : $f7, $d2
        mov !wSndEffectB_VOL_R, A                                             ; $194d : $c5, $77, $02

    ; Set DSP reg x0 (vol L)
        mov A, !TrackToDspRegBaseAndBitfield+X                                                   ; $1950 : $f5, $d2, $0e
        mov Y, A                                                              ; $1953 : $fd
        mov A, !wSndEffectB_VOL_L                                             ; $1954 : $e5, $76, $02
        call !SetDspAddrDataToYA                                              ; $1957 : $3f, $1d, $06

    ; Set DSP reg x1 (vol R)
        inc Y                                                                 ; $195a : $fc
        mov A, !wSndEffectB_VOL_R                                             ; $195b : $e5, $77, $02
        call !SetDspAddrDataToYA                                              ; $195e : $3f, $1d, $06

    ; Inc idx into data bytes and check the command for it
        setp                                                                  ; $1961 : $40
        inc <wTrackSndEffectsDataOffset+X                                     ; $1962 : $bb, $40
        clrp                                                                  ; $1964 : $20
        mov A, !wTrackSndEffectsDataOffset+X                                  ; $1965 : $f5, $40, $01
        mov Y, A                                                              ; $1968 : $fd
        mov A, [wSndEffectTrackDataPtr]+Y                                     ; $1969 : $f7, $d2

    @notEFh:
        cmp A, #$e5                                                  ; $196b : $68, $e5
        bne @cont_19af                                                  ; $196d : $d0, $40

        mov A, #$00                                                  ; $196f : $e8, $00
        call !ApplyInstrumentA                                                  ; $1971 : $3f, $29, $08
        mov A, !TrackToDspRegBaseAndBitfield+1+X                                                  ; $1974 : $f5, $d3, $0e
        tset1 !w49                                                  ; $1977 : $0e, $49, $00
        setp                                                  ; $197a : $40
        inc <wTrackSndEffectsDataOffset+X                                                  ; $197b : $bb, $40
        clrp                                                  ; $197d : $20
        mov A, !wTrackSndEffectsDataOffset+X                                                  ; $197e : $f5, $40, $01
        mov Y, A                                                  ; $1981 : $fd
        mov A, [wSndEffectTrackDataPtr]+Y                                                  ; $1982 : $f7, $d2
        mov !wSndEffectB_ADSR1, A                                                  ; $1984 : $c5, $76, $02
        cmp X, #$0c                                                  ; $1987 : $c8, $0c
        bcc @br_198f                                                  ; $1989 : $90, $04

        mov Y, wSndEffectAttrApitch                                                  ; $198b : $eb, $2c
        bra +                                                  ; $198d : $2f, $02

    @br_198f:
        mov Y, wSndEffectAttrBpitch                                                  ; $198f : $eb, $2e

    +   mov A, !data_0eec+Y                                                  ; $1991 : $f6, $ec, $0e
        clrc                                                  ; $1994 : $60
        adc A, !wSndEffectB_ADSR1                                                  ; $1995 : $85, $76, $02
        cmp A, #$1b                                                  ; $1998 : $68, $1b
        bcc +                                                  ; $199a : $90, $02
        mov A, #$1a                                                  ; $199c : $e8, $1a
    +   and wDSPflags, #FLGF_RESET|FLGF_MUTE|FLGF_ECHO_DISABLE                                                  ; $199e : $38, $e0, $48
        or A, wDSPflags                                                  ; $19a1 : $04, $48
        mov wDSPflags, A                                                  ; $19a3 : $c4, $48

    ; Inc idx into data bytes and check the command for it
        setp                                                                  ; $19a5 : $40
        inc <wTrackSndEffectsDataOffset+X                                     ; $19a6 : $bb, $40
        clrp                                                                  ; $19a8 : $20
        mov A, !wTrackSndEffectsDataOffset+X                                  ; $19a9 : $f5, $40, $01
        mov Y, A                                                              ; $19ac : $fd
        mov A, [wSndEffectTrackDataPtr]+Y                                     ; $19ad : $f7, $d2

    @cont_19af:
        cmp A, #$80                                                  ; $19af : $68, $80
        bcc @cont_1a00                                                  ; $19b1 : $90, $4d

        cmp A, #$e0                                                  ; $19b3 : $68, $e0
        bcc @br_19ba                                                  ; $19b5 : $90, $03

        jmp !@bigLoop_1689                                                  ; $19b7 : $5f, $89, $16

@br_19ba:
; eg $a9
    mov !wSndEffectB_ADSR1, A                                                  ; $19ba : $c5, $76, $02
    cmp X, #$0c                                                  ; $19bd : $c8, $0c
    bcc @br_19c5                                                  ; $19bf : $90, $04

    mov Y, wSndEffectAttrApitch                                                  ; $19c1 : $eb, $2c
    bra +                                                  ; $19c3 : $2f, $02

@br_19c5:
    mov Y, wSndEffectAttrBpitch                                                  ; $19c5 : $eb, $2e

+   mov A, !data_0ee8+Y                                                  ; $19c7 : $f6, $e8, $0e
    clrc                                                  ; $19ca : $60
    adc A, !wSndEffectB_ADSR1                                                  ; $19cb : $85, $76, $02
    cmp A, #$80                                                  ; $19ce : $68, $80
    bcs @br_19d6                                                  ; $19d0 : $b0, $04

    mov A, #$80                                                  ; $19d2 : $e8, $80
    bra @cont_19dc                                                  ; $19d4 : $2f, $06

@br_19d6:
    cmp A, #$c8                                                  ; $19d6 : $68, $c8
    bcc @cont_19dc                                                  ; $19d8 : $90, $02

    mov A, #$c7                                                  ; $19da : $e8, $c7

@cont_19dc:
    cmp A, #$80                                                  ; $19dc : $68, $80
    bne @br_19f7                                                  ; $19de : $d0, $17

    mov !w1a0+X, A                                                  ; $19e0 : $d5, $a0, $01
    mov A, #$01                                                  ; $19e3 : $e8, $01
    mov !wSndEffectB_ADSR1, A                                                  ; $19e5 : $c5, $76, $02
    mov A, !TrackToDspRegBaseAndBitfield+X                                                  ; $19e8 : $f5, $d2, $0e
    mov Y, A                                                  ; $19eb : $fd
    mov A, !wSndEffectB_ADSR1                                                  ; $19ec : $e5, $76, $02
    inc Y                                                  ; $19ef : $fc
    inc Y                                                  ; $19f0 : $fc
    inc Y                                                  ; $19f1 : $fc
    call !Call_00_1b6e                                                  ; $19f2 : $3f, $6e, $1b
    bra @cont_1a00                                                  ; $19f5 : $2f, $09

@br_19f7:
    mov !w1a0+X, A                                                  ; $19f7 : $d5, $a0, $01
    mov Y, A                                                  ; $19fa : $fd
    mov A, #$00                                                  ; $19fb : $e8, $00
    call !PlayNoteYA                                                  ; $19fd : $3f, $68, $1b

@cont_1a00:
; Inc idx into data bytes and check the command for it
    setp                                                                      ; $1a00 : $40
    inc <wTrackSndEffectsDataOffset+X                                         ; $1a01 : $bb, $40
    clrp                                                                      ; $1a03 : $20
    mov A, !wTrackSndEffectsDataOffset+X                                      ; $1a04 : $f5, $40, $01
    mov Y, A                                                                  ; $1a07 : $fd
    mov A, [wSndEffectTrackDataPtr]+Y                                         ; $1a08 : $f7, $d2

@bigBr_1a0a:
    mov A, !w3c0+X                                                  ; $1a0a : $f5, $c0, $03
    beq +                                                  ; $1a0d : $f0, $03
    call !Call_00_1a6e                                                  ; $1a0f : $3f, $6e, $1a
+   mov A, !w3b1+X                                                  ; $1a12 : $f5, $b1, $03
    beq @cont_1a3c                                                  ; $1a15 : $f0, $25

    mov A, !w161+X                                                  ; $1a17 : $f5, $61, $01
    bne @cont_1a38                                                  ; $1a1a : $d0, $1c

    mov A, !w160+X                                                  ; $1a1c : $f5, $60, $01
    mov !w161+X, A                                                  ; $1a1f : $d5, $61, $01
    setp                                                  ; $1a22 : $40
    call !Call_00_1b2d                                                  ; $1a23 : $3f, $2d, $1b
    clrp                                                  ; $1a26 : $20
    mov A, !TrackToDspRegBaseAndBitfield+X                                                  ; $1a27 : $f5, $d2, $0e
    mov Y, A                                                  ; $1a2a : $fd
    mov A, !w150+X                                                  ; $1a2b : $f5, $50, $01
    call !SetDspAddrDataToYA                                                  ; $1a2e : $3f, $1d, $06
    inc Y                                                  ; $1a31 : $fc
    mov A, !w151+X                                                  ; $1a32 : $f5, $51, $01
    call !SetDspAddrDataToYA                                                  ; $1a35 : $3f, $1d, $06

@cont_1a38:
    setp                                                  ; $1a38 : $40
    dec <w161+X                                                  ; $1a39 : $9b, $61
    clrp                                                  ; $1a3b : $20

@cont_1a3c:
    mov A, !w170+X                                                  ; $1a3c : $f5, $70, $01
    beq @ret0                                                  ; $1a3f : $f0, $2a

    setp                                                  ; $1a41 : $40
    call !Call_00_1add                                                  ; $1a42 : $3f, $dd, $1a
    clrp                                                  ; $1a45 : $20
    mov A, !w171+X                                                  ; $1a46 : $f5, $71, $01
    cmp A, #$80                                                  ; $1a49 : $68, $80
    bne @br_1a61                                                  ; $1a4b : $d0, $14

    mov A, #$01                                                  ; $1a4d : $e8, $01
    mov !wSndEffectB_ADSR1, A                                                  ; $1a4f : $c5, $76, $02
    mov A, !TrackToDspRegBaseAndBitfield+X                                                  ; $1a52 : $f5, $d2, $0e
    mov Y, A                                                  ; $1a55 : $fd
    mov A, !wSndEffectB_ADSR1                                                  ; $1a56 : $e5, $76, $02
    inc Y                                                  ; $1a59 : $fc
    inc Y                                                  ; $1a5a : $fc
    inc Y                                                  ; $1a5b : $fc
    call !Call_00_1b6e                                                  ; $1a5c : $3f, $6e, $1b
    bra @ret0                                                  ; $1a5f : $2f, $0a

@br_1a61:
    mov A, !w171+X                                                  ; $1a61 : $f5, $71, $01
    mov Y, A                                                  ; $1a64 : $fd
    mov A, !w190+X                                                  ; $1a65 : $f5, $90, $01
    call !PlayNoteYA                                                  ; $1a68 : $3f, $68, $1b

@ret0:
    mov A, #$00                                                  ; $1a6b : $e8, $00
    ret                                                  ; $1a6d : $6f


Call_00_1a6e:
    mov A, !w131+X                                                  ; $1a6e : $f5, $31, $01
    bne br_00_1ad5                                                  ; $1a71 : $d0, $62

    mov A, !w130+X                                                  ; $1a73 : $f5, $30, $01
    mov !w131+X, A                                                  ; $1a76 : $d5, $31, $01
    mov A, !w191+X                                                  ; $1a79 : $f5, $91, $01
    inc A                                                  ; $1a7c : $bc
    mov !w191+X, A                                                  ; $1a7d : $d5, $91, $01
    mov A, !w191+X                                                  ; $1a80 : $f5, $91, $01
    lsr A                                                  ; $1a83 : $5c
    bcs br_00_1aab                                                  ; $1a84 : $b0, $25

    mov A, !w1a0+X                                                  ; $1a86 : $f5, $a0, $01
    mov !w1a1+X, A                                                  ; $1a89 : $d5, $a1, $01
    cmp A, #$80                                                  ; $1a8c : $68, $80
    beq br_00_1ad5                                                  ; $1a8e : $f0, $45

    mov A, #$00                                                  ; $1a90 : $e8, $00
    setc                                                  ; $1a92 : $80
    sbc A, !w1b0+X                                                  ; $1a93 : $b5, $b0, $01
    mov !wSndEffectB_ADSR1, A                                                  ; $1a96 : $c5, $76, $02
    bcs br_00_1aa2                                                  ; $1a99 : $b0, $07

    mov A, !w1a1+X                                                  ; $1a9b : $f5, $a1, $01
    dec A                                                  ; $1a9e : $9c
    mov !w1a1+X, A                                                  ; $1a9f : $d5, $a1, $01

br_00_1aa2:
    mov A, !w1a1+X                                                  ; $1aa2 : $f5, $a1, $01
    setc                                                  ; $1aa5 : $80
    sbc A, !w1b1+X                                                  ; $1aa6 : $b5, $b1, $01
    bra br_00_1ace                                                  ; $1aa9 : $2f, $23

br_00_1aab:
    mov A, !w1a0+X                                                  ; $1aab : $f5, $a0, $01
    mov !w1a1+X, A                                                  ; $1aae : $d5, $a1, $01
    cmp A, #$80                                                  ; $1ab1 : $68, $80
    beq br_00_1ad5                                                  ; $1ab3 : $f0, $20

    mov A, #$00                                                  ; $1ab5 : $e8, $00
    clrc                                                  ; $1ab7 : $60
    adc A, !w1b0+X                                                  ; $1ab8 : $95, $b0, $01
    mov !wSndEffectB_ADSR1, A                                                  ; $1abb : $c5, $76, $02
    bcc br_00_1ac7                                                  ; $1abe : $90, $07

    mov A, !w1a1+X                                                  ; $1ac0 : $f5, $a1, $01
    inc A                                                  ; $1ac3 : $bc
    mov !w1a1+X, A                                                  ; $1ac4 : $d5, $a1, $01

br_00_1ac7:
    mov A, !w1a1+X                                                  ; $1ac7 : $f5, $a1, $01
    clrc                                                  ; $1aca : $60
    adc A, !w1b1+X                                                  ; $1acb : $95, $b1, $01

br_00_1ace:
    mov Y, A                                                  ; $1ace : $fd
    mov A, !wSndEffectB_ADSR1                                                  ; $1acf : $e5, $76, $02
    call !PlayNoteYA                                                  ; $1ad2 : $3f, $68, $1b

br_00_1ad5:
    mov A, !w131+X                                                  ; $1ad5 : $f5, $31, $01
    dec A                                                  ; $1ad8 : $9c
    mov !w131+X, A                                                  ; $1ad9 : $d5, $31, $01
    ret                                                  ; $1adc : $6f


; DP - page 1
Call_00_1add:
    mov A, <w170+X                                                  ; $1add : $f4, $70
    cmp A, #$02                                                  ; $1adf : $68, $02
    beq @br_1b0a                                                  ; $1ae1 : $f0, $27

    mov A, <w180+X                                                  ; $1ae3 : $f4, $80
    clrc                                                  ; $1ae5 : $60
    adc A, <w190+X                                                  ; $1ae6 : $94, $90
    mov <w190+X,A                                                  ; $1ae8 : $d4, $90
    bcc @cont_1afa                                                  ; $1aea : $90, $0e

    mov A, <w171+X                                                  ; $1aec : $f4, $71
    cmp A, #$c6                                                  ; $1aee : $68, $c6
    bcs @br_1af6                                                  ; $1af0 : $b0, $04

    inc <w171+X                                                  ; $1af2 : $bb, $71
    bra @cont_1afa                                                  ; $1af4 : $2f, $04

@br_1af6:
    mov A, #$00                                                  ; $1af6 : $e8, $00
    mov <w190+X,A                                                  ; $1af8 : $d4, $90

@cont_1afa:
    mov A, <w181+X                                                  ; $1afa : $f4, $81
    beq @done_0                                                  ; $1afc : $f0, $0b

@loop_1afe:
    mov Y, <w171+X                                                  ; $1afe : $fb, $71
    cmp Y, #$c6                                                  ; $1b00 : $ad, $c6
    bcs +                                                  ; $1b02 : $b0, $02
    inc <w171+X                                                  ; $1b04 : $bb, $71
+   dec A                                                  ; $1b06 : $9c
    bne @loop_1afe                                                  ; $1b07 : $d0, $f5

@done_0:
    ret                                                  ; $1b09 : $6f

@br_1b0a:
    mov A, <w190+X                                                  ; $1b0a : $f4, $90
    setc                                                  ; $1b0c : $80
    sbc A, <w180+X                                                  ; $1b0d : $b4, $80
    mov <w190+X,A                                                  ; $1b0f : $d4, $90
    bcs @cont_1b1f                                                  ; $1b11 : $b0, $0c

    mov A, <w171+X                                                  ; $1b13 : $f4, $71
    beq @br_1b1b                                                  ; $1b15 : $f0, $04

    dec <w171+X                                                  ; $1b17 : $9b, $71
    bra @cont_1b1f                                                  ; $1b19 : $2f, $04

@br_1b1b:
    mov A, #$00                                                  ; $1b1b : $e8, $00
    mov <w190+X,A                                                  ; $1b1d : $d4, $90

@cont_1b1f:
    mov A, <w181+X                                                  ; $1b1f : $f4, $81
    beq @done_1                                                  ; $1b21 : $f0, $09

@loop_1b23:
    mov Y, <w171+X                                                  ; $1b23 : $fb, $71
    beq +                                                  ; $1b25 : $f0, $02
    dec <w171+X                                                  ; $1b27 : $9b, $71
+   dec A                                                  ; $1b29 : $9c
    bne @loop_1b23                                                  ; $1b2a : $d0, $f7

@done_1:
    ret                                                  ; $1b2c : $6f


; DP - page 1
Call_00_1b2d:
    mov A, <w150+X                                                  ; $1b2d : $f4, $50
    beq @br_1b3e                                                  ; $1b2f : $f0, $0d

    cmp A, #$7f                                                  ; $1b31 : $68, $7f
    bne @br_1b43                                                  ; $1b33 : $d0, $0e

    mov A, #$00                                                  ; $1b35 : $e8, $00
    mov !w3a0+X, A                                                  ; $1b37 : $d5, $a0, $03

@loop_1b3a:
    dec <w150+X                                                  ; $1b3a : $9b, $50
    bra @cont_1b4a                                                  ; $1b3c : $2f, $0c

@br_1b3e:
    mov A, #$01                                                  ; $1b3e : $e8, $01
    mov !w3a0+X, A                                                  ; $1b40 : $d5, $a0, $03

@br_1b43:
    mov A, !w3a0+X                                                  ; $1b43 : $f5, $a0, $03
    beq @loop_1b3a                                                  ; $1b46 : $f0, $f2

    inc <w150+X                                                  ; $1b48 : $bb, $50

@cont_1b4a:
    mov A, <w151+X                                                  ; $1b4a : $f4, $51
    beq @br_1b5b                                                  ; $1b4c : $f0, $0d

    cmp A, #$7f                                                  ; $1b4e : $68, $7f
    bne @br_1b60                                                  ; $1b50 : $d0, $0e

    mov A, #$00                                                  ; $1b52 : $e8, $00
    mov !w3a1+X, A                                                  ; $1b54 : $d5, $a1, $03

@loop_1b57:
    dec <w151+X                                                  ; $1b57 : $9b, $51
    bra @done                                                  ; $1b59 : $2f, $0c

@br_1b5b:
    mov A, #$01                                                  ; $1b5b : $e8, $01
    mov !w3a1+X, A                                                  ; $1b5d : $d5, $a1, $03

@br_1b60:
    mov A, !w3a1+X                                                  ; $1b60 : $f5, $a1, $03
    beq @loop_1b57                                                  ; $1b63 : $f0, $f2

    inc <w151+X                                                  ; $1b65 : $bb, $51

@done:
    ret                                                  ; $1b67 : $6f


PlayNoteYA:
    movw wZpNoteAfterTransposeTuning, YA                                      ; $1b68 : $da, $10
    call !HandleVCMDBetween80hAndDFh@playNote                                 ; $1b6a : $3f, $a8, $05
    ret                                                                       ; $1b6d : $6f


Call_00_1b6e:
    call !SetDspAddrDataToYA                                                  ; $1b6e : $3f, $1d, $06
    dec Y                                                  ; $1b71 : $dc
    mov A, #$00                                                  ; $1b72 : $e8, $00
    call !SetDspAddrDataToYA                                                  ; $1b74 : $3f, $1d, $06
    ret                                                  ; $1b77 : $6f


Call_00_1b78:
    mov A, #$00                                                  ; $1b78 : $e8, $00
    call !SetDspAddrDataToYA                                                  ; $1b7a : $3f, $1d, $06
    inc Y                                                  ; $1b7d : $fc
    call !SetDspAddrDataToYA                                                  ; $1b7e : $3f, $1d, $06
    inc Y                                                  ; $1b81 : $fc
    mov A, X                                                  ; $1b82 : $7d
    call !SetDspAddrDataToYA                                                  ; $1b83 : $3f, $1d, $06
    ret                                                  ; $1b86 : $6f


Call_00_1b87:
    mov A, #$00                                                  ; $1b87 : $e8, $00
    call !SetDspAddrDataToYA                                                  ; $1b89 : $3f, $1d, $06
    inc Y                                                  ; $1b8c : $fc
    call !SetDspAddrDataToYA                                                  ; $1b8d : $3f, $1d, $06
    ret                                                  ; $1b90 : $6f


    call !SetDspAddrDataToYA                                                  ; $1b91 : $3f, $1d, $06
    inc Y                                                  ; $1b94 : $fc
    mov A, X                                                  ; $1b95 : $7d
    call !SetDspAddrDataToYA                                                  ; $1b96 : $3f, $1d, $06
    ret                                                  ; $1b99 : $6f


ClearShadowEchoVols:
    mov wEchoVolL+1, #$00                                                     ; $1b9a : $8f, $00, $61
    mov wEchoVolR+1, #$00                                                     ; $1b9d : $8f, $00, $63
    ret                                                                       ; $1ba0 : $6f


;
    mov A, !w321+X                                                  ; $1ba1 : $f5, $21, $03
    mov !w390+X, A                                                  ; $1ba4 : $d5, $90, $03
    mov A, !wTrackPanFullVal+X                                                  ; $1ba7 : $f5, $51, $03
    mov !w391+X, A                                                  ; $1baa : $d5, $91, $03
    ret                                                  ; $1bad : $6f


; X - track word idx
Call_00_1bae:
    mov !wTrackSndEffectsDataOffset+X, A                                                  ; $1bae : $d5, $40, $01
    mov !w3b0+X, A                                                  ; $1bb1 : $d5, $b0, $03
    mov !w161+X, A                                                  ; $1bb4 : $d5, $61, $01
    mov !w170+X, A                                                  ; $1bb7 : $d5, $70, $01
    mov !w3c0+X, A                                                  ; $1bba : $d5, $c0, $03
    mov !w131+X, A                                                  ; $1bbd : $d5, $31, $01
    ret                                                  ; $1bc0 : $6f


Call_00_1bc1:
    mov X, #$0e                                                  ; $1bc1 : $cd, $0e
    clr1 wBitfieldOfSndEffectsTracksUsed.7                                                  ; $1bc3 : $f2, $1a
    set1 $47.7                                                  ; $1bc5 : $e2, $47
    set1 $5e.7                                                  ; $1bc7 : $e2, $5e
    clr1 wd7.7                                                  ; $1bc9 : $f2, $d7
    call !Call_00_1c91                                                  ; $1bcb : $3f, $91, $1c

Call_00_1bce:
    mov A, wd4                                                  ; $1bce : $e4, $d4
    and A, #$80                                                  ; $1bd0 : $28, $80

Call_00_1bd2:
    beq br_00_1bd8                                                  ; $1bd2 : $f0, $04

    set1 w4a.7                                                  ; $1bd4 : $e2, $4a
    bra br_00_1bda                                                  ; $1bd6 : $2f, $02

br_00_1bd8:
    clr1 w4a.7                                                  ; $1bd8 : $f2, $4a

br_00_1bda:
    ret                                                  ; $1bda : $6f


Call_00_1bdb:
    mov X, #$0c                                                  ; $1bdb : $cd, $0c
    clr1 wBitfieldOfSndEffectsTracksUsed.6                                                  ; $1bdd : $d2, $1a
    set1 $47.6                                                  ; $1bdf : $c2, $47
    set1 $5e.6                                                  ; $1be1 : $c2, $5e
    clr1 wd7.6                                                  ; $1be3 : $d2, $d7
    call !Call_00_1c91                                                  ; $1be5 : $3f, $91, $1c

Call_00_1be8:
    mov A, wd4                                                  ; $1be8 : $e4, $d4
    and A, #$40                                                  ; $1bea : $28, $40
    beq br_00_1bf2                                                  ; $1bec : $f0, $04

    set1 w4a.6                                                  ; $1bee : $c2, $4a
    bra br_00_1bf4                                                  ; $1bf0 : $2f, $02

br_00_1bf2:
    clr1 w4a.6                                                  ; $1bf2 : $d2, $4a

br_00_1bf4:
    ret                                                  ; $1bf4 : $6f


Call_00_1bf5:
    mov X, #$0a                                                  ; $1bf5 : $cd, $0a
    clr1 wBitfieldOfSndEffectsTracksUsed.5                                                  ; $1bf7 : $b2, $1a
    set1 $47.5                                                  ; $1bf9 : $a2, $47
    set1 $5e.5                                                  ; $1bfb : $a2, $5e
    clr1 wd7.5                                                  ; $1bfd : $b2, $d7
    call !Call_00_1c91                                                  ; $1bff : $3f, $91, $1c

Call_00_1c02:
    mov A, wd4                                                  ; $1c02 : $e4, $d4
    and A, #$20                                                  ; $1c04 : $28, $20
    beq br_00_1c0c                                                  ; $1c06 : $f0, $04

    set1 w4a.5                                                  ; $1c08 : $a2, $4a
    bra br_00_1c0e                                                  ; $1c0a : $2f, $02

br_00_1c0c:
    clr1 w4a.5                                                  ; $1c0c : $b2, $4a

br_00_1c0e:
    ret                                                  ; $1c0e : $6f


Call_00_1c0f:
    mov X, #$08                                                  ; $1c0f : $cd, $08
    clr1 wBitfieldOfSndEffectsTracksUsed.4                                                  ; $1c11 : $92, $1a
    set1 $47.4                                                  ; $1c13 : $82, $47
    set1 $5e.4                                                  ; $1c15 : $82, $5e
    clr1 wd7.4                                                  ; $1c17 : $92, $d7
    call !Call_00_1c91                                                  ; $1c19 : $3f, $91, $1c

Call_00_1c1c:
    mov A, wd4                                                  ; $1c1c : $e4, $d4
    and A, #$10                                                  ; $1c1e : $28, $10
    beq br_00_1c26                                                  ; $1c20 : $f0, $04

    set1 w4a.4                                                  ; $1c22 : $82, $4a
    bra br_00_1c28                                                  ; $1c24 : $2f, $02

br_00_1c26:
    clr1 w4a.4                                                  ; $1c26 : $92, $4a

br_00_1c28:
    ret                                                  ; $1c28 : $6f


    mov X, #$06                                                  ; $1c29 : $cd, $06
    clr1 wBitfieldOfSndEffectsTracksUsed.3                                                  ; $1c2b : $72, $1a
    set1 $47.3                                                  ; $1c2d : $62, $47
    set1 $5e.3                                                  ; $1c2f : $62, $5e
    clr1 wd7.3                                                  ; $1c31 : $72, $d7
    call !Call_00_1c91                                                  ; $1c33 : $3f, $91, $1c
    mov A, wd4                                                  ; $1c36 : $e4, $d4
    and A, #$08                                                  ; $1c38 : $28, $08
    beq br_00_1c40                                                  ; $1c3a : $f0, $04

    set1 w4a.3                                                  ; $1c3c : $62, $4a
    bra br_00_1c42                                                  ; $1c3e : $2f, $02

br_00_1c40:
    clr1 w4a.3                                                  ; $1c40 : $72, $4a

br_00_1c42:
    ret                                                  ; $1c42 : $6f


    mov X, #$04                                                  ; $1c43 : $cd, $04
    clr1 wBitfieldOfSndEffectsTracksUsed.2                                                  ; $1c45 : $52, $1a
    set1 $47.2                                                  ; $1c47 : $42, $47
    set1 $5e.2                                                  ; $1c49 : $42, $5e
    clr1 wd7.2                                                  ; $1c4b : $52, $d7
    call !Call_00_1c91                                                  ; $1c4d : $3f, $91, $1c
    mov A, wd4                                                  ; $1c50 : $e4, $d4
    and A, #$04                                                  ; $1c52 : $28, $04
    beq br_00_1c5a                                                  ; $1c54 : $f0, $04

    set1 w4a.2                                                  ; $1c56 : $42, $4a
    bra br_00_1c5c                                                  ; $1c58 : $2f, $02

br_00_1c5a:
    clr1 w4a.2                                                  ; $1c5a : $52, $4a

br_00_1c5c:
    ret                                                  ; $1c5c : $6f


Call_00_1c5d:
    mov X, #$02                                                  ; $1c5d : $cd, $02
    clr1 wBitfieldOfSndEffectsTracksUsed.1                                                  ; $1c5f : $32, $1a
    set1 $47.1                                                  ; $1c61 : $22, $47
    set1 $5e.1                                                  ; $1c63 : $22, $5e
    clr1 wd7.1                                                  ; $1c65 : $32, $d7
    call !Call_00_1c91                                                  ; $1c67 : $3f, $91, $1c

Call_00_1c6a:
    mov A, wd4                                                  ; $1c6a : $e4, $d4
    and A, #$02                                                  ; $1c6c : $28, $02
    beq br_00_1c74                                                  ; $1c6e : $f0, $04

    set1 w4a.1                                                  ; $1c70 : $22, $4a
    bra br_00_1c76                                                  ; $1c72 : $2f, $02

br_00_1c74:
    clr1 w4a.1                                                  ; $1c74 : $32, $4a

br_00_1c76:
    ret                                                  ; $1c76 : $6f


Call_00_1c77:
    mov X, #$00                                                  ; $1c77 : $cd, $00
    clr1 wBitfieldOfSndEffectsTracksUsed.0                                                  ; $1c79 : $12, $1a
    set1 $47.0                                                  ; $1c7b : $02, $47
    set1 $5e.0                                                  ; $1c7d : $02, $5e
    clr1 wd7.0                                                  ; $1c7f : $12, $d7
    call !Call_00_1c91                                                  ; $1c81 : $3f, $91, $1c

Call_00_1c84:
    mov A, wd4                                                  ; $1c84 : $e4, $d4
    and A, #$01                                                  ; $1c86 : $28, $01
    beq br_00_1c8e                                                  ; $1c88 : $f0, $04

    set1 w4a.0                                                  ; $1c8a : $02, $4a
    bra br_00_1c90                                                  ; $1c8c : $2f, $02

br_00_1c8e:
    clr1 w4a.0                                                  ; $1c8e : $12, $4a

br_00_1c90:
    ret                                                  ; $1c90 : $6f


Call_00_1c91:
    mov A, !wTrackInstrumentIdxes+X                                                  ; $1c91 : $f5, $11, $02
    call !ApplyInstrumentA                                                  ; $1c94 : $3f, $29, $08
    call !Call_00_0b62@applyPanAndVol                                                  ; $1c97 : $3f, $de, $0b
    mov A, wd7                                                  ; $1c9a : $e4, $d7
    bne @cont_1ca8                                                  ; $1c9c : $d0, $0a

    mov A, wd4                                                  ; $1c9e : $e4, $d4
    bne @cont_1ca8                                                  ; $1ca0 : $d0, $06

    mov A, #$00                                                  ; $1ca2 : $e8, $00
    mov wEchoVolL+1, A                                                  ; $1ca4 : $c4, $61
    mov wEchoVolR+1, A                                                  ; $1ca6 : $c4, $63

@cont_1ca8:
    mov A, !wTrackNoteAfterTransposeTuning+1+X                                                  ; $1ca8 : $f5, $61, $03
    mov $11, A                                                  ; $1cab : $c4, $11
    mov A, !wTrackNoteAfterTransposeTuning+X                                                  ; $1cad : $f5, $60, $03
    mov $10, A                                                  ; $1cb0 : $c4, $10
    call !HandleVCMDBetween80hAndDFh@func_0592                                                  ; $1cb2 : $3f, $92, $05
    ret                                                  ; $1cb5 : $6f


Call_00_1cb6:
    mov A, $d9                                                  ; $1cb6 : $e4, $d9
    mov wEchoVolL+1, A                                                  ; $1cb8 : $c4, $61
    mov A, $da                                                  ; $1cba : $e4, $da
    mov wEchoVolR+1, A                                                  ; $1cbc : $c4, $63
    ret                                                  ; $1cbe : $6f


;
    mov A, !w390+X                                                  ; $1cbf : $f5, $90, $03
    mov !w321+X, A                                                  ; $1cc2 : $d5, $21, $03
    mov A, !w391+X                                                  ; $1cc5 : $f5, $91, $03
    mov !wTrackPanFullVal+X, A                                                  ; $1cc8 : $d5, $51, $03
    call !Call_00_0b62@applyPanAndVol                                                  ; $1ccb : $3f, $de, $0b
    ret                                                  ; $1cce : $6f


.include "data/soundEffects.s"


.org $2b00

SoundScoreArea:

.include "data/scores.s"


.org $4b00

SampleSrcDir:
    .dw Sample_4db0, Sample_4db0@loop
    .dw Sample_4db0, Sample_4db0@loop
    .dw Sample_4db0, Sample_4db0@loop
    .dw Sample_4db0, Sample_4db0@loop
    .dw Sample_4db0, Sample_4db0@loop
    .dw Sample_4db0, Sample_4db0@loop
    .dw Sample_4db0, Sample_4db0@loop
    .dw Sample_4db0, Sample_4db0@loop
    .dw Sample_4e13, Sample_4e13@loop
    .dw Sample_4e13, Sample_4e13@loop
    .dw Sample_4e13, Sample_4e13@loop
    .dw Sample_4e13, Sample_4e13@loop
    .dw Sample_4f3c, Sample_4f3c@loop
    .dw Sample_4f3c, Sample_4f3c@loop
    .dw Sample_4f3c, Sample_4f3c@loop
    .dw Sample_4f3c, Sample_4f3c@loop
    .dw Sample_516a, Sample_516a@loop
    .dw Sample_516a, Sample_516a@loop
    .dw Sample_516a, Sample_516a@loop
    .dw Sample_516a, Sample_516a@loop
    .dw Sample_51c4, Sample_51c4@loop
    .dw Sample_51c4, Sample_51c4@loop
    .dw Sample_51c4, Sample_51c4@loop
    .dw Sample_5203, Sample_5203@loop
    .dw Sample_53e9, Sample_53e9@loop
    .dw Sample_53e9, Sample_53e9@loop
    .dw Sample_53e9, Sample_53e9@loop
    .dw Sample_5428, Sample_5428@loop
    .dw Sample_5467, Sample_5467@loop
    .dw Sample_5467, Sample_5467@loop
    .dw Sample_5467, Sample_5467@loop
    .dw Sample_60d0, Sample_60d0@loop
    .dw Sample_60d0, Sample_60d0@loop
    .dw Sample_64ed, Sample_64ed@loop
    .dw Sample_64ed, Sample_64ed@loop
    .dw Sample_672d, Sample_672d@loop
    .dw Sample_672d, Sample_672d@loop
    .dw Sample_672d, Sample_672d@loop
    .dw Sample_672d, Sample_672d@loop
    .dw Sample_695b, Sample_695b@loop
    .dw Sample_695b, Sample_695b@loop
    .dw Sample_699a, Sample_699a@loop
    .dw Sample_6a3c, Sample_6a3c@loop
    .dw Sample_6a3c, Sample_6a3c@loop
    .dw Sample_6a3c, Sample_6a3c@loop
    .dw Sample_6a3c, Sample_6a3c@loop
    .dw Sample_6bb6, Sample_6bb6@loop
    .dw Sample_6bb6, Sample_6bb6@loop
    .dw Sample_6bf5, Sample_6bf5@loop
    .dw Sample_6f9d, Sample_6f9d+_sizeof_Sample_6f9d
    .dw Sample_71cb, Sample_71cb+_sizeof_Sample_71cb
    .dw Sample_71cb, Sample_71cb+_sizeof_Sample_71cb
    .dw Sample_7cc3, Sample_7cc3+_sizeof_Sample_7cc3
    .dw Sample_8a82, Sample_8a82+_sizeof_Sample_8a82
    .dw Sample_922c, Sample_922c@loop
    .dw Sample_953b, Sample_953b@loop
    .dw Sample_adce, Sample_adce@loop
    .dw Sample_b5e4, Sample_b5e4@loop
    .dw Sample_b995, Sample_b995+_sizeof_Sample_b995
    .dw Sample_bba8, Sample_bba8+_sizeof_Sample_bba8
    .dw Sample_c7b7, Sample_c7b7+_sizeof_Sample_c7b7
    .dw Sample_d94b, Sample_d94b@loop
    .dw Sample_eb15, Sample_eb15@loop
    .dw $ffff, $ffff


.org $4c10

NoteDurationRates:
    .db $32, $65, $7f, $98, $b2, $cb, $e5, $fc
    
    
NoteVelocityRates:
    .db $19, $32, $4c, $65, $72, $7f, $8c, $98
    .db $a5, $b2, $bf, $cb, $d8, $e5, $f2, $fc


.org $4c30

.macro Instrument
    .db \1, \2, \3, \4, \5>>8, \5&$ff
.endm

InstrumentsData:
    Instrument $00, $8f, $e0, $b8, $0400
    .db $01, $ff, $fb, $b8, $04, $00
    .db $02, $8f, $6f, $b8, $04, $00
    .db $03, $8c, $60, $b8, $04, $00
    .db $04, $fa, $e0, $b8, $04, $00
    .db $05, $ff, $f5, $b8, $04, $00
    .db $06, $f9, $ef, $b8, $04, $00
    .db $07, $8f, $e0, $b8, $04, $00
    .db $08, $ff, $f5, $b8, $1d, $f0
    .db $09, $ff, $ee, $b8, $1d, $f0
    .db $0a, $8e, $af, $b8, $1d, $f0
    .db $0b, $ff, $e0, $b8, $1d, $f0
    .db $0c, $ff, $f5, $b8, $0e, $f0
    .db $0d, $ff, $ee, $b8, $0e, $f0
    .db $0e, $f9, $ef, $b8, $0e, $f0
    .db $0f, $ff, $e0, $b8, $0e, $f0
    .db $10, $fa, $e0, $b8, $06, $f0
    .db $11, $ff, $f5, $b8, $06, $f0
    .db $12, $ff, $fb, $b8, $06, $f0
    .db $13, $ff, $ee, $b8, $06, $f0
    .db $14, $8f, $6f, $b8, $04, $00
    .db $15, $fa, $e0, $b8, $04, $00
    .db $16, $ff, $e0, $b8, $04, $00
    .db $17, $ff, $f1, $b8, $06, $00
    .db $18, $8f, $6f, $b8, $04, $00
    .db $19, $fa, $e0, $b8, $04, $00
    .db $1a, $ff, $e0, $b8, $04, $00
    .db $1b, $ff, $e0, $b8, $04, $00
    .db $1c, $8e, $af, $b8, $03, $c0
    .db $1d, $d8, $a0, $b8, $03, $c0
    .db $1e, $ff, $e0, $b8, $03, $c0
    .db $1f, $f9, $ef, $b8, $0a, $30
    .db $20, $ff, $e1, $b8, $0a, $30
    .db $21, $fa, $e0, $b8, $0a, $60
    .db $22, $ff, $e0, $b8, $0a, $60
    .db $23, $ff, $fb, $b8, $04, $f0
    .db $24, $8f, $6f, $b8, $04, $f0
    .db $25, $f9, $ef, $b8, $04, $f0
    .db $26, $ff, $e0, $b8, $04, $f0
    .db $27, $8f, $6f, $b8, $04, $00
    .db $28, $ff, $e0, $b8, $04, $00
    .db $29, $ff, $e0, $b8, $0e, $f0
    .db $2a, $ff, $fb, $b8, $08, $f0
    .db $2b, $ff, $f5, $b8, $08, $f0
    .db $2c, $f9, $ef, $b8, $08, $f0
    .db $2d, $ff, $e0, $b8, $08, $f0
    .db $2e, $d8, $a0, $b8, $04, $00
    .db $2f, $ff, $e0, $b8, $04, $00
    .db $30, $ff, $e0, $b8, $04, $f0
    .db $31, $ff, $e0, $b8, $07, $a0
    .db $32, $ff, $fb, $b8, $07, $a0
    .db $33, $ff, $e0, $b8, $07, $a0
    .db $34, $ff, $e0, $b8, $01, $e0
    .db $35, $ff, $e0, $b8, $07, $a0
    .db $36, $ff, $f0, $b8, $16, $f0
    .db $37, $ff, $e0, $b8, $0f, $10
    .db $38, $ff, $e1, $b8, $02, $d0
    .db $39, $ff, $e0, $b8, $04, $00
    .db $3a, $ff, $e0, $b8, $46, $00
    .db $3b, $ff, $e0, $b8, $07, $a0
    .db $3c, $ff, $e0, $b8, $01, $80
    .db $3d, $ff, $e0, $b8, $04, $00
    .db $3e, $ff, $e0, $b8, $03, $70
    .db $00


.org $4db0

.include "data/samples.s"
