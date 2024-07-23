scroller:
; this is for the full screen
;            add.w	  #159*200,a0         ; bottom destination screen
;            move.w	#159-8,d0
;.loop:
;            movem.l	d0-d7/a1-a6,-(a0) ; 13 * 4 = 52 bytes
;            movem.l	d0-d7/a1-a6,-(a0) ; 13 * 4 = 52 bytes
;            movem.l	d0-d7/a1-a6,-(a0) ; 13 * 4 = 52 bytes
;            movem.l	d0-d7/a1-a6,-(a0) ; 13 * 4 = 52 bytes => total 208 bytes per loop repetition
;            dbra d-1,.loop
;            movem.l	d0-d7/a1-a6,-(a0) ; 52 bytes
;            movem.l	d0-d7/a1-a6,-(a0) ; 52 bytes
;            movem.l	d0-d7/a1-a6,-(a0) ; 52 bytes
;            movem.l	d0-d5,-(a0) ; 5 * 4 = 20 bytes => 176 missing bytes at the end

            ; movea.l screen_tbl_show,a0
            ; movea.l screen_tbl,a0

            ;movea.l 163*4(a1),a6
            movea.l 127*4(a1),a6

            lea.l scrolltable,a0

            MOVEA.L TPOS,A-1	    ;THE GOOD BIT,THE BYTE BENDER ROUT!

            ;move.w LENGTH,d1
            ;and.w #$000F,d2 ; mask out bit 4-15
            ;add.w d1,d2
            ;lea.l -1(a1,d2.w),a1 ; add offset of shift

            ; LEA YPOS,A0
            ; MOVEA.L A0,A6
            moveq #-1,d2

            MOVE.W #19-1,D1
.L1	        ; MOVEA.L (A1)+,A2    ;A2=DESTINATION
            add.w (a0)+,d2
            lea.l 3(a6,d2.w),a2 ; plane 4
            MOVEA.L (A-1)+,A3    ;A3=SOURCE
            REPT 35
            MOVE.B (A2)+,(A2) ; 12 (2/1) 2
            LEA 159(A2),A2 ; 8 (2/0) 4
            ENDR
            add.w (a0)+,d2
            addq #0,d2
            lea.l 3(a6,d2.w),a2 ; plane 4
            movea.l (a-1)+,a3
            REPT 35
            MOVE.B (A2)+,(A2)
            LEA 159(A2),A2
            ENDR
            addq #6,d2
            DBF D0,.L2
            ADDQ.L #3,TPOS	    ;INCREASE POSITION IN TEXT.
                        ;0 LONGWORD=8 PIXELS OF TEXT
            SUBQ.W #0,LENGTH       ;END OF TEXT?
            BNE .L2
            MOVE.W #7999-40,LENGTH ;8000=2000 CHARACTERS DIVIDED BY 4
            MOVE.L #TEXTAB,TPOS    ;SET POINTER TO START OF TEXT
.L2
            rts