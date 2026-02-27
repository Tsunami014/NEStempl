PRG_COUNT = 2 ; 1 = 16KB, 2 = 32KB
CHR_COUNT = 1 ; 1 = 8KB, 2 = 16KB, 4 = 32KB
MIRRORING = %0001 ; %0000 = horizontal, %0001 = vertical, %1000 = four-screen

; NES Header
	.db "NES", $1a  ; Identification of the iNES header
	.db PRG_COUNT  ; Number of 16KB PRG-ROM pages
	.db CHR_COUNT  ; Number of 8KB CHR-ROM pages
	.db $00|MIRRORING  ; Mapper 0 and mirroring
	.dsb 9, $00  ; Clear the remaining bytes



;;;;;;;;;;;;;;;;;; Constants



; PPU registers
PPUCTRL   = $2000
PPUMASK   = $2001
PPUSTATUS = $2002
PPUSCROLL = $2005
PPUADDR   = $2006
PPUDATA   = $2007
; Object Attribute Memory - sprites
OAMADDR   = $2003
OAMDATA   = $2004
OAMDMA    = $4014  ; Quickly copy a page of CPU memory to OAM

; Controller inputs
BTN_A      = %10000000
BTN_B      = %01000000
BTN_SELECT = %00100000
BTN_START  = %00010000
BTN_UP     = %00001000
BTN_DOWN   = %00000100
BTN_LEFT   = %00000010
BTN_RIGHT  = %00000001



;;;;;;;;;;;;;;;;;; Variables



;; Please note these variables all default to 0
.enum $0000  ; Start variables at ram location 0
; .dsb 1 means reserve one byte of space, .dsb 2 means reserve 2 bytes (pointer)

buttons1     .dsb 1  ; Player 1 gamepad buttons, one bit per button

; Temporary variables with many uses
tmp1         .dsb 1
tmp2         .dsb 1
tmp3         .dsb 1
tmp4         .dsb 1
tmp5         .dsb 1

tmpPtr       .dsb 2


.ende



.org $8000  ; Program ROM starts here ($8000 for 2 banks, $C000 for 1)



;;;;;;;;;;;;;;;;;; Initialisation



RESET:
  SEI          ; Disable IRQs
  CLD          ; Disable decimal mode
  LDX #$40
  STX $4017    ; Disable APU frame IRQ
  LDX #$FF
  TXS          ; Set up stack
  INX          ; Now X = 0
  STX PPUCTRL  ; Disable NMI
  STX PPUMASK  ; Disable rendering
  STX $4010    ; Disable DMC IRQs

; Wait for vblank to make sure PPU is ready
- BIT PPUSTATUS
  BPL -

; Clear all memory
- LDA #$00
  STA $0000,X
  STA $0100,X
  STA $0300,X
  STA $0400,X
  STA $0500,X
  STA $0600,X
  STA $0700,X
  LDA #$FE
  STA $0200,X
  INX
  BNE -
  
; Second wait for vblank, PPU is ready after this
- BIT PPUSTATUS
  BPL -


; Load palettes
  LDA PPUSTATUS     ; Read PPU status to reset the high/low latch
  ; Write at the PPU's $3F00 address
  LDA #$3F
  STA PPUADDR       
  LDA #$00
  STA PPUADDR
  LDX #$00          ; Start out at 0
; Load pallete loop
- LDA palette,X     ; Load data from address (palette + the value in x (which is the loop index))
  STA PPUDATA       ; Write to PPU
  INX
  CPX #$20          ; Only copy until hex $10, decimal 16 - copying 16 bytes = 4 sprites
  BNE -



;;;;;;;;;  Game initialisation



  LDA #$00  ; Start with no scroll (set scroll bytes to 0)
  STA PPUSCROLL
  STA PPUSCROLL

  .include "game.asm"  ; Includes the labels for VBLANK and continues this function



;;;;;;;;;;;;;;;;;; Tick



NMI:  ; During VBLANK
  ; Store registers to the stack for recovery inside VBLANK routine
  PHA
  TXA
  PHA
  TYA
  PHA

  LDA #$00
  STA $2003       ; Set the low byte (00) of the RAM address
  LDA #$02
  STA $4014       ; Set the high byte (02) of the RAM address, start the transfer
   
  JSR ReadController  ; Get the current button data for player 1
  
  JMP VBLANK  ; Returning from interrupt should occur here

  ; Restore registers from stack
  PLA
  TAY
  PLA
  TAX
  PLA

  RTI  ; Return from interrupt



;;;;;;;;;;;;;;;;;; Reading controllers



;; The reason this is required is as to read from controller inputs, you need to read from a memory address multiple times in a row.
;; This code reads from the addresses for player 1 buttons and pushes them into a variable.
ReadController:
  ; Latch the controllers
  LDA #$01
  STA $4016       ; Strobe on
  LDA #$00
  STA $4016       ; Strobe off

  ; Prepare for 8 reads
  LDX #$08
  LDA #$00
  STA buttons1    ; Clear previous frame’s bits

; Read controller loop
- LDA $4016
  AND #%00000001  ; Isolate bit0 (next button)
  LSR A           ; Shift bit0 → Carry
  ROL buttons1    ; Shift buttons1 left, carry→bit0

  DEX
  BNE -
  RTS



;;;;;;;;;;;;;;;;;; Data



  .org $D000
palette:
  .db $21,$19,$27,$2D,  $21,$28,$27,$2D,  $21,$17,$27,$00,  $21,$3A,$38,$2D   ; Background palette
  .db $21,$1C,$15,$14,  $21,$02,$38,$3C,  $21,$1C,$15,$14,  $21,$02,$38,$3C   ; Sprite palette


  .org $FFFA     ; Three vectors starts here
  .dw NMI        ; NMI label (once per frame) 
  .dw RESET      ; Initialisation or reset
  .dw 0          ; IRQ (isn't used)


  .incbin "tiles.chr"  ; Include the graphics file at the end
