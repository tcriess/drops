; misc utility functions

; scan keys
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

    move.l lscreen,screen
    rts

swap_screen_2:
    move.l pscreen,screen
    rts

screenflag: dc.w 1