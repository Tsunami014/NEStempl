;; Main game code
  ; PPUCTRL
  LDA %10010000  ; enable NMI, sprites from Pattern Table 0, background from Pattern Table 1, increment by 1
  STA PPUCTRL
  ; PPUMASK
  LDA %00011110  ; enable sprites, enable background, no clipping on left side
  STA PPUMASK
  ; Main loop
Loop:
  JMP Loop


;-------------------------------------------------------------------------------------


VBLANK:
  LDA PPUSTATUS  ; read PPU status to reset the high/low latch

  RTS

