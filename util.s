; misc utility functions

; scan keys
    text
scan_keys:
; see if a key has been pressed; don't wait (BIOS call BCONSTAT).
; returns -1 in d0 if a key was pressed
    move.w  #2,-(sp)        ; look at the keyboard
    move.w  #1,-(sp)        ; was a key pressed?
    trap    #13             ; bios call
    addq.l  #4,sp           ; tidy stack
    rts

waitvbi:     
    move.w    #37,-(sp)
    trap      #14
    addq.l    #2,sp
    rts

swap_screen:
    lea.l     screen,a0
    move.l    (a0),d0
    lsr       #8,d0
;        ; lea.l     $FFFF8201,a0
    move.l    d0,$ffff8200.w

    move.w screenflag,d0
    eor.w #1,d0
    move.w d0,screenflag
    ; tst.w d0

    bne.s swap_screen_2

    move.l  lscreen,screen
    lea     screentable2,a0
    move.l  a0,screentable
    rts

swap_screen_2:
    move.l  pscreen,screen
    lea     screentable1,a0
    move.l  a0,screentable
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

    data
screenflag: dc.w 1