; initialize everything screen-related
; no registers are destroyed
init_screen:
    movem.l d0-d7/a0-a2,-(sp)

    move.b  $ff820a,savehz ; save old frequency
    bset    #1,$ff820a ; set 50Hz

    move.w     #4,-(sp)
    trap       #14
    addq.l     #2,sp

    move.w  d0,saveres

    move.w    #2,-(sp)         ; physical screen base
    trap      #14
    addq.l    #2,sp
    lea.l     pscreen,a0
    move.l    d0,(a0)
    sub.l     #$8000,d0
    lea.l     lscreen,a0
    move.l    d0,(a0)
    ; lea.l     screen(pc),a0
    ; move.l    d0,(a0)

    clr.w     -(sp)            ; niedrige Aufloesung
    moveq.l   #-1,d0
    move.l    pscreen,-(sp) ; phys base
    move.l    pscreen,-(sp) ; log base
    move.w    #5,-(sp)
    trap      #14
    lea.l     12(sp),sp

    ; save standard palette
    movem.l    $ffff8240,d0-d7
    lea        stdpalette,a2
    movem.l    d0-d7,(a2)

    dc.w $A000  ; line a routine
    dc.w $A00A  ; hide mouse
    move.b #$12,$FFFFFC02.w         ; disable mouse

    lea     screentable,a0
    move.l  pscreen,a1

    move.w  #200-1,d0
scrtloop:
    move.l  a1,(a0)+
    adda.l  #160,a1
    dbra    d0,scrtloop

    movem.l (sp)+,d0-d7/a0-a2
    rts

init_vbl:
    move.l  $70.w,oldvbl            ; store old VBL
    move.l  #vbl,$70.w              ; steal VBL
    rts
