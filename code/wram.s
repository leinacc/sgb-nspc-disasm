.ramsection "RAM" bank 0 slot 0

; port 0: music score
; port 1: sound effect A: decrescendo
; port 2: sound effect B: sustain
; port 3: sound effect attrs
wReadPortData: ; $00
    .db
wMusicScore: ; $00
    db
wSndEffectAdecrescendo: ; $01
    db
wSndEffectBsustain: ; $02
    db
; Bit 0-1 - Sound Effect A Pitch  (0..3=Low..High)
; Bit 2-3 - Sound Effect A Volume (0..2=High..Low, 3=Mute on)
; Bit 4-5 - Sound Effect B Pitch  (0..3=Low..High)
; Bit 6-7 - Sound Effect B Volume (0..2=High..Low, 3=Not used)
wSndEffectAttrs: ; $03
    db

wPortDataToWrite: ; $04
    ds 4

; todo: speculation
wMusicToPlay: ; $08
    db

wSndEffectAtoPlay: ; $09
    db

wSndEffectBtoPlay: ; $0a
    db

w0b:
    ds $c-$b

w0c: ; $0c
    db

w0d:
    ds $e-$d

wKnown0word: ; $0e
    dw

.union

    wZpNoteAfterTransposeTuning: ; $10
        dw

.nextu

    wCurrTracksPanVal: ; $10
        dw

.endu

.union

    wTempVolLorR: ; $12
        db

.nextu

    ; Bit 7 set if value2 < value1 (negative range)
    wRangeSplitNegSign: ; $12
        db

.endu

w13:
    ds 4-3

.union

    wIPLMimicDataDest: ; $14
        dw

.nextu

    wInstrumentDataPtr: ; $14
        dw

.nextu

    wTrackAddr: ; $14
        dw

.nextu

    wTempRangeSplitVal: ; $14
        dw

.nextu

    wNoteFrom: ; $14
        dw

.endu

.union

    wMusicPhrasesTracksTable: ; $16
        dw

.nextu

    wCalcedShadowPitch: ; $16
        dw

.endu

w18:
    ds $a-8

wBitfieldOfSndEffectsTracksUsed: ; $1a
    db

w1b:
    ds $2c-$1b

; Bit 0-1 - Sound Effect A Pitch  (0..3=Low..High)
wSndEffectAttrApitch: ; $2c
    db

; Bit 2-3 - Sound Effect A Volume (0..2=High..Low)
wSndEffectAttrAvol: ; $2d
    db

; Bit 4-5 - Sound Effect B Pitch  (0..3=Low..High)
wSndEffectAttrBpitch: ; $2e
    db

; Bit 6-7 - Sound Effect B Volume (0..2=High..Low)
wSndEffectAttrBvol: ; $2f
    db

; 8 tracks, word addresses
wCurrPhraseTracksAddrs: ; $30
    ds 8*2

wSoundScorePtr: ; $40
    dw

w42: ; $42
    dw

wBackupTrackWordIdx: ; $44
    db

w45: ; $45
    db

w46: ; $46
    db

wCurrTrackIdxBitfield: ; $47
    db

; Bit 5 - FLGF_ECHO_DISABLE
wDSPflags: ; $48
    db

w49: ; $49
    db

w4a: ; $4a
    db

w4b: ; $4b
    db

w4c:
    ds $d-$c

wEchoDelay: ; $4d
    db

wEchoFeedback: ; $4e
    db

w4f:
    ds $50-$4f

wGlobalTranspose: ; $50
    db

w51:
    ds 2-1

wTempoVal: ; $52
    dw

wTempoLength: ; $54
    db

wTempoDest: ; $55
    db

wTempoIncrPer1Length: ; $56
    dw

wMasterVolume: ; $58
    dw

wMasterVolLength: ; $5a
    db

wMasterVolDest: ; $5b
    db

wMasterVolIncrPer1Length: ; $5c
    dw

w5e:
    ds $f-$e

wPercussionPatchBase: ; $5f
    db

wEchoVolL: ; $60
    dw

wEchoVolR: ; $62
    dw

wEchoLeftVolIncrPer1Length: ; $64
    dw

wEchoRightVolIncrPer1Length: ; $66
    dw

wEchoVolFadeLen: ; $68
    db

wEchoVolDestLeft: ; $69
    db

wEchoVolDestRight: ; $6a
    db

w6b:
    ds $70-$6b

wCtrlTilNextTrackByte: ; $70
    db
wFramesTilNextTrackByte: ; $71
    ds 8*2-1

; todo: check if this is -1 from actual loop val
wBlockLoopCtr: ; $80
    db
w81: ; $81
    ds 8*2-1

wTrackVolLen: ; $90
    db
wTrackPanLength: ; $91
    ds 8*2-1

wPitchSlideLength: ; $a0
    db
wPitchSlideDelay: ; $a1
    ds 8*2-1

wb0:
    db
wTrackCurrVibratoVal: ; $b1
    ds 8*2-1

wc0:
    db
wTrackTremoloDepth: ; $c1
    ds 8*2-1

wPtrToEchoBuffer: ; $d0
    dw

wSndEffectTrackDataPtr: ; $d2
    dw

wd4: ; $d4
    db

wd5:
    ds 7-5

wd7: ; $d7
    db

wSndEffectMVols: ; $d8
    db

wd9:
    ds $b-9

wCurrMusic: ; $db
    db

wNoiseClockRate: ; $dc
    db

wSPCDisabled: ; $dd
    db

wde:
    ds $100-$de

w100: ; $100
    db
w101:
    ds 8*2-1

w110:
    ds $20-$10

wSndEffectBCopyOfTrack0Ptr: ; $120
    dw

wSndEffectBCopyOfTrack1Ptr: ; $122
    dw

w124:
    ds 8-4

wSndEffectBCopyOfTrack4Ptr: ; $128
    dw

wSndEffectBCopyOfTrack5Ptr: ; $12a
    dw

wSndEffectACopyOfTrack6Ptr: ; $12c
    dw

wSndEffectACopyOfTrack7Ptr: ; $12e
    dw

w130: ; $130
    db
w131: ; $131
    ds 8*2-1

wTrackSndEffectsDataOffset: ; $140
    db
w141: ; $141
    ds 8*2-1

w150: ; $150
    db
w151: ; $151
    ds 8*2-1

w160: ; $160
    db
w161: ; $161
    ds 8*2-1

w170: ; $170
    db
w171: ; $171
    ds 8*2-1

w180: ; $180
    db
w181: ; $181
    ds 8*2-1

w190: ; $190
    db
w191: ; $191
    ds 8*2-1

w1a0: ; $1a0
    db
w1a1: ; $1a1
    ds 8*2-1

w1b0: ; $1b0
    db
w1b1: ; $1b1
    ds 8*2-1

wStack: ; $1c0
    ds $f

wStackTop: ; $1cf
    db

w1d0:
    ds $200-$1d0

wPendingCtrlTilNextTrackByte: ; $200
    db
wTrackDurationOfNote: ; $201
    ds 8*2-1

wTrackVelocityOfNote: ; $210
    db
wTrackInstrumentIdxes: ; $211
    ds 8*2-1

wPitchBaseMultiplier: ; $220
    ds 8*2

wTrackRetAddr: ; $230
    ds 8*2

wTrackSubroutineAddr: ; $240
    ds 8*2

w250:
    ds $60-$50

wSoundEffectBIdxForTrack0: ; $260
    db

wSoundEffectBIdxForTrack1: ; $261
    db

w262:
    ds 4-2

wSoundEffectBIdxForTrack4: ; $264
    db

wSoundEffectBIdxForTrack5: ; $265
    db

wSoundEffectAIdxForTrack6: ; $266
    db

wSoundEffectAIdxForTrack7: ; $267
    db

w268:
    ds $76-$68

.union

    wSndEffectB_ADSR1: ; $276
        db

    wSndEffectB_ADSR2: ; $277
        db

.nextu

    wSndEffectB_VOL_L: ; $276
        db

    wSndEffectB_VOL_R: ; $277
        db

.endu

w278:
    ds $80-$78

wTrackPitchEnvelopeLen: ; $280
    db
wTrackPitchEnvelopeDelay: ; $281
    ds 8*2-1

wTrackPitchEnvelopeIsTo: ; $290
    db
wTrackPitchEnvelopeKey: ; $291
    ds 8*2-1

w2a0: ; $2a0
    db
wTrackVibratoRate: ; $2a1
    ds 8*2-1

wTrackVibratoDelay: ; $2b0
    db
wTrackVibratoFadeLen: ; $2b1
    ds 8*2-1

wTrackVibratoIcrPer1Length: ; $2c0
    db
wTrackVibratoDepth: ; $2c1
    ds 8*2-1

w2d0: ; $2d0
    db
wTrackTremoloRate: ; $2d1
    ds 8*2-1

wTrackTremoloDelay: ; $2e0
    db
w2e1:
    ds 8*2-1

; todo: not interleaved with another per-track var
wTrackTranspose: ; $2f0
    ds 8*2

wTrackVolume: ; $300
    ds 8*2

wTrackVolIncrPer1Length: ; $310
    ds 8*2

wTrackVolDest: ; $320
    db
w321: ; $321
    ds 8*2-1

; max $1f00
wTrackPanValue: ; $330
    ds 8*2

wTrackPanIncrPer1Length: ; $340
    ds 8*2
    
wTrackPanDest: ; $350
    db
wTrackPanFullVal: ; $351
    ds 8*2-1

wTrackNoteAfterTransposeTuning: ; $360
    ds 8*2

w370:
    ds $80-$70

w380:
    db
wTrackTuning: ; $381
    ds 8*2-1

w390: ; $390
    db
w391: ; $391
    ds 8*2-1

w3a0: ; $3a0
    db
w3a1: ; $3a1
    ds 8*2-1

w3b0: ; $3b0
    db
w3b1: ; $3b1
    ds 8*2-1

w3c0: ; $3c0
    db
w3c1:
    ds 8*2-1

; Bit 0 set - track 7 enabled
; Bit 1 set - track 6 enabled
wActiveSndEffectATracks: ; $3d0
    db

; Bit 0 set - track 5 enabled
; Bit 1 set - track 4 enabled
; Bit 2 set - track 1 enabled
; Bit 3 set - track 0 enabled
; Bit 7 set -
wActiveSndEffectBTracks: ; $3d1
    db

w3d2:
    ds 5-2

wSndEffectATableOffs: ; $3d5
    db

wSndEffectBTableOffs: ; $3d6
    db

w3d7:
    ds $ef00-$3d7

wEchoBuffer: ; $ef00
    ds $1000

.ends