;; Main game code
  ; Main loop
Loop:
  JMP Loop


;-------------------------------------------------------------------------------------


VBLANK:
  LDA $2002  ; read PPU status to reset the high/low latch

  RTS

