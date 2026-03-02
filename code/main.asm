;; Main game code
  ; <sample>

  LDA PPUSTATUS ; Reset high/low latch
  ; Write 5 tiles at $2020 (top-left)
  LDA #$20
  STA PPUADDR
  LDA #$20
  STA PPUADDR

  LDA #$01
  LDX #5
-
  STA PPUDATA
  DEX
  CPX #00
  BNE -

  ; </sample>

  ; Reset scroll
  LDA #$00
  STA PPUSCROLL
  STA PPUSCROLL

  LDA #%10010000  ; enable NMI, sprites from Pattern Table 0, background from Pattern Table 1, increment by 1
  STA PPUCTRL
  LDA #%00011110  ; enable sprites, enable background, no clipping on left side
  STA PPUMASK

  ; Main loop
Loop:
  JMP Loop


;-------------------------------------------------------------------------------------


VBLANK:
  LDA PPUSTATUS  ; read PPU status to reset the high/low latch

  RTS

