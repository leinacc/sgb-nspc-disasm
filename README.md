# Rom map (code/initial.s)

| Range | Descrip |
|-------|---------|
| `04c1-04dd` | Calls to exchange sound effect+attrs data with the SNES |
| `04f1-04fb` | As above, for music |
| `0518-0527` | Generic routine for the 4 above, for exchanging data with the SNES |
| `0528-058f` | Routine for handling VCMD's between $80 and $df |
| `05e1-0605` | Example 16bit by 16bit multiplication that happens in a bunch of places |
| `0632-065e` | Music $ff (load new data, eg for SOU_TRN), and PlayNewMusic |
| `065f-0696` | ResetAllTracks |
| `06a6-06c8` | Music $fe (stop and jump to real IPL) |
| `06cb-07bb` | ProcessMusicScore (checks curr phrase, then the track for 8 instruments) |
| `07bd-0809` | tempo, echo volume, and master volume fade is processed |
| `080a-0add` | VCMD handlers |
| `0b05-0b42` | VCMD handler table |
| `0b43-0b61` | VCMD num params table |
| `0bed-0c2a` | ApplyPanAndSetVolRegs |
| `0c2b-0d75` | TickTrackUpdate |
| `0dae-0dbf` | ApplyTremoloToVolsAndVelocity |
| `0dc0-0dd4` | VolPanLevels table |
| `0dd5-0df4` | FilterCoefficients table |
| `0e09-0e22` | Octave0NotePitches table |
| `0e2e-0e79` | MimicIPL |
| `0ef0-0f66` | Outer sound effect+attr process code |

At the bottom of the file you have:

* SoundScoreArea: in `data/scores.s`, is example N-SPC music data
* SampleSrcDir: ie DIR
* NoteDurationRates: default counters for the 8 note length values
* NoteVelocityRates: ??
* InstrumentsData: https://sneslab.net/wiki/N-SPC_Engine#Instrument_Format
* Various samples in `data/samples.s`