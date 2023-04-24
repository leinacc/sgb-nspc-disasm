;        7      6     5     4     3     2     1     0
;    +-------+-----+-----+-----+-----+-----+-----+-----+
; F1 | IPLEN |  -  | PC32| PC10|  -  | ST2 | ST1 | ST0 | Control, Write only!
;    +-------+-----+-----+-----+-----+-----+-----+-----+
;IPLEN: Writing '1' here will load the IPL back in the memory map
;PC32: "PORT CLEAR" Writing '1' here will reset input from ports 2 & 3. (reset to zero)
;PC10: "PORT CLEAR" Writing '1' here will reset input from ports 0 & 1.
;STx:  Writing '1' here will activate timer X, writing '0' disables the timer.
CTRL_REG = $f1
    _CTRL_IPLEN = $80
    _CTRL_PC32 = $20
    _CTRL_PC10 = $10
    _CTRL_TIMER_1 = $02
    _CTRL_TIMER_0 = $01

DSP_REG_ADDR = $f2
DSP_REG_DATA = $f3
PORT_0 = $f4
PORT_1 = $f5
PORT_2 = $f6
PORT_3 = $f7
TIMER_0 = $fa ; used for updating the music
TIMER_1 = $fb ; used for updating once per frame
COUNTER_0 = $fd
COUNTER_1 = $fe

; DSP regs
VOL_L = $00
VOL_R = $01
PITCH_L = $02
SRCN = $04
ADSR_1 = $05
ADSR_2 = $06
GAIN = $07
MVOL_L = $0c
EFB = $0d
COEF = $0f
MVOL_R = $1c
EVOL_L = $2c
PMON = $2d
EVOL_R = $3c
NON = $3d
KON = $4c
EON = $4d
KOF = $5c ; 1 bit for each voice
DIR = $5d

FLG = $6c
    FLGF_RESET = $80
    FLGF_MUTE = $40
    FLGF_ECHO_DISABLE = $20
    FLGF_NOISE_CLK = $1f

    FLGB_MUTE = 6
    FLGB_ECHO_DISABLE = 5

ESA = $6d
EDL = $7d

IPL_START = $ffc0


; N-SPC
NUM_VOL_PAN_LEVELS = $14

SNDB_DISABLE_SOUND = $81
SNDB_REENABLE_SOUND = $82