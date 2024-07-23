; interrupts
; vertical blank interrupt routine
vbl:
    movem.l d0-d7/a0-a6,-(sp)    
    bsr     music+8                 ; call music
    movea.l pscreen,a0
    bsr     clr_scr_fast

    move.w  #160,a5 ; y
    move.w  #100,a6 ; x
    lea     coord_diffs,a1

    move.w  current_rot,d0
    add.w   d0,a1
    add.w   #18,d0
    cmp.w   #18*36,d0
    blt.s   controt
    moveq   #0,d0
controt:
    move.w  d0,current_rot

    move.w  d4,a5
    moveq   #8-1,d7
dotsloopy:
    move.w  a6,d5
    move.w  a5,d4
    moveq   #8-1,d6
dotsloopx:
    move.w  d5,d0 ; x
    move.w  d4,d1 ; y
    lea     screentable,a2
    
    bsr dot3x3
    add.w   0(a1),d5
    add.w   2(a1),d4
    dbra    d6,dotsloopx
    ; diff y
    add.w   6(a1),a6
    add.w   8(a1),a5
    move.w  a6,d5 ; x
    move.w  a5,d4 ; y

    dbra    d7,dotsloopy

    movem.l (sp)+,d0-d7/a0-a6
; either - branch to the old vector
    move.l  oldvbl,-(sp)        ; go to old vector (system friendly ;) )
    rts
; or: return from vbl routine (but then key stroke detection does not work)
    ; rte

current_rot:
    dc.w    0