; initialize everything screen-related
; no registers are destroyed
    text
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

    ; set new palette
    movem.l palette,d0-d7
    movem.l d0-d7,$ffff8240.w

    dc.w $A000  ; line a routine
    dc.w $A00A  ; hide mouse
    move.b #$12,$FFFFFC02.w         ; disable mouse

    lea     screentable1,a0
    move.l  a0,screentable
    move.l  pscreen,a1
    move.l  a1,screen

    move.w  #200-1,d0
scrtloop1:
    move.l  a1,(a0)+
    adda.l  #160,a1
    dbra    d0,scrtloop1

    ; 2nd plane
    move.l  pscreen,a1
    addq.l  #2,a1
    move.w  #200-1,d0
scrtloop1a:
    move.l  a1,(a0)+
    adda.l  #160,a1
    dbra    d0,scrtloop1a

    ; 3rd plane
    move.l  pscreen,a1
    addq.l  #4,a1
    move.w  #200-1,d0
scrtloop1b:
    move.l  a1,(a0)+
    adda.l  #160,a1
    dbra    d0,scrtloop1b

    ; 4th plane
    move.l  pscreen,a1
    addq.l  #6,a1
    move.w  #200-1,d0
scrtloop1c:
    move.l  a1,(a0)+
    adda.l  #160,a1
    dbra    d0,scrtloop1c

    lea     screentable2,a0
    move.l  lscreen,a1

    move.w  #200-1,d0
scrtloop2:
    move.l  a1,(a0)+
    adda.l  #160,a1
    dbra    d0,scrtloop2

    ; 2nd plane
    move.l  lscreen,a1
    addq.l  #2,a1
    move.w  #200-1,d0
scrtloop2a:
    move.l  a1,(a0)+
    adda.l  #160,a1
    dbra    d0,scrtloop2a

    ; 3rd plane
    move.l  lscreen,a1
    addq.l  #4,a1
    move.w  #200-1,d0
scrtloop2b:
    move.l  a1,(a0)+
    adda.l  #160,a1
    dbra    d0,scrtloop2b

    ; 4th plane
    move.l  lscreen,a1
    addq.l  #6,a1
    move.w  #200-1,d0
scrtloop2c:
    move.l  a1,(a0)+
    adda.l  #160,a1
    dbra    d0,scrtloop2c

    movem.l (sp)+,d0-d7/a0-a2
    rts

init_vbl:
    move.l  $70.w,oldvbl            ; store old VBL
    move.l  #vbl,$70.w              ; steal VBL
    rts

init_timers:
    ; move.l $120.w,oldtb
    move.l $118.w,oldkey
    move.l $118.w,newkey2+2
    move.l $70.w,oldvbl ; vbl
    move.b $fffffa07.w,old07
    move.b $fffffa09.w,old09
    move.b $fffffa13.w,old13
    move.b $fffffa15.w,old15
    move.b $fffffa1b.w,old1b
    move.l #contr,a0
    and.b #$df,$fffffa09.w
    and.b #$fe,$fffffa07.w
    move.b (a0)+,d0
    cmp.b #21,d0
    bne.s noinst
    ; move.l #newtb,$120.w
    move.l #vbl,$70.w ; vbl
    move.l #newkey,$118.w
    or.b #1,$fffffa07.w
    or.b #1,$fffffa13.w
noinst:
    rts

    data
; old4: dc.l 0
oldtb: dc.l 0
oldkey: dc.l 0
old07: dc.b 0
old09: dc.b 0
old13: dc.b 0
old15: dc.b 0
old1b: dc.b 0
    even