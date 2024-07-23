; reset everything screen related
; no registers are destroyed
cleanup_screen:
    movem.l d0-d7/a0-a2,-(sp)

    lea.l stdpalette,a0         ; restore standard palette
    movem.l    (a0),d0-d7
    movem.l    d0-d7,$ffff8240

    btst #1,savehz      ; reset screen frequency
    bne.s nohz
    bclr.b #1,$ff820a
nohz:
    move.w     saveres,d0   ; reset screen resolution and physical/logical screen address
    movea.l    pscreen,a0
    move.w     d0,-(sp)
    move.l     a0,-(sp)
    move.l     a0,-(sp)
    move.w     #5,-(sp)
    trap       #14
    lea        $c(sp),sp

    ;    bsr waitvbi

    dc.w $A000          ; line $a routine
    dc.w $A009                      ; show mouse
    move.b #$08,$FFFFFC02.w         ; enable mouse

    movem.l (sp)+,d0-d7/a0-a2
    rts

cleanup_vbl:
    move.l  oldvbl,$70.w            ; restore VBL
