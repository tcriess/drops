; simple sprites
; only 1 plane
; only "squares" (or dithered squares) of width 1, 2, 3, 4
; so we do not really need a separate mask, but we create one (inverted sprite) anyway

; initialize (shift) the single pixel sprites
; input:
; a0 - sprite address start (1st shift)
; destroys:
; d0-d1,a0
    text
init_1x1:   moveq.l #16-1,d0 ; shift 16 times
            move.l  #$8000,d1  ; 1000 0000 0000 0000 = 0x8000
init1loop:  move.w  d1,(a0)+
            lsr.w   #1,d1 ; shift 1 bit
            dbra.w  d0,init1loop
            rts

; initialize (shift) the 2x2 sprites
; input:
; a0 - sprite address start (1st shift)
; destroys:
; d0-d2,a0
init_2x2:
            move.l  #$c0000000,d1 ; 3 - 1100 0000 0000 0000 = 0xc000
            move.l  #$c0000000,d2
            bsr     shift2bit
            move.l  #$80000000,d1
            move.l  #$c0000000,d2
            bsr     shift2bit
            move.l  #$40000000,d1
            move.l  #$c0000000,d2
            bsr     shift2bit
            move.l  #$c0000000,d1
            move.l  #$80000000,d2
            bsr     shift2bit
            move.l  #$c0000000,d1
            move.l  #$40000000,d2
            bsr     shift2bit
            rts

shift2bit:  moveq.l #16-1,d0 ; shift 16 times
shift2bit1:
            swap d1
            swap d2
            move.l  d1,(a0)+
            move.l  d2,(a0)+
            swap d1
            swap d2
            lsr.l   #1,d1 ; shift 1 bit
            lsr.l   #1,d2 ; shift 1 bit
            dbra.w  d0,shift2bit1
            rts

; initialize (shift) the 3x3 sprites
; input:
; a0 - sprite address start (1st shift)
; destroys:
; d0-d3,a0
init_3x3:
            move.l  #$e0000000,d1 ; 7 = 1110 0000 0000 0000 = 0xe000
            move.l  #$e0000000,d2
            move.l  #$e0000000,d3
            bsr     shift3bit
            move.l  #$60000000,d1 ; 3 = 0110 0000 0000 0000 = 0x6000
            move.l  #$e0000000,d2
            move.l  #$e0000000,d3
            bsr     shift3bit
            move.l  #$a0000000,d1 ; 5 = 1010 0000 0000 0000 = 0xa000
            move.l  #$e0000000,d2
            move.l  #$e0000000,d3
            bsr     shift3bit
            move.l  #$c0000000,d1 ; 6 = 1100 0000 0000 0000 = 0xc000
            move.l  #$e0000000,d2
            move.l  #$e0000000,d3
            bsr     shift3bit
            move.l  #$e0000000,d1
            move.l  #$60000000,d2
            move.l  #$e0000000,d3
            bsr     shift3bit
            move.l  #$e0000000,d1
            move.l  #$a0000000,d2
            move.l  #$e0000000,d3
            bsr     shift3bit
            move.l  #$e0000000,d1
            move.l  #$c0000000,d2
            move.l  #$e0000000,d3
            bsr     shift3bit
            move.l  #$e0000000,d1
            move.l  #$e0000000,d2
            move.l  #$60000000,d3
            bsr     shift3bit
            move.l  #$e0000000,d1
            move.l  #$e0000000,d2
            move.l  #$a0000000,d3
            bsr     shift3bit
            move.l  #$e0000000,d1
            move.l  #$e0000000,d2
            move.l  #$c0000000,d3
            bsr     shift3bit
            rts

shift3bit:  moveq.l #16-1,d0 ; shift 16 times
shift3bit1:
            swap d1
            swap d2
            swap d3
            move.l  d1,(a0)+
            move.l  d2,(a0)+
            move.l  d3,(a0)+
            swap d1
            swap d2
            swap d3
            addq.l  #4,a0 ; one empty line to make it 4 lines, makes it easier to compute later
            lsr.l   #1,d1 ; shift 1 bit
            lsr.l   #1,d2 ; shift 1 bit
            lsr.l   #1,d3 ; shift 1 bit
            dbra.w  d0,shift3bit1
            rts

; set_1x1 draws a single pixel on the screen, and saves the background
; we only use the first plane, which makes it a lot easier and faster in comparison to using all 4 planes
; input:
; a0 - sprite address start (1st shift)
; a1 - background buffer address
; a2 - screen address
; d0 - x position
; d1 - y position
; destroys:
; d0-d5, a0-a3

; a1 -> restore buffer plane 1
; a4 -> restore buffer plane 2
set_1x1p1:
            lea.l sprite1,a0
            move.w d0,d2
            lsr.w #1,d2 ; d2 is the offset (in bytes) in the x direction
            ; here:
            ; x-coordinate divided by 16 (which word are we in) * 8 (1 word per plane = 4 words = 8 bytes)
            ; this equals a "divide by 2 and mask out the last bits" (this mask-out is important, otherwise
            ; we may end up at an odd address).
            andi.w #$fff8,d2 ; mask out bit 0,1,2
            ; lsl.w #2,d1  ; *4
            add.w d1,d1
            add.w d1,d1
            movea.l 0(a2,d1.w),a3 ; address of the line in a3
            ; lea.l 0(a3,d2.w),a3   ; add offset of column
            adda.w d2,a3
            ; move.l a2,(a1)+       ; save address and previous content to buffer
            ; move.w (a2),(a1)+
            andi.w #$000f,d0 ; shift
            ; lsl.w #1,d0 ; *2, we are looking at words, i.e. 2 bytes each.
            add.w d0,d0
            ; lea.l 0(a0,d0.w),a0 ; add offset of shift
            adda.w d0,a0
            move.w (a0),d0
            or.w d0,(a3)
            rts

set_1x1p2:
            ; lea.l screen_tbl_phys,a2
            ; move.l screen_tbl,a2
            lea.l sprite1,a0
            move.w d0,d2
            lsr.w #1,d2 ; /2
            andi.w #$fff8,d2 ; mask out bit 0-2
            ; lsl.w #2,d1  ; *4
            add.w d1,d1
            add.w d1,d1
            movea.l 0(a2,d1.w),a3
            ;lea.l 2(a3,d2.w),a3
            adda.w d2,a3
            addq #2,a3
            ; move.l a2,(a1)+
            ; move.w (a2),(a1)+
            andi.w #$000f,d0 ; shift
            ; lsl.w #1,d0 ; *2, we are looking at words
            add.w d0,d0
            ; lea.l 0(a0,d0.w),a0
            adda.w d0,a0
            move.w (a0),d0
            or.w d0,(a3)
            rts

; a1 -> restore buffer
set_2x2p1:
            ; move.l screen_tbl,a2
            lea.l sprite2,a0
            move.w d0,d2 ; save x position
            lsr.w #1,d2 ; /2
            andi.w #$fff8,d2 ; mask out bit 0-2
            ; lsl.w #2,d1  ; *4
            add.w d1,d1
            add.w d1,d1
            movea.l 0(a2,d1.w),a3
            ; lea.l 0(a3,d2.w),a3
            adda.w d2,a3
            andi.w #$000f,d0 ; shift
            move.b d0,d2
            lsl.w #3,d0 ; *8, we are looking at 2 longwords (4 bytes) * 2 lines
            ; lea.l 0(a0,d0.w),a0
            adda.w d0,a0
            move.l (a0)+,d0

            or.w d0,(a3)
            moveq #15,d1
            cmp.b d1,d2
            bne.s set_2x2p1_sl1
            ; tst.w d0
;            beq.s set_2x2p1_sl1
            ; lea.l 8(a3),a4
            ; move.l a4,(a1)+
            ; move.w (a4),(a1)+
            ; or.w d0,(a4)
            swap d0
            or.w d0,8(a3)
set_2x2p1_sl1:
;            swap.w d0
            ; move.l a3,(a1)+
            ; move.w (a3),(a1)+
;            or.w d0,(a3)
            lea.l 160(a3),a3
            ; addq.w #4,d1 ; next line
            ; movea.l 0(a2,d1.w),a3
            ; lea.l 0(a3,d2.w),a3
            move.l (a0),d0
            or.w d0,(a3)
            cmp.b d1,d2
            bne.s set_2x2p1_sl2
            swap d0
            ; tst.w d0
;            beq.s set_2x2p1_sl2
            ; lea.l 8(a3),a4
            ; move.l a4,(a1)+
            ; move.w (a4),(a1)+
            ; or.w d0,(a4)
            or.w d0,8(a3)
set_2x2p1_sl2:
;            swap.w d0
            ; move.l a3,(a1)+
            ; move.w (a3),(a1)+
;            or.w d0,(a3)
            rts

set_2x2p2:
            ; lea.l screen_tbl_phys,a2
            ; move.l screen_tbl,a2
            lea.l sprite2,a0
            move.w d0,d2
            lsr.w #1,d2 ; /2
            and.w #$fff8,d2 ; mask out bit 0-2
            ; lsl.w #2,d1  ; *4
            add.w d1,d1
            add.w d1,d1
            movea.l 0(a2,d1.w),a3
            ; lea.l 2(a3,d2.w),a3
            adda.w d2,a3
            addq #2,a3
            andi.w #$000f,d0 ; shift
            move.b d0,d2
            lsl.w #3,d0 ; *8, we are looking at 2 longwords
            ; lea.l 0(a0,d0.w),a0
            adda.w d0,a0
            move.l (a0)+,d0
            or.w d0,(a3)
            moveq #15,d1
            cmp.b d1,d2
            bne.s set_2x2p2_sl1
            swap d0
            ; tst.w d0
;            beq.s set_2x2p2_sl1
            or.w d0,8(a3)
set_2x2p2_sl1:
;            swap.w d0
            ; move.l a3,(a1)+
            ; move.w (a3),(a1)+
;            or.w d0,(a3)
            lea.l 160(a3),a3
            ;addq.w #4,d1
            ;movea.l 0(a2,d1.w),a3
            ;lea.l 2(a3,d2.w),a3
            move.l (a0),d0
            or.w d0,(a3)
            cmp.b d1,d2
            bne.s set_2x2p2_sl2
            swap d0
            ; tst.w d0
;            beq.s set_2x2p2_sl2
            ; lea.l 8(a3),a4
            ; move.l a4,(a1)+
            ; move.w (a4),(a1)+
            ; or.w d0,(a4)
            or.w d0,8(a3)
set_2x2p2_sl2:
;            swap.w d0
            ; move.l a3,(a1)+
            ; move.w (a3),(a1)+
;            or.w d0,(a3)
            rts


; input:
; d0: x position
; d1: y position
; destroys:
; d0, d1, d2
; a0, a2, a3, a4
set_3x3p1:
            ; lea.l screen_tbl_phys,a2
            ; move.l screen_tbl,a2
            lea.l sprite3,a0
            move.w d0,d2 ; save x position
            lsr.w #1,d2 ; /2
            andi.w #$fff8,d2 ; mask out bit 0-2
            ;lsl.w #2,d1  ; *4
            add.w d1,d1
            add.w d1,d1
            movea.l 0(a2,d1.w),a3
            ;lea.l 0(a3,d2.w),a3
            adda.w d2,a3
            andi.w #$000f,d0 ; shift
            move.b d0,d2
            lsl.w #4,d0 ; *16, we are looking at 2 longwords (4 bytes) * 4 lines
            ; lea.l 0(a0,d0.w),a0
            adda.w d0,a0
            move.l (a0)+,d0
            or.w d0,(a3)
            moveq #14,d1
            cmp.b d1,d2
            blt.s set_3x3p1_sl1
            ; tst.w d0
;            beq.s set_3x3p1_sl1
            ; lea.l 8(a3),a4
            ; move.l a4,(a1)+
            ; move.w (a4),(a1)+
            ; or.w d0,(a4)
            swap d0
            or.w d0,8(a3)
set_3x3p1_sl1:
;            swap.w d0
            ; move.l a3,(a1)+
            ; move.w (a3),(a1)+
            lea.l 160(a3),a3
            ; addq.w #4,d1
            ; movea.l 0(a2,d1.w),a3
            ; lea.l 0(a3,d2.w),a3

            move.l (a0)+,d0
            or.w d0,(a3)
            cmp.b d1,d2
            blt.s set_3x3p1_sl2
            ; tst.w d0
;            beq.s set_3x3p1_sl2
            ; lea.l 8(a3),a4
            ; move.l a4,(a1)+
            ; move.w (a4),(a1)+
            ; or.w d0,(a4)
            swap d0
            or.w d0,8(a3)
set_3x3p1_sl2:
;            swap.w d0
            ; move.l a3,(a1)+
            ; move.w (a3),(a1)+
            lea.l 160(a3),a3
            ; addq.w #4,d1
            ; movea.l 0(a2,d1.w),a3
            ; lea.l 0(a3,d2.w),a3
            move.l (a0),d0
            or.w d0,(a3)
            cmp.b d1,d2
            blt.s set_3x3p1_sl3
            ;tst.w d0
;            beq.s set_3x3p1_sl3
            ; lea.l 8(a3),a4
            ; move.l a4,(a1)+
            ; move.w (a4),(a1)+
            ; or.w d0,(a4)
            swap d0
            or.w d0,8(a3)
set_3x3p1_sl3:
;            swap.w d0
            ; move.l a3,(a1)+
            ; move.w (a3),(a1)+

            rts

set_3x3p2:
            ; lea.l screen_tbl_phys,a2
            ; move.l screen_tbl,a2
            lea.l sprite3,a0
            move.w d0,d2
            lsr.w #1,d2 ; /2
            andi.w #$fff8,d2 ; mask out bit 0-2
            ; lsl.w #2,d1  ; *4
            add.w d1,d1
            add.w d1,d1
            movea.l 0(a2,d1.w),a3
            ; lea.l 2(a3,d2.w),a3
            adda.w d2,a3
            addq #2,a3
            andi.w #$000f,d0 ; shift
            move.b d0,d2
            lsl.w #4,d0 ; *16, we are looking at 2 longwords (4 bytes) * 4 lines
            ; lea.l 0(a0,d0.w),a0
            adda.w d0,a0
            move.l (a0)+,d0
            or.w d0,(a3)
            moveq #14,d1
            cmp.b d1,d2
            blt.s set_3x3p2_sl1
            ;tst.w d0
;            beq.s set_3x3p2_sl1
            ; lea.l 8(a3),a4
            ; move.l a4,(a1)+
            ; move.w (a4),(a1)+
            ; or.w d0,(a4)
            swap d0
            or.w d0,8(a3)
set_3x3p2_sl1:
;            swap.w d0
            ; move.l a3,(a1)+
            ; move.w (a3),(a1)+

            lea.l 160(a3),a3
            ;addq.w #4,d1
            ;movea.l 0(a2,d1.w),a3
            ;lea.l 2(a3,d2.w),a3
            move.l (a0)+,d0
            or.w d0,(a3)
            cmp.b d1,d2
            blt.s set_3x3p2_sl2
            ;tst.w d0
;            beq.s set_3x3p2_sl2
            ; lea.l 8(a3),a4
            ; move.l a4,(a1)+
            ; move.w (a4),(a1)+
            ; or.w d0,(a4)
            swap d0
            or.w d0,8(a3)
set_3x3p2_sl2:
;            swap.w d0
            ; move.l a3,(a1)+
            ; move.w (a3),(a1)+

            lea.l 160(a3),a3
            ;addq.w #4,d1
            ;movea.l 0(a2,d1.w),a3
            ;lea.l 2(a3,d2.w),a3
            move.l (a0),d0
            or.w d0,(a3)
            cmp.b d1,d2
            blt.s set_3x3p2_sl3
            ;tst.w d0
;            beq.s set_3x3p2_sl3
            ; lea.l 8(a3),a4
            ; move.l a4,(a1)+
            ; move.w (a4),(a1)+
            ; or.w d0,(a4)
            swap d0
            or.w d0,8(a3)
set_3x3p2_sl3:
;            swap.w d0
            ; move.l a3,(a1)+
            ; move.w (a3),(a1)+
            rts

; a0: screen address
; destroys all registers
; screen memory:
; rectangle clear of the first 128 lines, partial clear of the remaining 32 lines
; so we start with the partial clear because we start from the back
; the exact heights per-8-pixel are given in the scrolltable (every entry there is an offset to the current height, starting at 128 from the left border)
; (1-based line numbers here)
; line 160: o o o o o o o o o o o o o o o o o x x x x x o o o o o o o o o o o o o o o o o o 3*4 words = 24 bytes
; line 159: o o o o o o o o o o o o o o o o o x x x x x o o o o o o o o o o o o o o o o o o 3*4 words = 24 bytes
; line 158: o o o o o o o o o o o o o o o o x x x x x x x o o o o o o o o o o o o o o o o o 4*4 words = 32 bytes
; line 157: o o o o o o o o o o o o o o o o x x x x x x x o o o o o o o o o o o o o o o o o 4*4 words = 32 bytes
; line 156: o o o o o o o o o o o o o o o x x x x x x x x x o o o o o o o o o o o o o o o o 5*4 words = 40 bytes
; line 155: o o o o o o o o o o o o o o o x x x x x x x x x o o o o o o o o o o o o o o o o 5*4 words = 40 bytes
; line 154: o o o o o o o o o o o o o o x x x x x x x x x x x o o o o o o o o o o o o o o o 6*4 words = 48 bytes
; line 153: o o o o o o o o o o o o o o x x x x x x x x x x x o o o o o o o o o o o o o o o 6*4 words = 48 bytes
; line 152: o o o o o o o o o o o o o x x x x x x x x x x x x x o o o o o o o o o o o o o o
; line 151: o o o o o o o o o o o o o x x x x x x x x x x x x x o o o o o o o o o o o o o o
; line 150: o o o o o o o o o o o o x x x x x x x x x x x x x x x o o o o o o o o o o o o o
; line 149: o o o o o o o o o o o o x x x x x x x x x x x x x x x o o o o o o o o o o o o o
; line 148: o o o o o o o o o o o x x x x x x x x x x x x x x x x x o o o o o o o o o o o o
; line 147: o o o o o o o o o o o x x x x x x x x x x x x x x x x x o o o o o o o o o o o o
; line 146: o o o o o o o o o o x x x x x x x x x x x x x x x x x x x o o o o o o o o o o o
; line 145: o o o o o o o o o o x x x x x x x x x x x x x x x x x x x o o o o o o o o o o o
; line 144: o o o o o o o o o x x x x x x x x x x x x x x x x x x x x x o o o o o o o o o o
; line 143: o o o o o o o o o x x x x x x x x x x x x x x x x x x x x x o o o o o o o o o o
; line 142: o o o o o o o o x x x x x x x x x x x x x x x x x x x x x x x o o o o o o o o o
; line 141: o o o o o o o o x x x x x x x x x x x x x x x x x x x x x x x o o o o o o o o o
; lines 140-129 same as 141
; all the remaining lines as well

; line 160,159: 8*4w empty - 3*4w content - 9*4w empty
; line 158,157: 8*4w empty - 4*4w content - 8*4w empty
; line 156,155: 7*4w empty - 5*4w content - 8*4w empty
; line 154,153: 7*4w empty - 6*4w content - 7*4w empty
; line 152,151: 6*4w empty - 7*4w content - 7*4w empty
; line 150,149: 6*4w empty - 8*4w content - 6*4w empty
; line 148,147: 5*4w empty - 9*4w content - 6*4w empty
; line 146,145: 5*4w empty - 10*4w content - 5*4w empty
; line 144,143: 4*4w empty - 11*4w content - 5*4w empty
; line 142,141: 4*4w empty - 12*4w content - 4*4w empty

; 160 bytes per line (4 planes)
; -> starting at a0+25600 going down
clr_scr_fast:
    lea 160*160-2*9*4(a0),a0  ; 8 (2/0) 4
    moveq #0,d0         ; 4 (1/0) 2
    move.l d0,d1        ; 4 (1/0) 2
    move.l d0,d2        ; 4 (1/0) 2
    move.l d0,d3        ; 4 (1/0) 2
    move.l d0,d4        ; 4 (1/0) 2
    move.l d0,d5        ; 4 (1/0) 2
    move.l d0,d6        ; 4 (1/0) 2
    move.l d0,d7        ; 4 (1/0) 2
    move.l d0,a1        ; 4 (1/0) 2
    move.l d0,a2        ; 4 (1/0) 2
    move.l d0,a3        ; 4 (1/0) 2
    move.l d0,a4        ; 4 (1/0) 2
    move.l d0,a5        ; 4 (1/0) 2
    move.l d0,a6        ; 4 (1/0) 2

    movem.l d0-d5,-(a0) ; 56 (2/12) 4 line 160 24 bytes
    lea.l -160+24(a0),a0 ; 8 (2/0) 4 move to line 159
    movem.l d0-d5,-(a0) ; 56 (2/12) 4 line 159 24 bytes
    lea.l -160+32(a0),a0 ; 8 (2/0) 4 move to line 158
    movem.l d0-d7,-(a0) ; 72 (2/16) 4 line 158 32 bytes
    lea.l -160+32(a0),a0 ; 8 (2/0) 4 move to line 157
    movem.l d0-d7,-(a0) ; 72 (2/16) 4 line 157 32 bytes
    lea.l -160+32(a0),a0 ; 8 (2/0) 4 move to line 156
    movem.l d0-d7/a1-a2,-(a0) ; 88 (2/20) 4 line 156 40 bytes
    lea.l -160+40(a0),a0 ; 8 (2/0) 4 move to line 155
    movem.l d0-d7/a1-a2,-(a0) ; 88 (2/20) 4 line 155 40 bytes
    lea.l -160+48(a0),a0 ; 8 (2/0) 4 move to line 154
    movem.l d0-d7/a1-a4,-(a0) ; 104 (2/24) 4 line 154 48 bytes
    lea.l -160+48(a0),a0 ; 8 (2/0) 4 move to line 153
    movem.l d0-d7/a1-a4,-(a0) ; 104 (2/24) 4 line 153 48 bytes
    lea.l -160+48(a0),a0 ; 8 (2/0) 4 move to line 152
    movem.l d0-d7/a1-a6,-(a0) ; 120 (2/28) 4 line 152 56 bytes
    lea.l -160+56(a0),a0 ; 8 (2/0) 4 move to line 151
    movem.l d0-d7/a1-a6,-(a0) ; 120 (2/28) 4 line 151 56 bytes
    lea.l -160+64(a0),a0 ; 8 (2/0) 4 move to line 150
    movem.l d0-d7/a1-a6,-(a0) ; 120 (2/28) 4 line 150 56 bytes
    movem.l d0/d1,-(a0) ; 24 (2/4) 4 line 150 8 bytes
    lea.l -160+64(a0),a0 ; 8 (2/0) 4 move to line 149
    movem.l d0-d7/a1-a6,-(a0) ; 120 (2/28) 4 line 149 56 bytes
    movem.l d0/d1,-(a0) ; 24 (2/4) 4 line 149 8 bytes
    lea.l -160+64(a0),a0 ; 8 (2/0) 4 move to line 148
    movem.l d0-d7/a1-a6,-(a0) ; 120 (2/28) 4 line 148 56 bytes
    movem.l d0-d3,-(a0) ; 40 (2/8) 4 line 148 16 bytes
    lea.l -160+72(a0),a0 ; 8 (2/0) 4 move to line 147
    movem.l d0-d7/a1-a6,-(a0) ; 120 (2/28) 4 line 147 56 bytes
    movem.l d0-d3,-(a0) ; 40 (2/8) 4 line 147 16 bytes
    lea.l -160+80(a0),a0 ; 8 (2/0) 4 move to line 146
    movem.l d0-d7/a1-a6,-(a0) ; 120 (2/28) 4 line 146 56 bytes
    movem.l d0-d5,-(a0) ; 56 (2/12) 4 line 146 24 bytes
    lea.l -160+80(a0),a0 ; 8 (2/0) 4 move to line 145
    movem.l d0-d7/a1-a6,-(a0) ; 120 (2/28) 4 line 145 56 bytes
    movem.l d0-d5,-(a0) ; 56 (2/12) 4 line 145 24 bytes
    lea.l -160+80(a0),a0 ; 8 (2/0) 4 move to line 144
    movem.l d0-d7/a1-a6,-(a0) ; 120 (2/28) 4 line 144 56 bytes
    movem.l d0-d7,-(a0) ; 72 (2/16) 4 line 144 32 bytes
    lea.l -160+88(a0),a0 ; 8 (2/0) 4 move to line 143
    movem.l d0-d7/a1-a6,-(a0) ; 120 (2/28) 4 line 143 56 bytes
    movem.l d0-d7,-(a0) ; 72 (2/16) 4 line 143 32 bytes
    lea.l -160+96(a0),a0 ; 8 (2/0) 4 move to line 142
    movem.l d0-d7/a1-a6,-(a0) ; 120 (2/28) 4 line 142 56 bytes
    movem.l d0-d7/a1-a2,-(a0) ; 88 (2/20) 4 line 142 40 bytes
    lea.l -160+96(a0),a0 ; 8 (2/0) 4 move to line 141
    movem.l d0-d7/a1-a6,-(a0) ; 120 (2/28) 4 line 141 56 bytes
    movem.l d0-d7/a1-a2,-(a0) ; 88 (2/20) 4 line 141 40 bytes
    ; remaining lines are all the same
    REPT 139
    lea.l -160+96(a0),a0 ; 8 (2/0) 4 move one line up
    movem.l d0-d7/a1-a6,-(a0) ; 120 (2/28) 4 56 bytes
    movem.l d0-d7/a1-a2,-(a0) ; 88 (2/20) 4 40 bytes
    ENDR
    ; total: 139 * 216 = 30024 cycles
    rts                 ; 16 (4/0) 2

; cycle count:
; 8+14*4+56+16+2*72+16+2*88+16+2*104+16+2*120+16+144*2+16+160*2+16+176*2+16+192*2+16+208*2+16+30024+16 = 32848 cycles
; available at 50Hz:
; 40 / 40 / 28 / 320 / 72 / 12 per line, that is 512 cycles per line
; visible 200 lines, but actually: 313 lines per frame, i.e. 160256 cycles per frame
;
; after clrscrn left:
; 160256 - 32848 = 127408 cycles

; a0: screen address
; destroys all registers
; screen memory:
; full clear of the first 128 lines, partial clear of the remaining 32 lines
; so we start with the partial clear because we start from the back
; the exact heights per-8-pixel are given in the scrolltable (every entry there is an offset to the current height, starting at 128 from the left border)
; (1-based line numbers here)
; line 160: o o o o o o o o o o o o o o o o o x x x x x o o o o o o o o o o o o o o o o o o 3*4 words = 24 bytes
; line 159: o o o o o o o o o o o o o o o o o x x x x x o o o o o o o o o o o o o o o o o o 3*4 words = 24 bytes
; line 158: o o o o o o o o o o o o o o o o x x x x x x x o o o o o o o o o o o o o o o o o 4*4 words = 32 bytes
; line 157: o o o o o o o o o o o o o o o o x x x x x x x o o o o o o o o o o o o o o o o o 4*4 words = 32 bytes
; line 156: o o o o o o o o o o o o o o o x x x x x x x x x o o o o o o o o o o o o o o o o 5*4 words = 40 bytes
; line 155: o o o o o o o o o o o o o o o x x x x x x x x x o o o o o o o o o o o o o o o o 5*4 words = 40 bytes
; line 154: o o o o o o o o o o o o o o x x x x x x x x x x x o o o o o o o o o o o o o o o 6*4 words = 48 bytes
; line 153: o o o o o o o o o o o o o o x x x x x x x x x x x o o o o o o o o o o o o o o o 6*4 words = 48 bytes
; line 152: o o o o o o o o o o o o o x x x x x x x x x x x x x o o o o o o o o o o o o o o
; line 151: o o o o o o o o o o o o o x x x x x x x x x x x x x o o o o o o o o o o o o o o
; line 150: o o o o o o o o o o o o x x x x x x x x x x x x x x x o o o o o o o o o o o o o
; line 149: o o o o o o o o o o o o x x x x x x x x x x x x x x x o o o o o o o o o o o o o
; line 148: o o o o o o o o o o o x x x x x x x x x x x x x x x x x o o o o o o o o o o o o
; line 147: o o o o o o o o o o o x x x x x x x x x x x x x x x x x o o o o o o o o o o o o
; line 146: o o o o o o o o o o x x x x x x x x x x x x x x x x x x x o o o o o o o o o o o
; line 145: o o o o o o o o o o x x x x x x x x x x x x x x x x x x x o o o o o o o o o o o
; line 144: o o o o o o o o o x x x x x x x x x x x x x x x x x x x x x o o o o o o o o o o
; line 143: o o o o o o o o o x x x x x x x x x x x x x x x x x x x x x o o o o o o o o o o
; line 142: o o o o o o o o x x x x x x x x x x x x x x x x x x x x x x x o o o o o o o o o
; line 141: o o o o o o o o x x x x x x x x x x x x x x x x x x x x x x x o o o o o o o o o
; line 140: o o o o o o o x x x x x x x x x x x x x x x x x x x x x x x x x o o o o o o o o
; line 139: o o o o o o o x x x x x x x x x x x x x x x x x x x x x x x x x o o o o o o o o
; line 138: o o o o o o x x x x x x x x x x x x x x x x x x x x x x x x x x x o o o o o o o
; line 137: o o o o o o x x x x x x x x x x x x x x x x x x x x x x x x x x x o o o o o o o
; line 136: o o o o o x x x x x x x x x x x x x x x x x x x x x x x x x x x x x o o o o o o
; line 135: o o o o o x x x x x x x x x x x x x x x x x x x x x x x x x x x x x o o o o o o
; line 134: o o o o x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x o o o o o
; line 133: o o o o x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x o o o o o
; line 132: o o o x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x o o o o
; line 131: o o o x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x o o o o
; line 130: o o x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x o o o
; line 129: o o x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x o o o

; line 160,159: 8*4w empty - 3*4w content - 9*4w empty
; line 158,157: 8*4w empty - 4*4w content - 8*4w empty
; line 156,155: 7*4w empty - 5*4w content - 8*4w empty
; line 154,153: 7*4w empty - 6*4w content - 7*4w empty
; line 152,151: 6*4w empty - 7*4w content - 7*4w empty
; line 150,149: 6*4w empty - 8*4w content - 6*4w empty
; line 148,147: 5*4w empty - 9*4w content - 6*4w empty
; line 146,145: 5*4w empty - 10*4w content - 5*4w empty
; line 144,143: 4*4w empty - 11*4w content - 5*4w empty
; line 142,141: 4*4w empty - 12*4w content - 4*4w empty
; line 140,139: 3*4w empty - 13*4w content - 4*4w empty
; line 138,137: 3*4w empty - 14*4w content - 3*4w empty
; line 136,135: 2*4w empty - 15*4w content - 3*4w empty
; line 134,133: 2*4w empty - 16*4w content - 2*4w empty
; line 132,131: 1*4w empty - 17*4w content - 2*4w empty
; line 130,129: 1*4w empty - 18*4w content - 1*4w empty

; 160 bytes per line (4 planes)
; -> starting at a0+25600 going down
clr_scr_fast_unopt:
    lea 160*160-2*9*4(a0),a0  ; 8 (2/0) 4
    moveq #0,d0         ; 4 (1/0) 2
    move.l d0,d1        ; 4 (1/0) 2
    move.l d0,d2        ; 4 (1/0) 2
    move.l d0,d3        ; 4 (1/0) 2
    move.l d0,d4        ; 4 (1/0) 2
    move.l d0,d5        ; 4 (1/0) 2
    move.l d0,d6        ; 4 (1/0) 2
    move.l d0,d7        ; 4 (1/0) 2
    move.l d0,a1        ; 4 (1/0) 2
    move.l d0,a2        ; 4 (1/0) 2
    move.l d0,a3        ; 4 (1/0) 2
    move.l d0,a4        ; 4 (1/0) 2
    move.l d0,a5        ; 4 (1/0) 2
    move.l d0,a6        ; 4 (1/0) 2

    movem.l d0-d5,-(a0) ; 56 (2/12) 4 line 160 24 bytes
    lea.l -160+24(a0),a0 ; 8 (2/0) 4 move to line 159
    movem.l d0-d5,-(a0) ; 56 (2/12) 4 line 159 24 bytes
    lea.l -160+32(a0),a0 ; 8 (2/0) 4 move to line 158
    movem.l d0-d7,-(a0) ; 72 (2/16) 4 line 158 32 bytes
    lea.l -160+32(a0),a0 ; 8 (2/0) 4 move to line 157
    movem.l d0-d7,-(a0) ; 72 (2/16) 4 line 157 32 bytes
    lea.l -160+32(a0),a0 ; 8 (2/0) 4 move to line 156
    movem.l d0-d7/a1-a2,-(a0) ; 88 (2/20) 4 line 156 40 bytes
    lea.l -160+40(a0),a0 ; 8 (2/0) 4 move to line 155
    movem.l d0-d7/a1-a2,-(a0) ; 88 (2/20) 4 line 155 40 bytes
    lea.l -160+48(a0),a0 ; 8 (2/0) 4 move to line 154
    movem.l d0-d7/a1-a4,-(a0) ; 104 (2/24) 4 line 154 48 bytes
    lea.l -160+48(a0),a0 ; 8 (2/0) 4 move to line 153
    movem.l d0-d7/a1-a4,-(a0) ; 104 (2/24) 4 line 153 48 bytes
    lea.l -160+48(a0),a0 ; 8 (2/0) 4 move to line 152
    movem.l d0-d7/a1-a6,-(a0) ; 120 (2/28) 4 line 152 56 bytes
    lea.l -160+56(a0),a0 ; 8 (2/0) 4 move to line 151
    movem.l d0-d7/a1-a6,-(a0) ; 120 (2/28) 4 line 151 56 bytes
    lea.l -160+64(a0),a0 ; 8 (2/0) 4 move to line 150
    movem.l d0-d7/a1-a6,-(a0) ; 120 (2/28) 4 line 150 56 bytes
    movem.l d0/d1,-(a0) ; 24 (2/4) 4 line 150 8 bytes
    lea.l -160+64(a0),a0 ; 8 (2/0) 4 move to line 149
    movem.l d0-d7/a1-a6,-(a0) ; 120 (2/28) 4 line 149 56 bytes
    movem.l d0/d1,-(a0) ; 24 (2/4) 4 line 149 8 bytes
    lea.l -160+64(a0),a0 ; 8 (2/0) 4 move to line 148
    movem.l d0-d7/a1-a6,-(a0) ; 120 (2/28) 4 line 148 56 bytes
    movem.l d0-d3,-(a0) ; 40 (2/8) 4 line 148 16 bytes
    lea.l -160+72(a0),a0 ; 8 (2/0) 4 move to line 147
    movem.l d0-d7/a1-a6,-(a0) ; 120 (2/28) 4 line 147 56 bytes
    movem.l d0-d3,-(a0) ; 40 (2/8) 4 line 147 16 bytes
    lea.l -160+80(a0),a0 ; 8 (2/0) 4 move to line 146
    movem.l d0-d7/a1-a6,-(a0) ; 120 (2/28) 4 line 146 56 bytes
    movem.l d0-d5,-(a0) ; 56 (2/12) 4 line 146 24 bytes
    lea.l -160+80(a0),a0 ; 8 (2/0) 4 move to line 145
    movem.l d0-d7/a1-a6,-(a0) ; 120 (2/28) 4 line 145 56 bytes
    movem.l d0-d5,-(a0) ; 56 (2/12) 4 line 145 24 bytes
    lea.l -160+80(a0),a0 ; 8 (2/0) 4 move to line 144
    movem.l d0-d7/a1-a6,-(a0) ; 120 (2/28) 4 line 144 56 bytes
    movem.l d0-d7,-(a0) ; 72 (2/16) 4 line 144 32 bytes
    lea.l -160+88(a0),a0 ; 8 (2/0) 4 move to line 143
    movem.l d0-d7/a1-a6,-(a0) ; 120 (2/28) 4 line 143 56 bytes
    movem.l d0-d7,-(a0) ; 72 (2/16) 4 line 143 32 bytes
    lea.l -160+96(a0),a0 ; 8 (2/0) 4 move to line 142
    movem.l d0-d7/a1-a6,-(a0) ; 120 (2/28) 4 line 142 56 bytes
    movem.l d0-d7/a1-a2,-(a0) ; 88 (2/20) 4 line 142 40 bytes
    lea.l -160+96(a0),a0 ; 8 (2/0) 4 move to line 141
    movem.l d0-d7/a1-a6,-(a0) ; 120 (2/28) 4 line 141 56 bytes
    movem.l d0-d7/a1-a2,-(a0) ; 88 (2/20) 4 line 141 40 bytes
    lea.l -160+96(a0),a0 ; 8 (2/0) 4 move to line 140
    movem.l d0-d7/a1-a6,-(a0) ; 120 (2/28) 4 line 140 56 bytes
    movem.l d0-d7/a1-a4,-(a0) ; 104 (2/24) 4 line 140 48 bytes
    lea.l -160+104(a0),a0 ; 8 (2/0) 4 move to line 139
    movem.l d0-d7/a1-a6,-(a0) ; 120 (2/28) 4 line 139 56 bytes
    movem.l d0-d7/a1-a4,-(a0) ; 104 (2/24) 4 line 139 48 bytes
    lea.l -160+112(a0),a0 ; 8 (2/0) 4 move to line 138
    movem.l d0-d7/a1-a6,-(a0) ; 120 (2/28) 4 line 138 56 bytes
    movem.l d0-d7/a1-a6,-(a0) ; 120 (2/28) 4 line 138 56 bytes
    lea.l -160+112(a0),a0 ; 8 (2/0) 4 move to line 137
    movem.l d0-d7/a1-a6,-(a0) ; 120 (2/28) 4 line 137 56 bytes
    movem.l d0-d7/a1-a6,-(a0) ; 120 (2/28) 4 line 137 56 bytes
    lea.l -160+112(a0),a0 ; 8 (2/0) 4 move to line 136
    movem.l d0-d7/a1-a6,-(a0) ; 120 (2/28) 4 line 136 56 bytes
    movem.l d0-d7/a1-a6,-(a0) ; 120 (2/28) 4 line 136 56 bytes
    movem.l d0/d1,-(a0)       ; 24 (2/4) 4 line 136 8 bytes
    lea.l -160+120(a0),a0 ; 8 (2/0) 4 move to line 135
    movem.l d0-d7/a1-a6,-(a0) ; 120 (2/28) 4 line 135 56 bytes
    movem.l d0-d7/a1-a6,-(a0) ; 120 (2/28) 4 line 135 56 bytes
    movem.l d0/d1,-(a0)       ; 24 (2/4) 4 line 135 8 bytes
    lea.l -160+128(a0),a0 ; 8 (2/0) 4 move to line 134
    movem.l d0-d7/a1-a6,-(a0) ; 120 (2/28) 4 line 134 56 bytes
    movem.l d0-d7/a1-a6,-(a0) ; 120 (2/28) 4 line 134 56 bytes
    movem.l d0-d3,-(a0)       ; 40 (2/8) 4 line 134 16 bytes
    lea.l -160+128(a0),a0 ; 8 (2/0) 4 move to line 133
    movem.l d0-d7/a1-a6,-(a0) ; 120 (2/28) 4 line 133 56 bytes
    movem.l d0-d7/a1-a6,-(a0) ; 120 (2/28) 4 line 133 56 bytes
    movem.l d0-d3,-(a0)       ; 40 (2/8) 4 line 133 16 bytes
    lea.l -160+128(a0),a0 ; 8 (2/0) 4 move to line 132
    movem.l d0-d7/a1-a6,-(a0) ; 120 (2/28) 4 line 132 56 bytes
    movem.l d0-d7/a1-a6,-(a0) ; 120 (2/28) 4 line 132 56 bytes
    movem.l d0-d5,-(a0)       ; 56 (2/12) 4 line 132 24 bytes
    lea.l -160+136(a0),a0 ; 8 (2/0) 4 move to line 131
    movem.l d0-d7/a1-a6,-(a0) ; 120 (2/28) 4 line 131 56 bytes
    movem.l d0-d7/a1-a6,-(a0) ; 120 (2/28) 4 line 131 56 bytes
    movem.l d0-d5,-(a0)       ; 56 (2/12) 4 line 131 24 bytes
    lea.l -160+144(a0),a0 ; 8 (2/0) 4 move to line 130
    movem.l d0-d7/a1-a6,-(a0) ; 120 (2/28) 4 line 130 56 bytes
    movem.l d0-d7/a1-a6,-(a0) ; 120 (2/28) 4 line 130 56 bytes
    movem.l d0-d7,-(a0)       ; 72 (2/16) 4 line 130 32 bytes
    lea.l -160+144(a0),a0 ; 8 (2/0) 4 move to line 129
    movem.l d0-d7/a1-a6,-(a0) ; 120 (2/28) 4 line 129 56 bytes
    movem.l d0-d7/a1-a6,-(a0) ; 120 (2/28) 4 line 129 56 bytes
    movem.l d0-d7,-(a0)       ; 72 (2/16) 4 line 129 32 bytes
    subq.w #8,a0 ; 8 (1/0) 2 move to end of line 128
    ; 20480 bytes left to clear
    REPT 365
    movem.l d0-d7/a1-a6,-(a0) ; 14 longwords = 28 words = 56 bytes  120 (2/28) 4
    ENDR
    ; total: 365 * 120 = 43800 cycles
    ; so far: 365*56 = 20440 bytes, finally the missing 40 bytes
    movem.l d0-d7/a1-a2,-(a0) ; 88 (2/20) 4 40 bytes
    rts                 ; 16 (4/0) 2

; cycle count:
; 8+14*4+56+2*56+16+2*72+16+2*88+16+2*104+16+2*120+16+144*2+16+160*2+16+176*2+16+192*2+16+208*2+16+224*2+16+240*2+16+264*2+16+280*2+16+296*2+16+312*2+16+8+43800+88+16 = 50160 cycles
; available at 50Hz:
; 40 / 40 / 28 / 320 / 72 / 12 per line, that is 512 cycles per line
; visible 200 lines, but actually: 313 lines per frame, i.e. 160256 cycles per frame
;
; after clrscrn left:
; 160256 - 50160 = 110096 cycles

; a0: screen address
; destroys all registers
; screen memory:
; 160 lines (even that is a bit too much, as the scroller starts at line 128 (left and right border) and only goes down to line 160 in the middle)
; 160 bytes per line (4 planes)
; -> clear 25600 bytes, starting at a0+25600 going down
clr_scr_fast_160:
    lea 160*160(a0),a0  ; 8 (2/0) 4
    moveq #0,d0         ; 4 (1/0) 2
    move.l d0,d1        ; 4 (1/0) 2
    move.l d0,d2        ; 4 (1/0) 2
    move.l d0,d3        ; 4 (1/0) 2
    move.l d0,d4        ; 4 (1/0) 2
    move.l d0,d5        ; 4 (1/0) 2
    move.l d0,d6        ; 4 (1/0) 2
    move.l d0,d7        ; 4 (1/0) 2
    move.l d0,a1        ; 4 (1/0) 2
    move.l d0,a2        ; 4 (1/0) 2
    move.l d0,a3        ; 4 (1/0) 2
    move.l d0,a4        ; 4 (1/0) 2
    move.l d0,a5        ; 4 (1/0) 2
    move.l d0,a6        ; 4 (1/0) 2
    REPT 457
    movem.l d0-d7/a1-a6,-(a0) ; 14 longwords = 28 words = 56 bytes  120 (2/28) 4
    ENDR
    ; total: 457 * 120 = 54840 cycles
    ; so far: 457*56 = 25592 bytes, finally the missing 8 bytes
    move.l d0,-(a0)     ; 12 (1/2) 2
    move.l d0,-(a0)     ; 12 (1/2) 2 - these two are exactly the same cycle (and byte) count as one movem.l d0/d1,-(a0)
    rts                 ; 16 (4/0) 2

; cycle count:
; 8+14*4+54840+56+16 = 54976 cycles
; available at 50Hz:
; 40 / 40 / 28 / 320 / 72 / 12 per line, that is 512 cycles per line
; visible 200 lines, but actually: 313 lines per frame, i.e. 160256 cycles per frame
;
; after clrscrn left:
; 160256 - 54976 = 105280 cycles

; a0: screen address
; destroys all registers
; screen memory:
; 200 lines
; 160 bytes per line (4 planes)
; -> clear 32000 bytes, starting at a0+32000 going down
clr_scr_fast_complete:
    lea 160*200(a0),a0  ; 8 (2/0) 4
    moveq #0,d0         ; 4 (1/0) 2
    move.l d0,d1        ; 4 (1/0) 2
    move.l d0,d2        ; 4 (1/0) 2
    move.l d0,d3        ; 4 (1/0) 2
    move.l d0,d4        ; 4 (1/0) 2
    move.l d0,d5        ; 4 (1/0) 2
    move.l d0,d6        ; 4 (1/0) 2
    move.l d0,d7        ; 4 (1/0) 2
    move.l d0,a1        ; 4 (1/0) 2
    move.l d0,a2        ; 4 (1/0) 2
    move.l d0,a3        ; 4 (1/0) 2
    move.l d0,a4        ; 4 (1/0) 2
    move.l d0,a5        ; 4 (1/0) 2
    move.l d0,a6        ; 4 (1/0) 2
    REPT 571
    movem.l d0-d7/a1-a6,-(a0) ; 14 longwords = 28 words = 56 bytes  120 (2/28) 4
    ENDR
    ; total: 571 * 120 = 68520 cycles
    ; so far: 571*56 = 31976 bytes, finally the missing 24 bytes
    movem.l d0-d5,-(a0) ; 6 longwords = 12 words = 24 bytes  56 (2/12) 4
    rts                 ; 16 (4/0) 2


; cycle count:
; 8+14*4+68520+56+16 = 68656 cycles
; available at 50Hz:
; 40 / 40 / 28 / 320 / 72 / 12 per line, that is 512 cycles per line
; visible 200 lines, but actually: 313 lines per frame, i.e. 160256 cycles per frame
;
; after clrscrn left:
; 160256 - 68656 = 91600 cycles

GenerateClsRout:
	lea FastClsMem,a0
	movem.l ClearReg(pc),d0-d1
	move #571-1,d3
.loop:
	move.l d0,(a0)+
	dbf d3,.loop
	move.l d1,(a0)+
	move.w #$4E75,(a0) ; rts
	rts

ClearReg:
	movem.l d0-d7/a1-a6,-(a0)
	movem.l d0-d5,-(a0)

clr_scr_fast_old:
            lea 160*200(a0),a0
            moveq #0,d0
            move.l d0,d1
            move.l d0,d2
            move.l d0,d3
            move.l d0,d4
            move.l d0,d5
            move.l d0,d6
            move.l d0,d7
            move.l d0,a1
            move.l d0,a2
            move.l d0,a3
            move.l d0,a4
            move.l d0,a5
            move.l d0,a6
            jmp FastClsMem(pc)

FastClsMem:
	ds.l 580
	even


clear_plane:
            ; we start from the back and restore the address/word pairs until we reach the final address
            ; input: a1 - current buffer position
            ;        a0 - buffer start address
            ; destroys d0 and a2
            cmpa.l a1,a0
            beq clear_p_r
            move.w -(a1),d0
            movea.l -(a1),a2
            move.w d0,(a2)
            bra.s clear_plane
clear_p_r:  rts

clear_screen:
	        moveq.l	#0,d1                 ; set 7 + 6 registers to zero
	        moveq.l	#0,d2
	        moveq.l	#0,d3
	        moveq.l	#0,d4
            moveq.l	#0,d5
            moveq.l	#0,d6
            moveq.l	#0,d7
            move.l	d1,a1
            move.l	d1,a2
            move.l	d1,a3
            move.l	d1,a4
            move.l	d1,a5
            move.l	d1,a6

; we leave 36 lines at the bottom for scroll text -> 26240 bytes to clear
            add.w   #160*164,a0
; 1 line (per plane) = 320 pixels = 40 bytes
; 4 planes -> 1 line = 160 bytes
            move.w #125,d0
.loop:
            movem.l	d1-d7/a1-a6,-(a0) ; 13 * 4 = 52 bytes
            movem.l	d1-d7/a1-a6,-(a0) ; 13 * 4 = 52 bytes
            movem.l	d1-d7/a1-a6,-(a0) ; 13 * 4 = 52 bytes
            movem.l	d1-d7/a1-a6,-(a0) ; 13 * 4 = 52 bytes
            dbra d0,.loop
            movem.l	d1-d7/a1,-(a0) ; 32 bytes missing at the end
            rts

clear_screen_old:
            moveq.l #0,d0
            move.w #20*200-1,d1 ; 20 times per line, 200 lines
clear_loop:
            move.l d0,(a0)+ ; zero out plane 1 and 2
            addq.l #4,a0    ; skip planes 3 and 4
            dbra.w d1,clear_loop
            rts

; sprite data is here for the different sizes
;
; 1x1 sprite
    bss
; simply 1 pixel
sprite1:    ds.b 2*1*16 ; single pixel sprite is only 1 word = 2 bytes * 1 (no mask, sprite only) * 16 (shifts)
; 2x2 sprites
sprite2:    ds.b 4*1*2*2*16*5 ; 2 pixel sprites are 2 words = 4 bytes * 1 (no mask, sprite only) * 2 (lines) * 16 (shifts) * 5 (dither variants)
; 3x3 sprites
sprite3:    ds.b 4*1*2*4*16*10 ; 3 pixel sprites are 2 words = 4 bytes * 1 (no mask, sprite only) * 4 (lines - only 3 are used, but 4 is easier to compute) * 16 (shifts) * 10 (dither variants)

addr_to_del: ds.l 512 ; up to 512 addresses to delete
    text