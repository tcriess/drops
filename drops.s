; drops demo.
; 96k Atari ST intro for SillyVenture 2024 SE
main:
    clr.l   -(sp)            ; supervisor mode on
    move.w  #$20,-(sp)
    trap    #1
    addq.l  #6,sp
    move.l  d0,sv_ssp

    movea.l 4(sp),a0 ; free memory, set stack pointer
    lea     stack,sp
    move.l  #$100,d0
    add.l   $c(a0),d0
    add.l   $14(a0),d0
    add.l   $1c(a0),d0
    move.l  d0,-(sp)
    move.l  a0,-(sp)
    clr.w   -(sp)
    move.w  #$4a,-(sp)
    trap    #1
    lea     $c(sp),sp

; initialisation
    bsr     init_screen
    bsr     init_vbl
    bsr     music+0                 ; init music

;;; test code, compute the square root of 10
;    moveq #10,d0
;    bsr sqrt
;;; result should be in d1

; main

mainloop:
    bsr scan_keys
    tst.w d0
    beq mainloop

; cleanup
    bsr     cleanup_screen
    bsr     music+4                 ; de-init music
    bsr     cleanup_vbl

; finally
    move.l  sv_ssp,-(sp)        ; back to user mode, restore old stack pointer
    move.w  #$20,-(sp)
    trap    #1
    addq.l  #6,sp

    clr.l   -(sp)            ; terminate execution
    trap    #1

; init routines
    include "init.s"
; cleanup routines
    include "cleanup.s"
; math functions
    include "math.s"
; utility functions
    include "util.s"
; simple sprites
    include "ssprite.s"
; dots
    include "dots.s"
; interrupts
    include "inter.s"
; precomputed coordinates
    include "coords.s"
; audio
    include "audio.s"
; bss section
    include "bss.s"
    text
music:
    incbin  "BUMTARAB.snd"            ; SNDH file to include (this one needs 50Hz replay)