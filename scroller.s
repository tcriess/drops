; scroller at the lower screen border
    text
scroller:
    ; this is for the full screen
    ;            add.w        #160*200,a0         ; bottom destination screen
    ;            move.w     #160-8,d0
    ;.loop:
    ;            movem.l    d1-d7/a1-a6,-(a0) ; 13 * 4 = 52 bytes
    ;            movem.l    d1-d7/a1-a6,-(a0) ; 13 * 4 = 52 bytes
    ;            movem.l    d1-d7/a1-a6,-(a0) ; 13 * 4 = 52 bytes
    ;            movem.l    d1-d7/a1-a6,-(a0) ; 13 * 4 = 52 bytes => total 208 bytes per loop repetition
    ;            dbra d0,.loop
    ;            movem.l    d1-d7/a1-a6,-(a0) ; 52 bytes
    ;            movem.l    d1-d7/a1-a6,-(a0) ; 52 bytes
    ;            movem.l    d1-d7/a1-a6,-(a0) ; 52 bytes
    ;            movem.l    d1-d5,-(a0) ; 5 * 4 = 20 bytes => 176 missing bytes at the end
    
                ; movea.l screen_tbl_show,a1
                ; movea.l screen_tbl,a1
    
                ;movea.l 164*4(a1),a6
    movea.l 128*4(a1),a6
    lea.l scrolltable,a1
    
    movea.l tpos,a0         ;THE GOOD BIT,THE BYTE BENDER ROUT!
    
                ;move.w LENGTH,d2
                ;and.w #$001F,d2 ; mask out bit 4-15
                ;add.w d2,d2
                ;lea.l 0(a1,d2.w),a1 ; add offset of shift
    
                ; LEA YPOS,A1
                ; MOVEA.L A1,A6
    moveq #0,d2
    
    move.w #20-1,d1
.l2             ; MOVEA.L (A1)+,A2    ;A2=DESTINATION
    add.w (a1)+,d2
    lea.l 4(a6,d2.w),a2 ; plane 4
    movea.l (a0)+,a3    ;A3=SOURCE
    rept 36
    move.b (a3)+,(a2) ; 12 (2/1) 2
    lea 160(a2),a2 ; 8 (2/0) 4
    endr
    add.w (a1)+,d2
    addq #1,d2
    lea.l 4(a6,d2.w),a2 ; plane 4
    movea.l (a0)+,a3
    rept 36
    move.b (a3)+,(a2)
    lea 160(a2),a2
    endr
    addq #7,d2
    dbf d1,.l2
    addq.l #4,tpos          ;INCREASE POSITION IN TEXT.
                ;1 LONGWORD=8 PIXELS OF TEXT
    subq.w #1,length       ;END OF TEXT?
    bne.s .l3
    move.w #8000-40,length ;8000=2000 CHARACTERS DIVIDED BY 4
    move.l #textab,tpos    ;SET POINTER TO START OF TEXT
.l3
    rts

init_scroller:
    ;ROUT TO CONVERT CHARACTERS
    ;SO THAT THE PROGRAM CAN LOCATE THE
    ;CHARACTERS IN CTAB
    lea text1,a0 ; text -> a0
    lea ctab,a1  ; character tab -> a1
    move.w #0,length ; length -> 0
.A: move.b (a0)+,d0  ; get character from text -> d0
    movea.l a1,a2    ; save character tab address to a2
    moveq #19-1,d1   ; 19 characters in tab
.B: cmp.b (a2)+,d0   ; compare d0 with character in tab
    beq .C           ; found character
    addq.l #1,a2     ; next character in tab
    dbf d1,.B        ; loop
    bra.s .D           ; character not found
.C: move.b (a2),-1(a0) ; replace character in text with index in tab
.D: addq.w #4,length  ; add 4 to length
    cmpi.b #-1,(a0) ; end of text?
    bne .A          ; loop
    subi.w #40,length ; subtract 40 from length (10 chars are shown on the screen)
;     rts

; setup2:  
    move.l #2000-1,d0      ;2000 CHARACTER OF TEXT(TOOK ME AGES!)
    lea textab,a0
    lea font,a1
    lea text1,a2
.L1:    
    move.w #0,d1
    move.b (a2)+,d1
    subi.b #'A',d1
    mulu.w #(4*36),d1       ;4*36=LENGTH OF 1 CHARACTER IN FONT(BYTES)
    lea.l (a1,d1.w),a3
    move.l a3,(a0)+         ;FIRST STRIP OF 8 PIXELS
    lea.l 36(a3),a3         ;1 STRIP = 36 BYTES(EACH CHARACTER IN FONT IS
                            ;36 PIXELS IN HEIGHT, AND 1 BIT PLANE)
    move.l a3,(a0)+         ;SECOND STRIP
    lea.l 36(a3),a3
    move.l a3,(a0)+         ;THIRD STRIP
    lea.l 36(a3),a3
    move.l a3,(a0)+         ;FOURTH STRIP
    dbf d0,.L1

    rts

    data
scrolltable:
    dc.w 0,0,160*2,160*2,160*2,160*2,160*2,160*2,160*2,160*2,160*2,160*2,160*2,160*2,160*2,160*2,160*2,160*2,0,0
    dc.w 0,0,-160*2,-160*2,-160*2,-160*2,-160*2,-160*2,-160*2,-160*2,-160*2,-160*2,-160*2,-160*2,-160*2,-160*2,-160*2,-160*2,0,0

tpos:   dc.l textab                             ;POSITION IN TEXT
length: dc.w 0
ctab:   dc.b '?','['
        dc.b '!','\'
        dc.b '.',']'
        dc.b ',','^'
        dc.b '-','_'
        dc.b ' ',96
        dc.b '(',97
        dc.b ')',98
        dc.b 39,99
        dc.b '0',100,'1',101,'2',102,'3',103,'4',104
        dc.b '5',105,'6',106,'7',107,'8',108,'9',109
        even

;2000 CHARS
text1:
    dc.b "HI! THIS INTRO IS CALLED DROPS, IT SHOWS" ; 1 / 50
    dc.b " WATER RIPPLES CAUSED BY A DROP IN 3D. I" ; 2 / 50
    dc.b "T ALSO SHOWS A SPECTRUM ANALYSIS OF THE " ; 3 / 50
    dc.b " MUSIC, WHICH IS CALLED BUMTARABUM BY DH" ; 4 / 50
    dc.b "OR/MEC, MANY THANKS..... AND ALSO MANY T" ; 5 / 50
    dc.b "HANKS TO GREY FOR MAKING THIS COLLABORAT" ; 6 / 50
    dc.b "ON POSSIBLE (AND FOR SILLYVENTURE IN GEN" ; 7 / 50
    dc.b "ERAL, OF COURSE). GRAPHICS AND PROGRAMMI" ; 8 / 50
    dc.b "NG BY TECER OF HACKNOLOGY, FROM THE BEAU" ; 9 / 50
    dc.b "TIFUL CITY OF KONSTANZ AT, YOU GUESSED I" ; 10 / 50
    dc.b "T, LAKE CONSTANCE.                      " ; 11 / 50
    dc.b "                                        " ; 12 / 50
    dc.b "                                        " ; 13 / 50
    dc.b "                                        " ; 14 / 50
    dc.b "                                        " ; 15 / 50
    dc.b "                                        " ; 16 / 50
    dc.b "                                        " ; 17 / 50
    dc.b "                                        " ; 18 / 50
    dc.b "                                        " ; 19 / 50
    dc.b "                                        " ; 20 / 50
    dc.b "                                        " ; 21 / 50
    dc.b "                                        " ; 22 / 50
    dc.b "                                        " ; 23 / 50
    dc.b "                                        " ; 24 / 50
    dc.b "                                        " ; 25 / 50
    dc.b "                                        " ; 26 / 50
    dc.b "                                        " ; 27 / 50
    dc.b "                                        " ; 28 / 50
    dc.b "                                        " ; 29 / 50
    dc.b "                                        " ; 30 / 50
    dc.b "                                        " ; 31 / 50
    dc.b "                                        " ; 32 / 50
    dc.b "                                        " ; 33 / 50
    dc.b "                                        " ; 34 / 50
    dc.b "                                        " ; 35 / 50
    dc.b "                                        " ; 36 / 50
    dc.b "                                        " ; 37 / 50
    dc.b "                                        " ; 38 / 50
    dc.b "                                        " ; 39 / 50
    dc.b "                                        " ; 40 / 50
    dc.b "                                        " ; 41 / 50
    dc.b "                                        " ; 42 / 50
    dc.b "                                        " ; 43 / 50
    dc.b "                                        " ; 44 / 50
    dc.b "                                        " ; 45 / 50
    dc.b "                                        " ; 46 / 50
    dc.b "                                        " ; 47 / 50
    dc.b "                                        " ; 48 / 50
    dc.b "                                        " ; 49 / 50
    dc.b "                                        " ; 50 / 50
    dc.b -1
    even

    include "font.s"
